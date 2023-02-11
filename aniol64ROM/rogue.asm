; rogue

Rooms equ PROGRAM_DATA + 0 	;

ROOMRECSIZE	equ 10h
MAXROOMS 	equ 6
FLOOR		equ '.'
DOOR		equ '/'
STAIR		equ '>'
WALL		equ '#'
PC 			equ '@'

; room record format
; 8 bytes per room
RoomX0 		equ 00h
RoomY0 		equ 01h
RoomX1		equ 02h
RoomY1		equ 03h
RoomW 		equ 04h
RoomH 		equ 05h
CellX		equ 06h
CellY		equ 07h
CellW 		equ 08h
CellH		equ 09h
RoomConn 	equ 0Ah
RoomFlg		equ 0Bh

DATA 		equ PROGRAM_DATA + ROOMRECSIZE * MAXROOMS
Crossover	equ DATA + 00h
xStep		equ DATA + 01h
yStep		equ DATA + 02h
X0			equ DATA + 03h
Y0			equ DATA + 04h
X1			equ DATA + 05h
Y1			equ DATA + 06h
DoorSet		equ DATA + 07h
PcX			equ DATA + 08h
PcY			equ DATA + 09h
PcOn		equ DATA + 0Ah	; the character on the tile the PC is standing on
Cmd			equ DATA + 0Bh
Map			equ DATA + 0Ch


MAP_W		equ MAX_X + 1
MAP_H		equ MAX_Y - 1	; saving two lines for status and messages
MAP_SIZE	equ 64 * MAP_H
CELL_W		equ MAP_W / 3
CELL_H		equ MAP_H / 2
ROOMMIN		equ 4
ROOMMAXW	equ CELL_W - 2
ROOMMAXH	equ CELL_H - 2

PROC
defb "rog_main"
rog_main:
	CALL rog_init
	CALL clrScr
	CALL rog_generateRooms
	CALL rog_drawRooms
	CALL rog_makeConnections
	CALL rog_sanitiseMap
	CALL rog_placeStair
	CALL rog_placePc
	NOP
	CALL rog_play
	RET
ENDP 


rog_play:
	CALL readKey
	LD (Cmd), A
	CALL isDecDigit
	CP FALSE
	LD A, (Cmd)
	CALL NZ, rog_move
	CP 'Q'
	RET Z
	CALL rog_los
	JP rog_play
	
PROC
rog_isMovable:
	CP FLOOR
	JR Z, _true
	CP DOOR
	JR Z, _true
	CP STAIR
	JR Z, _true
	LD A, FALSE
	RET
_true:
	LD A, TRUE
	RET
ENDP

PROC
rog_move:
	CP '8'
	JR Z, _moveN
	CP '2'
	JR Z, _moveS
	CP '4'
	JR Z, _moveW
	CP '6'
	JR Z, _moveE
	CP '1'
	JR Z, _moveSW
	CP '3'
	JR Z, _moveSE
	CP '7'
	JR Z, _moveNW
	CP '9'
	JR Z, _moveNE
_moveN:
	LD A, (PcY)
	DEC A			; Y := Y - 1
	LD C, A
	LD A, (PcX)
	LD B, A
	JR _step
_moveS:
	LD A, (PcY)
	INC A			; Y := Y + 1
	LD C, A
	LD A, (PcX)
	LD B, A
	JR _step
_moveW:
	LD A, (PcY)
	LD C, A
	LD A, (PcX)
	DEC A			; X := X - 1
	LD B, A
	JR _step
_moveE:
	LD A, (PcY)
	LD C, A
	LD A, (PcX)
	INC A			; X := X + 1
	LD B, A
	JR _step
_moveNW:
	LD A, (PcY)
	DEC A			; Y := Y - 1
	LD C, A
	LD A, (PcX)
	DEC A			; X := X - 1
	LD B, A
	JR _step
_moveSW:
	LD A, (PcY)
	INC A			; Y := Y + 1
	LD C, A
	LD A, (PcX)
	DEC A			; X := X - 1
	LD B, A
	JR _step
_moveNE:
	LD A, (PcY)
	DEC A			; Y := Y - 1
	LD C, A
	LD A, (PcX)
	DEC A			; X := X - 1
	LD B, A
	JR _step
_moveSE:
	LD A, (PcY)
	INC A			; Y := Y + 1
	LD C, A
	LD A, (PcX)
	INC A			; X := X + 1
	LD B, A
	JR _step
