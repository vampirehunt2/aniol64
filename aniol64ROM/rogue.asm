; rogue

; Dungeon features
FLOOR		equ '.'
DOOR		equ '/'
STAIR		equ '>'
WALL		equ '#'
PC 			equ '@'

; room record format
; 8 bytes per room
ROOMRECSIZE	equ 10h
MAXROOMS 	equ 6
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

; monster templates (Attack, Defence, Hits, Type, Name (zero-padded to 12 bytes))
NUM_MNST_TEMPLATES equ 1	; how many distinct monster types there are
MonsterTemplates:
 defb 5, 5, 10, 0, "Monster", 0, 0, 0, 0, 0

; monster record format
MNSTRECSIZE equ 05h
MAXMONSTERS equ 32
MINMONSTERS equ 10
Hits		equ 00h
Template	equ 01h		; 2-byte pointer to a template
MnstX		equ 03h
MnstY		equ 04h

; Data structures for the program
Rooms 		equ PROGRAM_DATA + 0
Monsters 	equ PROGRAM_DATA + ROOMRECSIZE * MAXROOMS

DATA 		equ Monsters + MNSTRECSIZE * MAXMONSTERS
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
DungeonLev	equ DATA + 0Ch
Map			equ DATA + 0Dh


MAP_W		equ MAX_X + 1
MAP_H		equ MAX_Y - 1	; saving two lines for status and messages
MAP_SIZE	equ 64 * MAP_H
CELL_W		equ MAP_W / 3
CELL_H		equ MAP_H / 2
ROOMMIN		equ 4
ROOMMAXW	equ CELL_W - 2
ROOMMAXH	equ CELL_H - 2


 defb "rog_main"
rog_main:
	CALL rog_init
	CALL rog_initLevel
	NOP
	CALL rog_play
	RET
 

rog_initLevel:
	CALL clrScr
	LD A, (DungeonLev)
	INC A
	LD (DungeonLev), A
	CALL rog_generateRooms
	CALL rog_drawRooms
	CALL rog_makeConnections
	CALL rog_sanitiseMap
	CALL rog_placeStair
	CALL rog_placePc
	CALL rog_printStatus
	RET
	
rog_printStatus:
	; print points
	PUSH BC
	LD B, 0
	LD C, MAX_Y
	CALL gotoXY
	LD A, 'L'
	CALL putChar
	LD A, ':'
	CALL putChar
	LD A, (DungeonLev)
	CALL bin2Bcd
	PUSH AF
	LD A, C
	ADD A, '0'
	CALL putChar
	LD A, B
	ADD A, '0'
	CALL putChar
	POP AF
	ADD A, '0'
	CALL putChar
	POP BC
	RET


rog_isDirKey:
	CP MOVE_N
	JR Z, .true
	CP MOVE_S
	JR Z, .true
	CP MOVE_W
	JR Z, .true
	CP MOVE_E
	JR Z, .true
	CP MOVE_NE
	JR Z, .true
	CP MOVE_SE
	JR Z, .true
	CP MOVE_NW
	JR Z, .true
	CP MOVE_SW
	JR Z, .true
	LD A, FALSE
	RET
.true:
	LD A, TRUE
	RET
	

rog_play:
	CALL readKey
	LD (Cmd), A
	CALL rog_isDirKey
	CP FALSE
	LD A, (Cmd)
	CALL NZ, rog_move
	CP '>'
	CALL Z, rog_descend
	CP 'Q'
	RET Z
	CALL rog_los
	JP rog_play
	

rog_isMovable:
	CP FLOOR
	JR Z, .true
	CP DOOR
	JR Z, .true
	CP STAIR
	JR Z, .true
	LD A, FALSE
	RET
.true:
	LD A, TRUE
	RET



rog_descend:
	LD A, (PcOn)
	CP STAIR
	RET NZ 		; abort and do nothing if the PC isn't standing on the stairs
	CALL rog_initLevel
	RET



rog_move:
	CP MOVE_N
	JR Z, .moveN
	CP MOVE_S
	JR Z, .moveS
	CP MOVE_W
	JR Z, .moveW
	CP MOVE_E
	JR Z, .moveE
	CP MOVE_SW
	JR Z, .moveSW
	CP MOVE_SE
	JR Z, .moveSE
	CP MOVE_NW
	JR Z, .moveNW
	CP MOVE_NE
	JR Z, .moveNE
.moveN:
	LD A, (PcY)
	DEC A			; Y := Y - 1
	LD C, A
	LD A, (PcX)
	LD B, A
	JR .step
