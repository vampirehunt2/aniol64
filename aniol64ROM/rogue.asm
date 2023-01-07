; rogue

Rooms equ PROGRAM_DATA + 0 	;

ROOMRECSIZE	equ 8
MAXROOMS 	equ 6
; room record format
; 8 bytes per room
RoomX 		equ 0
RoomY 		equ 1
CellX		equ 2
CellY		equ 3
RoomW 		equ 4
RoomH 		equ 5
RoomConn 	equ 6
RoomFlg		equ 7

Crossover	equ PROGRAM_DATA + 48
xStep		equ PROGRAM_DATA + 49
yStep		equ PROGRAM_DATA + 50
X0			equ PROGRAM_DATA + 51
Y0			equ PROGRAM_DATA + 52
X1			equ PROGRAM_DATA + 53
Y1			equ PROGRAM_DATA + 54


MAPW		equ 40
MAPH		equ 30
CELLW		equ MAPW / 3
CELLH		equ MAPH / 2
ROOMMIN		equ 4
ROOMMAXW	equ CELLW - 2
ROOMMAXH	equ CELLH - 2



PROC
defb "rog_main"
rog_main:
	CALL rog_init
	CALL vga_clrScr
	CALL rog_generateRooms
	CALL rog_drawRooms
	CALL rog_makeConnections
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
	LD B, CELLW
	CALL rog_initCell
	CALL rog_nextRoom
	LD B, CELLW * 2
	CALL rog_initCell
	CALL rog_nextRoom
	LD B, 0
	LD C, CELLH
	CALL rog_initCell
	CALL rog_nextRoom
	LD B, CELLW
	CALL rog_initCell
	CALL rog_nextRoom
	LD B, CELLW * 2
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
	LD A, CELLW - ROOMMIN - 2
	CALL rndMod8
	LD C, A
	LD A, (IY + CellX)
	ADD A, C
	INC A
	LD (IY + RoomX), A
	; randomize width
	LD A, (IY + CellX)
	LD C, A
	LD A, (IY + RoomX)
	SUB C
	LD C, A
	LD A, CELLW
	SUB C
	LD C, ROOMMIN
	SUB C
	CALL rndMod8
	ADD A, ROOMMIN
	LD (IY + RoomW), A
	; randomize Y position
	LD A, CELLH - ROOMMIN - 2
	CALL rndMod8
	LD C, A
	LD A, (IY + CellY)
	ADD A, C
	INC A
	LD (IY + RoomY), A
	; randomize height
	LD A, (IY + CellY)
	LD C, A
	LD A, (IY + RoomY)
	SUB C
	LD C, A
	LD A, CELLH
	SUB C
	LD C, ROOMMIN
	SUB C
	CALL rndMod8
	ADD A, ROOMMIN
	LD (IY + RoomH), A
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
	; check if room exists
	LD A, (IY + RoomW) 	
	CP 0				
	JR Z, _end
	; draw horizontal lines
	LD A, (IY + RoomX)
	LD B, A				; room x0 now in B
	LD A, (IY + RoomW)
	;DEC A
	ADD A, B
	LD D, A				; room x1 now in D
	LD A, (IY + RoomH)
	DEC A
	LD E, A
	LD A, (IY + RoomY)
	ADD A, E
	LD E, A				; room y1 now in E
_loop1:
	LD A, (IY + RoomY)
	LD C, A
	CALL vga_gotoXY
	LD A, '#'
	CALL vga_putChar
	LD C, E
	CALL vga_gotoXY
	LD A, '#'
	CALL vga_putChar
	INC B
	LD A, B
	CP D
	JR NZ, _loop1
	; draw vertical lines
	LD A, (IY + RoomY)
	LD C, A				; room y0 now in C
	LD A, (IY + RoomH)
	;DEC A
	ADD A, C
	LD E, A				; room y1 now in E
	LD A, (IY + RoomW)
	DEC A
	LD D, A
	LD A, (IY + RoomX)
	ADD A, D
	LD D, A				; room x1 now in D
_loop2:
	LD A, (IY + RoomX)
	LD B, A
	CALL vga_gotoXY
	LD A, '#'
	CALL vga_putChar
	LD B, D
	CALL vga_gotoXY
	LD A, '#'
	CALL vga_putChar
	INC C
	LD A, C
	CP E
	JR NZ, _loop2
_end:
	POP DE
	POP BC
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

defb "rog_connectRooms"
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
	PUSH IX
	PUSH IY
	CALL rog_randomPtInRoom
	LD A, B
	LD (X0), A
	LD A, C
	LD (Y0), A
	PUSH IX
	POP IY
	CALL rog_randomPtInRoom
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
	LD A, -1
	JR _yCont
_yStep:
	LD A, 1
_yCont:
	LD (yStep), A
	;
	LD A, (X0)
	LD B, A
	LD A, (Y0)
	LD C, A
_xLoop:
	CALL vga_gotoXY
	LD A, '.'
	CALL vga_putChar
	LD A, (X1)
	CP B
	JR Z, _yLoop
	LD A, (xStep)
	ADD A, B
	LD B, A
	JR _xLoop
_yLoop:
	CALL vga_gotoXY
	LD A, '.'
	CALL vga_putChar
	LD A, (Y1)
	CP C
	JR Z, _end
	LD A, (yStep)
	ADD A, C
	LD C, A
	JR _yLoop
_end:
	POP IY
	POP IX
	LD A, TRUE
	LD (IY + RoomConn), A
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
	LD A, (IY + RoomX)
	ADD A, B
	LD B, A
	LD A, (IY + RoomH)
	DEC A
	DEC A
	CALL rndMod8
	INC A
	LD C, A
	LD A, (IY + RoomY)
	ADD A, C
	LD C, A
	RET