_step:
	CALL rog_getChar
	CALL rog_isMovable
	CP FALSE
	RET Z		; skip if the tile cannot be moved onto
	LD D, B		; save new X coordinate in D
	LD E, C		; save new Y coordinate in E
	LD A, (PcX)
	LD B, A
	LD A, (PcY)
	LD C, A
	LD A, (PcOn)
	CALL rog_putChar  	; remove the PC character and draw whatever it was standing on
	LD B, D
	LD C, E 			; restore new XY coordinates 
	CALL rog_getChar
	LD (PcOn), A		; save the tile the PC will be standing on
	CALL gotoXY
	LD A, PC
	CALL putChar
	LD A, B
	LD (PcX), A 		; store new X coordinates
	LD A, C
	LD (PcY), A
	RET
ENDP

rog_printTile:
	CALL gotoXY
	CALL rog_getChar
	CALL putChar
	RET
	
PROC
rog_isTransparent:
	CP FLOOR
	JR Z, _true
	CP DOOR
	JR Z, _true
	CP STAIR
	JR Z, _true
	LD A, FALSE
	RET
_true:
	LD A, TRUE
	RET
ENDP
	
PROC
rog_lookW:
	PUSH BC
	DEC B
	CALL rog_printTile
	CALL rog_isTransparent
	CP FALSE
	JR Z, _end
	DEC B
	DEC C
	CALL rog_printTile
	INC C
	CALL rog_printTile
	INC C 
	CALL rog_printTile
_end:
	POP BC
	RET
ENDP

PROC
rog_lookE:
	PUSH BC
	INC B
	CALL rog_printTile
	CALL rog_isTransparent
	CP FALSE
	JR Z, _end
	INC B
	DEC C
	CALL rog_printTile
	INC C
	CALL rog_printTile
	INC C 
	CALL rog_printTile
_end:
	POP BC
	RET
ENDP
	
PROC
rog_lookN:
	PUSH BC
	DEC C
	CALL rog_printTile
	CALL rog_isTransparent
	CP FALSE
	JR Z, _end
	DEC C
	DEC B
	CALL rog_printTile
	INC B
	CALL rog_printTile
	INC B
	CALL rog_printTile
_end:
	POP BC
	RET
ENDP
	
PROC
rog_lookS:
	PUSH BC
	INC C
	CALL rog_printTile
	CALL rog_isTransparent
	CP FALSE
	JR Z, _end
	INC C
	DEC B
	CALL rog_printTile
	INC B
	CALL rog_printTile
	INC B
	CALL rog_printTile
_end:
	POP BC
	RET
ENDP
	
PROC
rog_lookNW:
	PUSH BC
	DEC B
	DEC C
	CALL rog_printTile
	CALL rog_isTransparent
	CP FALSE
	JR Z, _end
	DEC B
	DEC C
	CALL rog_printTile
_end:
	POP BC
	RET
ENDP
	
PROC
rog_lookNE:
	PUSH BC
	INC B
	DEC C
	CALL rog_printTile
	CALL rog_isTransparent
	CP FALSE
	JR Z, _end
	INC B
	DEC C
	CALL rog_printTile
_end:
	POP BC
	RET
ENDP
	
PROC
rog_lookSW:
	PUSH BC
	DEC B
	INC C
	CALL rog_printTile
	CALL rog_isTransparent
	CP FALSE
	JR Z, _end
	DEC B
	INC C
	CALL rog_printTile
_end:
	POP BC
	RET
ENDP
	
PROC
defb "rog_lookSE"
rog_lookSE:
	PUSH BC
	INC B
	INC C
	CALL rog_printTile
	CALL rog_isTransparent
	CP FALSE
	JR Z, _end
	INC B
	INC C
	CALL rog_printTile
_end:
	POP BC
	RET
ENDP

PROC
rog_los:
	CALL rog_lookE
	CALL rog_lookN
	CALL rog_lookS
	CALL rog_lookW
	CALL rog_lookNE
	CALL rog_lookNW
	CALL rog_lookSE
	CALL rog_lookSW
	RET
ENDP

PROC
rog_init:
	LD A, FALSE
	LD (Echo), A
	CALL cursorOff
	CALL rog_initCells
	CALL rog_clearMap
	RET
ENDP

