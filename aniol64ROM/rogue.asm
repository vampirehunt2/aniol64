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
	; randomize X position
	LD C, CELLW - ROOMMIN - 2
	CALL rndMod
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
	LD C, A
	CALL rndMod
	ADD A, ROOMMIN
	LD (IY + RoomW), A
	; randomize Y position
	LD C, CELLH - ROOMMIN - 2
	CALL rndMod
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
	LD C, A
	CALL rndMod
	ADD A, ROOMMIN
	LD (IY + RoomH), A
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
defb "rog_drawRoom"
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