.moveS:
	LD A, (PcY)
	INC A			; Y := Y + 1
	LD C, A
	LD A, (PcX)
	LD B, A
	JR .step
.moveW:
	LD A, (PcY)
	LD C, A
	LD A, (PcX)
	DEC A			; X := X - 1
	LD B, A
	JR .step
.moveE:
	LD A, (PcY)
	LD C, A
	LD A, (PcX)
	INC A			; X := X + 1
	LD B, A
	JR .step
.moveNW:
	LD A, (PcY)
	DEC A			; Y := Y - 1
	LD C, A
	LD A, (PcX)
	DEC A			; X := X - 1
	LD B, A
	JR .step
.moveSW:
	LD A, (PcY)
	INC A			; Y := Y + 1
	LD C, A
	LD A, (PcX)
	DEC A			; X := X - 1
	LD B, A
	JR .step
.moveNE:
	LD A, (PcY)
	DEC A			; Y := Y - 1
	LD C, A
	LD A, (PcX)
	INC A			; X := X + 1
	LD B, A
	JR .step
.moveSE:
	LD A, (PcY)
	INC A			; Y := Y + 1
	LD C, A
	LD A, (PcX)
	INC A			; X := X + 1
	LD B, A
	JR .step
.step:
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


rog_printTile:
	CALL gotoXY
	CALL rog_getChar
	CALL putChar
	RET
	

rog_isTransparent:
	CP FLOOR
	JR Z, .true
	CP DOOR
	JR Z, .true
	CP STAIR
	JR Z, .true
	LD A, FALSE
	RET
.true:
	LD A, TRUE
	RET

	

rog_lookW:
	PUSH BC
	DEC B
	CALL rog_printTile
	CALL rog_isTransparent
	CP FALSE
	JR Z, .end
	DEC B
	DEC C
	CALL rog_printTile
	INC C
	CALL rog_printTile
	INC C 
	CALL rog_printTile
.end:
	POP BC
	RET



rog_lookE:
	PUSH BC
	INC B
	CALL rog_printTile
	CALL rog_isTransparent
	CP FALSE
	JR Z, .end
	INC B
	DEC C
	CALL rog_printTile
	INC C
	CALL rog_printTile
	INC C 
	CALL rog_printTile
.end:
	POP BC
	RET

	

rog_lookN:
	PUSH BC
	DEC C
	CALL rog_printTile
	CALL rog_isTransparent
	CP FALSE
	JR Z, .end
	DEC C
	DEC B
	CALL rog_printTile
	INC B
	CALL rog_printTile
	INC B
	CALL rog_printTile
.end:
	POP BC
	RET

	

rog_lookS:
	PUSH BC
	INC C
	CALL rog_printTile
	CALL rog_isTransparent
	CP FALSE
	JR Z, .end
	INC C
	DEC B
	CALL rog_printTile
	INC B
	CALL rog_printTile
	INC B
	CALL rog_printTile
.end:
	POP BC
	RET

	

rog_lookNW:
	PUSH BC
	DEC B
	DEC C
	CALL rog_printTile
	CALL rog_isTransparent
	CP FALSE
	JR Z, .end
	DEC B
	DEC C
	CALL rog_printTile
.end:
	POP BC
	RET

	

rog_lookNE:
	PUSH BC
	INC B
	DEC C
	CALL rog_printTile
	CALL rog_isTransparent
	CP FALSE
	JR Z, .end
	INC B
	DEC C
	CALL rog_printTile
.end:
	POP BC
	RET

	

rog_lookSW:
	PUSH BC
	DEC B
	INC C
	CALL rog_printTile
	CALL rog_isTransparent
	CP FALSE
	JR Z, .end
	DEC B
	INC C
	CALL rog_printTile
.end:
	POP BC
	RET

	

rog_lookSE:
	PUSH BC
	INC B
	INC C
	CALL rog_printTile
	CALL rog_isTransparent
	CP FALSE
	JR Z, .end
	INC B
	INC C
	CALL rog_printTile
.end:
	POP BC
	RET



rog_los:
	LD A, (PcX)
	LD B, A
	LD A, (PcY)
	LD C, A
	CALL rog_lookE
	CALL rog_lookN
	CALL rog_lookS
	CALL rog_lookW
	CALL rog_lookNE
	CALL rog_lookNW
	CALL rog_lookSE
	CALL rog_lookSW
	RET