; DEBUG only
;rog_displayEntireMap:
;	LD HL, Map
;	LD DE, VRAM
;	LD BC, MAP_SIZE
;	LDIR
;	RET

rog_clearMap:
	LD A, '%'
	LD (Map), A
	LD HL, Map
	LD DE, Map + 1
	LD BC, MAP_SIZE
	LDIR
	RET
	
PROC
rog_getMapAddr:
	PUSH DE
	PUSH BC
	LD L, B
	LD B, 0
	LD E, 6
_loop:
	SLA C
	RL B
	DEC E
	JR NZ, _loop
	LD H, 0
	ADD HL, BC
	LD BC, Map
	ADD HL, BC
	POP BC
	POP DE
	RET
ENDP
	
rog_putChar:
	CALL rog_getMapAddr
	LD (HL), A
	RET

rog_getChar:
	CALL rog_getMapAddr
	LD A, (HL)
	RET

PROC
rog_initCells:
	LD IY, Rooms
	LD B, 0
	LD C, 0
	CALL rog_initCell
	CALL rog_nextRoom
	LD B, CELL_W
	CALL rog_initCell
	CALL rog_nextRoom
	LD B, CELL_W * 2
	CALL rog_initCell
	CALL rog_nextRoom
	LD B, 0
	LD C, CELL_H
	CALL rog_initCell
	CALL rog_nextRoom
	LD B, CELL_W
	CALL rog_initCell
	CALL rog_nextRoom
	LD B, CELL_W * 2
	CALL rog_initCell
	RET
ENDP

PROC
rog_initCell:
	LD A, B
	LD (IY + CellX), A
	LD A, C
	LD (IY + CellY), A
	LD A, FALSE
	LD (IY + RoomConn), A
	RET
ENDP

PROC
rog_generateRooms:
	LD IY, Rooms
	LD B, MAXROOMS
_loop:
	CALL rog_generateRoom
	CALL rog_nextRoom
	DJNZ _loop
	RET
ENDP

PROC
rog_generateRoom:
	PUSH BC
	; randomize X position
	LD A, CELL_W - ROOMMIN - 2
	CALL rndMod8
	LD C, A
	LD A, (IY + CellX)
	ADD A, C
	INC A
	LD (IY + RoomX0), A
	; randomize width
	LD A, (IY + CellX)
	LD C, A
	LD A, (IY + RoomX0)
	SUB C
	LD C, A
	LD A, CELL_W
	SUB C
	LD C, ROOMMIN
	SUB C
	CALL rndMod8
	ADD A, ROOMMIN
	LD (IY + RoomW), A
	LD B, A
	LD A, (IY + RoomX0)
	ADD A, B
	DEC A
	LD (IY + RoomX1), A
	; randomize Y position
	LD A, CELL_H - ROOMMIN - 2
	CALL rndMod8
	LD C, A
	LD A, (IY + CellY)
	ADD A, C
	INC A
	LD (IY + RoomY0), A
	; randomize height
	LD A, (IY + CellY)
	LD C, A
	LD A, (IY + RoomY0)
	SUB C
	LD C, A
	LD A, CELL_H
	SUB C
	LD C, ROOMMIN
	SUB C
	CALL rndMod8
	ADD A, ROOMMIN
	LD (IY + RoomH), A
	LD B, A
	LD A, (IY + RoomY0)
	ADD A, B
	DEC A
	LD (IY + RoomY1), A
	LD A, FALSE
	LD (IY + RoomConn), A
	POP BC
	RET
ENDP

PROC
rog_drawRooms:
	LD IY, Rooms
	LD B, MAXROOMS
_loop:
	CALL rog_drawRoom
	CALL rog_nextRoom
	DJNZ _loop
	RET 
ENDP

PROC
; draws a room on screen
; room record pointed to by IY
; destroys A
rog_drawRoom:
	PUSH BC
	PUSH DE
	LD A, (IY + RoomH)
	LD E, A
	LD A, (IY + RoomY0)
	LD C, A
_vLoop:
	LD A, (IY + RoomW)
	LD D, A
	LD A, (IY + RoomX0)
	LD B, A
_hLoop:
	CALL rog_selectRoomChar
	CALL rog_putChar
	INC B
	DEC D
	JR NZ, _hLoop
	INC C
	DEC E
	JR NZ, _vLoop
	POP DE
	POP BC
	RET
ENDP

