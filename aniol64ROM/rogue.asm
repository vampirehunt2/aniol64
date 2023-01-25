; rogue

Rooms equ PROGRAM_DATA + 0 	;

ROOMRECSIZE	equ 10h
MAXROOMS 	equ 6
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


MAP_W		equ MAX_X + 1
MAP_H		equ MAX_Y - 1	; saving two lines for status and messages
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
	CALL rog_sanitiseDoors
	CALL readKey
	JR rog_main
	RET
ENDP 

PROC
rog_init:
	CALL rog_initCells
	RET
ENDP

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
defb "rog_generateRoom"
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
	CALL gotoXY
_hLoop:
	CALL rog_selectRoomChar
	CALL putChar
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
	LD A, '.'
	RET
_wall:
	LD A, '#'
	RET
ENDP

PROC
; checks if two rooms interiors (excluding walls) have any horizontal overlap 
; 	- room records pointed to by IX and IY
; 	- result in A: overlap size or 0 if no overlap
rog_hOverlap:
	PUSH BC
	; compute maximum of the two rooms' X1 coeffs
	LD A, (IX + RoomX0)
	LD B, A
	LD A, (IY + RoomX0)
	CALL u8_max
	INC A				; exclude the wall
	LD C, A	; maximum X0 of the two rooms now in C
	; compute minimum of the two rooms' X1 coeffs
	LD A, (IX + RoomX1)
	DEC A				; exclude the wall
	LD B, A
	LD A, (IY + RoomX1)
	DEC A				; exclude the wall
	CALL u8_min ; minimum X1 of the two rooms now in A
	DEC A		; exclude the wall
	SUB C
	BIT 7, A
	JR Z, _end
	LD A, 0		; no overlap
_end:
	POP BC
	RET
ENDP

PROC
; checks if two rooms interiors (excluding walls) have any vertical overlap 
; 	- room records pointed to by IX and IY
; 	- result in A: overlap size or 0 if no overlap
rog_vOverlap:
	PUSH BC
	; compute maximum of the two rooms' X1 coeffs
	LD A, (IX + RoomY0)
	LD B, A
	LD A, (IY + RoomY0)
	CALL u8_max
	INC A				; exclude the wall
	LD C, A	; maximum X0 of the two rooms now in C
	; compute minimum of the two rooms' X1 coeffs
	LD A, (IX + RoomY1)
	DEC A				; exclude the wall
	LD B, A
	LD A, (IY + RoomY1)
	DEC A				; exclude the wall
	CALL u8_min ; minimum X1 of the two rooms now in A
	DEC A		; exclude the wall
	SUB C
	BIT 7, A
	JR Z, _end
	LD A, 0		; no overlap
_end:
	POP BC
	RET
ENDP

PROC
rog_selectCorridorChar:
	PUSH BC
	CALL getChar
	CP '#'
	JR Z, _wall
_floor
	LD A, '.'
	JR _end
_wall:
	LD A, (DoorSet)
	CP FALSE
	JR Z, _door
	LD A, '.'
	JR _end
_door:
	LD A, TRUE
	LD (DoorSet), A
	LD A, '+'
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
	CALL gotoXY
	CALL rog_selectCorridorChar
	CALL putChar
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
	CALL gotoXY
	CALL rog_selectCorridorChar
	CALL putChar
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

PROC
rog_sanitiseDoors:
	LD C, 1
_yLoop:
	LD B, 1
	CALL gotoXY
_xLoop:
	CALL getChar
	CP '+'
	JR NZ, _notDoor
	CALL rog_sanitiseDoor
_notDoor:
	INC B
	LD A, MAX_X - 1
	CP B
	JR NZ, _xLoop
	INC C
	LD A, MAX_Y - 1
	JR NZ, _yLoop
	RET
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
	CALL gotoXY
	LD A, '.'
	CALL putChar
	POP BC
	RET

PROC
rog_checkWall:
	CALL gotoXY
	CALL getChar
	CP '#'
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