rog_init:
	LD A, FALSE
	LD (Echo), A
	LD (Cursor), A
	LD A, 0
	LD (DungeonLev), A
	CALL cursorOff
	CALL rog_initCells
	CALL rog_clearMap
	RET


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
	

rog_getMapAddr:
	PUSH DE
	PUSH BC
	LD L, B
	LD B, 0
	LD E, 6
.loop:
	SLA C
	RL B
	DEC E
	JR NZ, .loop
	LD H, 0
	ADD HL, BC
	LD BC, Map
	ADD HL, BC
	POP BC
	POP DE
	RET

	
rog_putChar:
	CALL rog_getMapAddr
	LD (HL), A
	RET

rog_getChar:
	CALL rog_getMapAddr
	LD A, (HL)
	RET


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



rog_initCell:
	LD A, B
	LD (IY + CellX), A
	LD A, C
	LD (IY + CellY), A
	LD A, FALSE
	LD (IY + RoomConn), A
	RET



rog_generateRooms:
	LD IY, Rooms
	LD B, MAXROOMS
.loop:
	CALL rog_generateRoom
	CALL rog_nextRoom
	DJNZ .loop
	RET



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



rog_drawRooms:
	LD IY, Rooms
	LD B, MAXROOMS
.loop:
	CALL rog_drawRoom
	CALL rog_nextRoom
	DJNZ .loop
	RET 



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
.vLoop:
	LD A, (IY + RoomW)
	LD D, A
	LD A, (IY + RoomX0)
	LD B, A
.hLoop:
	CALL rog_selectRoomChar
	CALL rog_putChar
	INC B
	DEC D
	JR NZ, .hLoop
	INC C
	DEC E
	JR NZ, .vLoop
	POP DE
	POP BC
	RET



rog_selectRoomChar:
	LD A, (IY + RoomX0)
	CP B
	JR Z, .wall
	LD A, (IY + RoomX1)
	CP B
	JR Z, .wall
	LD A, (IY + RoomY0)
	CP C
	JR Z, .wall
	LD A, (IY + RoomY1)
	CP C
	JR Z, .wall
	LD A, FLOOR
	RET
.wall:
	LD A, WALL
	RET



rog_selectCorridorChar:
	PUSH BC
	CALL rog_getChar
	CP WALL
	JR Z, .wall
.floor
	LD A, FLOOR
	JR .end
.wall:
	LD A, (DoorSet)
	CP FALSE
	JR Z, .door
	LD A, FLOOR
	JR .end
.door:
	LD A, TRUE
	LD (DoorSet), A
	LD A, DOOR
.end:
	POP BC
	PUSH AF
	CALL gotoXY
	POP AF
	RET



; moves to te next room record
; room record pointer in IY
rog_nextRoom:
	PUSH BC
	LD B, ROOMRECSIZE
.loop:
	INC IY
	DJNZ .loop
	POP BC
	RET



; returns the number of connected rooms in A
rog_countConnectedRooms:
	LD C, 0
	LD B, MAXROOMS
	LD IY, Rooms
.loop:
	LD A,(IY + RoomConn)
	CP TRUE
	JR NZ, .cont
	INC C
.cont:
	DJNZ .loop
	LD A, C
	RET



; returns the number of unconnected rooms in A
rog_countUnconnectedRooms:
	PUSH IY
	LD C, 0
	LD B, MAXROOMS
	LD IY, Rooms
.loop:
	LD A,(IY + RoomConn)
	CP TRUE
	CALL rog_nextRoom
	JR Z, .cont
	INC C
.cont:
	DJNZ .loop
	LD A, C
	POP IY
	RET



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
.loop:
	DEC B
	JR Z, .end
	CALL rog_nextRoom
	JR .loop
.end:
	POP BC
	POP AF
	RET



; returns a random unconnected room
; total number of unconnected rooms must be passed in A
; returns room record pointer in IY
rog_randomUnconnectedRoom:
	PUSH BC
	CALL rndMod8
	LD B, A
	INC B
	LD IY, Rooms
.loop:
	LD A, (IY + RoomConn)
	CP TRUE
	JR Z, .skip
	DEC B
	JR Z, .end
.skip:
	CALL rog_nextRoom
	JR .loop
.end:
	POP BC
	RET


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
	JR C, .xStep
	LD A, -1
	JR .xCont
.xStep:
	LD A, 1
.xCont:
	LD (xStep), A
	; compute the incrementation step for the Y coeff
	LD A, (Y1)
	LD B, A
	LD A, (Y0)
	CP B
	JR C, .yStep
	LD A, 1
	JR .yCont