PROC
rog_selectRoomChar:
	LD A, (IY + RoomX0)
	CP B
	JR Z, _wall
	LD A, (IY + RoomX1)
	CP B
	JR Z, _wall
	LD A, (IY + RoomY0)
	CP C
	JR Z, _wall
	LD A, (IY + RoomY1)
	CP C
	JR Z, _wall
	LD A, FLOOR
	RET
_wall:
	LD A, WALL
	RET
ENDP

PROC
rog_selectCorridorChar:
	PUSH BC
	CALL rog_getChar
	CP WALL
	JR Z, _wall
_floor
	LD A, FLOOR
	JR _end
_wall:
	LD A, (DoorSet)
	CP FALSE
	JR Z, _door
	LD A, FLOOR
	JR _end
_door:
	LD A, TRUE
	LD (DoorSet), A
	LD A, DOOR
_end:
	POP BC
	PUSH AF
	CALL gotoXY
	POP AF
	RET
ENDP

PROC
; moves to te next room record
; room record pointer in IY
rog_nextRoom:
	PUSH BC
	LD B, ROOMRECSIZE
_loop:
	INC IY
	DJNZ _loop
	POP BC
	RET
ENDP

PROC
; returns the number of connected rooms in A
rog_countConnectedRooms:
	LD C, 0
	LD B, MAXROOMS
	LD IY, Rooms
_loop:
	LD A,(IY + RoomConn)
	CP TRUE
	JR NZ, _cont
	INC C
_cont:
	DJNZ _loop
	LD A, C
	RET
ENDP

PROC
; returns the number of unconnected rooms in A
rog_countUnconnectedRooms:
	PUSH IY
	LD C, 0
	LD B, MAXROOMS
	LD IY, Rooms
_loop:
	LD A,(IY + RoomConn)
	CP TRUE
	CALL rog_nextRoom
	JR Z, _cont
	INC C
_cont:
	DJNZ _loop
	LD A, C
	POP IY
	RET
ENDP

PROC
; returns a random unconnected room
; returns room record pointer in IY
rog_randomRoom:
	PUSH AF
	PUSH BC
	LD A, MAXROOMS
	CALL rndMod8
	LD B, A
	INC B
	LD IY, Rooms
_loop:
	DEC B
	JR Z, _end
	CALL rog_nextRoom
	JR _loop
_end:
	POP BC
	POP AF
	RET
ENDP

PROC
; returns a random unconnected room
; total number of unconnected rooms must be passed in A
; returns room record pointer in IY
rog_randomUnconnectedRoom:
	PUSH BC
	CALL rndMod8
	LD B, A
	INC B
	LD IY, Rooms
_loop:
	LD A, (IY + RoomConn)
	CP TRUE
	JR Z, _skip
	DEC B
	JR Z, _end
_skip:
	CALL rog_nextRoom
	JR _loop
_end:
	POP BC
	RET
ENDP

rog_makeConnections:
	LD A, MAXROOMS
	CALL rog_randomUnconnectedRoom
	LD A, TRUE
	LD (IY + RoomConn), A
	CALL rog_connectRooms
	RET

rog_connectRooms:
	CALL rog_countUnconnectedRooms
	CP 0
	RET Z
	PUSH IY
	POP IX
	CALL rog_randomUnconnectedRoom
	CALL rog_connectRoom
	JR rog_connectRooms
	
PROC
; connects a room pointed to by IX 
; to a previously unconnected room
; pointed to by IY
rog_connectRoom:
	PUSH IX		; store room record pointers
	PUSH IY
	CALL rog_randomPtInRoom
	LD A, B
	LD (X0), A
	LD A, C
	LD (Y0), A
	PUSH IX		; move room record from IX to IY
	POP IY
	CALL rog_randomPtInRoom
	POP IY		; restore room record pointers
	POP IX
	LD A, B
	LD (X1), A
	LD A, C
	LD (Y1), A
	; compute the incrementation step for the X coeff
	LD A, (X1)
	LD B, A
	LD A, (X0)
	CP B
	JR C, _xStep
	LD A, -1
	JR _xCont
_xStep:
	LD A, 1
_xCont:
	LD (xStep), A
	; compute the incrementation step for the Y coeff
	LD A, (Y1)
	LD B, A
	LD A, (Y0)
	CP B
	JR C, _yStep
	LD A, 1
	JR _yCont
_yStep:
	LD A, -1
