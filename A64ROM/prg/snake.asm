; SNAKE

Head	    equ PROGRAM_DATA + 0
Tail	    equ PROGRAM_DATA + 1
Points	  equ PROGRAM_DATA + 2
Level	   equ PROGRAM_DATA + 3
DelayCounter    equ PROGRAM_DATA + 4
Dir		    equ PROGRAM_DATA + 5
Coeffs	  equ PROGRAM_DATA + 6
DelayVal	equ PROGRAM_DATA + 8

SnakeScreen     equ PROGRAM_DATA + 10

NORTH   equ 0
SOUTH   equ 1
EAST    equ 2
WEST    equ 3

WIDTH   equ 32
HEIGHT  equ 20
VOFFSET equ 1
HOFFSET equ (MAX_X + 1 - WIDTH) / 2

FRAME1: 
    ds HOFFSET, ' ' 
    ds WIDTH, '#' 
    defb 0

FRAME2: 
    ds HOFFSET, ' '
    defb '#'
    ds WIDTH - 2, '.'
    defb '#', 0

SnakeStr: defb "SNAKE", 0 

GameOver: defb "GAME OVER!!!", 0


snake_main:
	CALL snake_init
.loop:
	CALL keyPressed
	JR Z, .move
	CALL readKey
	CP 'k'
	JP Z, .n
	CP 'n'
	JP Z, .s
	CP 'b'
	JP Z, .w
	CP 'm'
	JP Z, .e
	CP '8'
	JP Z, .n
	CP '2'
	JP Z, .s
	CP '4'
	JP Z, .w
	CP '6'
	JP Z, .e
	CP 'q'
	RET Z
	JP .move
.n:	LD A, NORTH
	LD (Dir), A
	JP .move
.s:	LD A, SOUTH
	LD (Dir), A
	JP .move
.e:	LD A, EAST
	LD (Dir), A
	JP .move
.w:	LD A, WEST
	LD (Dir), A
	JP .move
.move:
	CALL snake_move
	LD A, 10
	CALL delay
	JR .loop
	RET


snake_init:
	CALL clrScr
	CALL snake_drawFrame
	LD A, 0
	LD (Echo), A		; turn echo off
	LD (Cursor), A		; turn cursor off
	LD (Head), A		; set the first item in the Coeffs table to be the current one
	LD (Tail), A		; set tail to be at the same place as the head (length of the snake is zero)
	LD (Points), A		; zero the points
	INC A
	LD (Level), A		; set level to 1
	LD A, 10
	LD (DelayVal), A
	CALL cursorOff
	LD IX, Coeffs
	LD A, (MAX_X + 1) / 2
	LD (IX), A
	LD A, (MAX_Y + 1) / 2
	LD (IX + 1), A
	CALL rnd
	AND 00000011b		; randomly select the direction
	LD (Dir), A
	CALL snake_placeDollar  
	RET 

snake_move:	
	PUSH AF
	CALL snake_getHeadCoeffs
	LD D, (HL)		; current head X in D		
	INC HL
	LD E, (HL)		; current head Y in E			
	LD A, (Dir)
	CP NORTH
	JP Z, .n
	CP SOUTH
	JP Z, .s
	CP EAST
	JP Z, .e
	CP WEST
	JP Z, .w
.n:
	DEC E
	JP .cont
.s:
	INC E
	JP .cont
.e:
	INC D
	JP .cont
.w:
	DEC D
	JP .cont
.cont: 
	LD A, (Head)
	INC A
	INC A
	LD (Head), A 	; store new head index
	CALL snake_getHeadCoeffs
	LD (HL), D		; store new head X
	INC HL
	LD (HL), E		; store new head Y
	CALL snake_moveHead
	LD A, D
	CP '$'
	JR Z, .dollar	; if point is scored skip moving the tail, let the snake grow
	CP '#'
	JP Z, snake_gameOver
	CP '*'
	JP Z, snake_gameOver
	CALL snake_moveTail
	LD A, (Tail)
	INC A
	INC A
	LD (Tail), A	 ; move tail by one (two indices into the Coeffs table)
	JR .end
.dollar:
	LD A, (Points)
	INC A
	LD (Points), A
	CP 20
	JR Z, .pts20
	CP 40
	JR Z, .pts40
	JR .cont2
.pts20:
	LD A, 8
	LD (DelayVal), A
	JR .cont2