.yStep:
	LD A, -1
.yCont:
	LD (yStep), A
	; loop through the horizontal and the vertical parts of the corridor
	LD A, (X0)
	LD B, A
	LD A, (Y0)
	LD C, A
	LD A, FALSE
	LD (DoorSet), A
.xLoop:
	CALL rog_selectCorridorChar
	CALL rog_putChar
	LD A, (X1)
	CP B
	JR Z, .yLoopSetup
	LD A, (xStep)
	ADD A, B
	LD B, A
	JR .xLoop
.yLoopSetup:
	LD A, (Y1)
	LD C, A
	LD A, FALSE
	LD (DoorSet), A
.yLoop:
	CALL rog_selectCorridorChar
	CALL rog_putChar
	LD A, (Y0)
	CP C
	JR Z, .end
	LD A, (yStep)
	ADD A, C
	LD C, A
	JR .yLoop
.end:
	LD A, TRUE
	LD (IY + RoomConn), A
	RET


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
	
; returns a random point in a random room
; x coefficient in B
; y coefficient in C
rog_randomPoint:
	CALL rog_randomRoom
	CALL rog_randomPtInRoom
	RET

rog_randomPlace:
	CALL rog_randomPoint
	CALL rog_putChar
	RET


rog_sanitiseMap:
	LD C, 0
.yLoop:
	LD B, 0
.xLoop:
	CALL rog_getChar
	CP '%'
	JR Z, .wall
	CP DOOR
	JR NZ, .next
	CALL rog_sanitiseDoor
.next:
	INC B
	LD A, MAX_X + 1
	CP B
	JR NZ, .xLoop
	INC C
	LD A, MAX_Y - 1
	CP C
	JR NZ, .yLoop
	RET
.wall:
	LD A, WALL
	CALL rog_putChar
	JR .next


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


rog_checkWall:
	CALL rog_getChar
	CP WALL
	JR Z, .wall
	RET
.wall:
	LD A, (DoorSet)
	INC A
	LD (DoorSet), A
	RET

	
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
	JR NC, .false
	LD D, A
	LD A, (IY + RoomW)
	ADD A, D
	CP B
	JR C, .false	; check if B is greater than RoomX0 + RoomW - 1
	LD A, (IY + RoomY0)
	DEC A
	CP C	; check if C is less or equal to RoomY0 - 1
	JR NC, .false
	LD E, A
	LD A, (IY + RoomH)
	ADD A, E
	CP C
	JR C, .false	; check if C is greater than RoomY0 + RoomH - 1
	LD A, TRUE
	JR .end
.false:
	LD A, FALSE
.end:
	POP DE
	POP AF
	RET

; generating monsters from templates
; generated monsters are pointed to by the Monsters label
rog_generateMonsters:
	LD A, MAXMONSTERS - MINMONSTERS
	CALL rndMod8
	ADD MINMONSTERS
	LD B, A
	LD IX, Monsters
.loop:
	CALL rog_placeMonster
	CALL rog_nextMonster
	DJNZ .loop
	RET

; move to the next monster record
; current monster record passed in IX
; result in IX
rog_nextMonster:
	PUSH BC
	LD B, MNSTRECSIZE
.loop:
	INC IX
	DJNZ .loop		
	POP BC
	RET

; places a random monster in a random place in a random room
; monster record address must be passed in IX
rog_placeMonster:
	PUSH BC
	; select monster type
	LD A, NUM_MNST_TEMPLATES
	LD B, A
	LD A, (DungeonLev)
	CALL u8_min					; don't select monsters with level higher than the current dungeon level
	CALL rndMod8				; randomly select the monster template
	; find the template for the selected type
	LD H, 0
	LD L, A
	LD BC, MNSTRECSIZE
	CALL u16_mul
	LD BC, MonsterTemplates
	CALL u16_add				; template address now in HL
	PUSH HL
	POP IY						; template address now in IY
	; transfer the data from the template to the monster 
	LD A, L						; most data, like the name, the name, the attack, defence etc.
	LD (IX + Template), L		; is taken directly from the templates
	LD (IX + Template + 1), H
	LD A, (IY + Hits)
	LD (IX + Hits), A
	; find a place to put the monster
	CALL rog_randomPoint
	LD (IX + MnstX), B			; TODO, check if the randomly selected spot isn't already occupied
	LD (IX + MnstY), C	
	POP BC
	RET