_yCont:
	LD (yStep), A
	; loop through the horizontal and the vertical parts of the corridor
	LD A, (X0)
	LD B, A
	LD A, (Y0)
	LD C, A
	LD A, FALSE
	LD (DoorSet), A
_xLoop:
	CALL rog_selectCorridorChar
	CALL rog_putChar
	LD A, (X1)
	CP B
	JR Z, _yLoopSetup
	LD A, (xStep)
	ADD A, B
	LD B, A
	JR _xLoop
_yLoopSetup:
	LD A, (Y1)
	LD C, A
	LD A, FALSE
	LD (DoorSet), A
_yLoop:
	CALL rog_selectCorridorChar
	CALL rog_putChar
	LD A, (Y0)
	CP C
	JR Z, _end
	LD A, (yStep)
	ADD A, C
	LD C, A
	JR _yLoop
_end:
	LD A, TRUE
	LD (IY + RoomConn), A
	RET
ENDP

rog_placeStair:
	LD A, STAIR
	CALL rog_randomPlace
	RET
	
rog_placePc:
	LD A, PC
	CALL rog_randomPoint
	LD A, B
	LD (PcX), A
	LD A, C
	LD (PcY), A
	CALL rog_getChar
	LD (PcOn), A
	CALL gotoXY
	LD A, PC
	CALL putChar
	CALL rog_los
	RET
	
rog_randomPoint:
	CALL rog_randomRoom
	CALL rog_randomPtInRoom
	RET

rog_randomPlace:
	CALL rog_randomPoint
	CALL rog_putChar
	RET

PROC
rog_sanitiseMap:
	LD C, 0
_yLoop:
	LD B, 0
_xLoop:
	CALL rog_getChar
	CP '%'
	JR Z, _wall
	CP DOOR
	JR NZ, _next
	CALL rog_sanitiseDoor
_next:
	INC B
	LD A, MAX_X + 1
	CP B
	JR NZ, _xLoop
	INC C
	LD A, MAX_Y - 1
	CP C
	JR NZ, _yLoop
	RET
_wall:
	LD A, WALL
	CALL rog_putChar
	JR _next
ENDP

rog_sanitiseDoor:
	PUSH BC
	LD A, 0
	LD (DoorSet), A
	DEC B
	CALL rog_checkWall
	INC B
	INC B
	CALL rog_checkWall
	DEC B
	DEC C
	CALL rog_checkWall
	INC C
	INC C
	CALL rog_checkWall
	POP BC
	LD A, (DoorSet)
	CP 2
	RET Z
	PUSH BC
	LD A, FLOOR
	CALL rog_putChar
	POP BC
	RET

PROC
rog_checkWall:
	CALL rog_getChar
	CP WALL
	JR Z, _wall
	RET
_wall:
	LD A, (DoorSet)
	INC A
	LD (DoorSet), A
	RET
ENDP
	
; returns a random point within a room
; room pointed to by IY
; result:
; - X coefficient in B
; - Y coefficient in C
rog_randomPtInRoom:
	PUSH AF
	LD A, (IY + RoomW)
	DEC A
	DEC A
	CALL rndMod8
	INC A
	LD B, A
	LD A, (IY + RoomX0)
	ADD A, B
	LD B, A
	LD A, (IY + RoomH)
	DEC A
	DEC A
	CALL rndMod8
	INC A
	LD C, A
	LD A, (IY + RoomY0)
	ADD A, C
	LD C, A
	POP AF
	RET

PROC
; checks whether a point is within a room, including the walls
; 	BC - XY coordinates of the point
; 	IY - points to room record
; 	result in A	
rog_isPointInRoom:
	PUSH AF
	PUSH DE
	LD A, (IY + RoomX0)
	DEC A
	CP B	; check if B is less or equal to RoomX0 - 1
	JR NC, _false
	LD D, A
	LD A, (IY + RoomW)
	ADD A, D
	CP B
	JR C, _false	; check if B is greater than RoomX0 + RoomW - 1
	LD A, (IY + RoomY0)
	DEC A
	CP C	; check if C is less or equal to RoomY0 - 1
	JR NC, _false
	LD E, A
	LD A, (IY + RoomH)
	ADD A, E
	CP C
	JR C, _false	; check if C is greater than RoomY0 + RoomH - 1
	LD A, TRUE
	JR _end
_false:
	LD A, FALSE
_end:
	POP DE
	POP AF
	RET
ENDP