.pts40:
	LD A, 6
	LD (DelayVal), A
	;JR .cont2
.cont2:
	CALL bzr_click
	CALL snake_printPoints
	CALL snake_placeDollar
	CALL snake_placeWall
.end:
	POP AF
	RET	

snake_putChar:
    PUSH HL
    PUSH BC
    PUSH AF
    LD A, (CurY)
    LD H, A
    LD A, (CurX)
    LD L, A
    LD BC, SnakeScreen
    ADD HL, BC
    POP AF
    LD (HL), A
    CALL putChar
    POP BC
    POP HL
    RET

snake_getChar:
    PUSH HL
    PUSH BC
    LD A, (CurY)
    LD H, A
    LD A, (CurX)
    LD L, A
    LD BC, SnakeScreen
    ADD HL, BC
    LD A, (HL)
    POP BC
    POP HL
    RET

snake_writeStr:
    PUSH IX
.loop:
    LD A, (IX)
    CP 0
    JR Z, .end
    CALL snake_putChar
    INC IX
    JR .loop
.end:
    POP IX
    RET
	

snake_printPoints:
	PUSH BC
	LD B, HOFFSET
	LD C, VOFFSET + HEIGHT
	CALL gotoXY
	LD A, '$'
	CALL putChar
	LD A, ':'
	CALL putChar
	LD A, (Points)
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

snake_gameOver:
	CALL clrScr
	LD B, 14
	LD C, 10
	CALL gotoXY
	LD IX, GameOver
	CALL writeStr
	CALL resetNmiHandler
	CALL bzr_beep
	CALL readKey
	JP snake_main

; returns previous char at new head location in D
snake_moveHead:
	CALL snake_getHeadCoeffs
	LD B, (HL)
	INC HL
	LD C, (HL)
	CALL gotoXY
	CALL snake_getChar
	LD D, A
	CALL gotoXY
	LD A, '*'
	CALL snake_putChar
	RET 
	
snake_moveTail:
	CALL snake_getTailCoeffs
	LD B, (HL)
	INC HL
	LD C, (HL)
	CALL gotoXY
	LD A, '.'
	CALL snake_putChar
	RET 
	
; returns head coefficient in (HL) and (HL + 1)	
snake_getHeadCoeffs:
	LD HL, Coeffs
	LD B, 0
	LD A, (Head)
	LD C, A
	ADD HL, BC		; current head coefficient now in (HL) and (HL + 1)
	RET
	
; returns tail coefficient in (HL) and (HL + 1)
snake_getTailCoeffs:
	LD HL, Coeffs
	LD B, 0
	LD A, (Tail)
	LD C, A
	ADD HL, BC		; current tail coefficient now in (HL) and (HL + 1)
	RET
	

snake_gotoFreeSpot:
	CALL rnd
	LD B, WIDTH - 2
	CALL u8_div
	LD B, HOFFSET + 1
	ADD A, B
	LD B, A
	PUSH BC
	CALL rnd
	LD B, HEIGHT - 2
	CALL u8_div
	LD B, VOFFSET + 1
	ADD A, B
	POP BC
	LD C, A
	INC C
	CALL gotoXY
	CALL snake_getChar
	CP '.'
	JP NZ, snake_gotoFreeSpot
	CALL gotoXY
	RET

snake_placeDollar:
	CALL snake_gotoFreeSpot
	LD A, '$'
	CALL snake_putChar
	RET

snake_placeWall:
	CALL snake_gotoFreeSpot
	LD A, '#'
	CALL snake_putChar
	RET

snake_drawFrame:
	CALL clrScr
	; upper border
	LD B, (MAX_X - 5) / 2   ; 5 being the length of the 
	LD C, VOFFSET - 1
	CALL gotoXY
	LD IX, SnakeStr
	CALL writeStr
	LD B, 0
	LD C, VOFFSET
	    CALL gotoXY
	LD IX, FRAME1
	CALL snake_writeStr
	LD C, 2
	LD D, HEIGHT - 2
.loop:		      	; vertical bars
	LD B, 0
	CALL gotoXY
	LD IX, FRAME2
	CALL snake_writeStr
	INC C
	DEC D
	JR NZ, .loop
	; lower border
	LD B, 0
	LD C, HEIGHT + VOFFSET - 1	
	CALL gotoXY
	LD IX, FRAME1
	CALL snake_writeStr
	RET
