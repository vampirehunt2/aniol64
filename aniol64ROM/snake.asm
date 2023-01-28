; SNAKE

Head equ PROGRAM_DATA + 0
Tail equ PROGRAM_DATA + 1
Points equ PROGRAM_DATA + 2
Level equ PROGRAM_DATA + 3
DelayCounter equ PROGRAM_DATA + 4
Dir	equ PROGRAM_DATA + 5
Coeffs equ PROGRAM_DATA + 6

DELAY equ 10	; 0.5s
NORTH equ 0
SOUTH equ 1
EAST equ 2
WEST equ 3

WIDTH equ MAX_X + 1
HEIGHT equ MAX_Y

FRAME1: ds WIDTH, '#' 
defb 0

FRAME2: defb "#"
ds WIDTH - 2, ' '
defb "#", 0

GameOver: defb "GAME OVER!!!", 0

PROC
snake_main:
		CALL snake_init
_loop:
		CALL readKey
		CP 'k'
		JP Z, _n
		CP 'n'
		JP Z, _s
		CP 'b'
		JP Z, _w
		CP 'm'
		JP Z, _e
		CP '8'
		JP Z, _n
		CP '2'
		JP Z, _s
		CP '4'
		JP Z, _w
		CP '6'
		JP Z, _e
		CP 'q'
		JP Z, _end
		JP _loop
_n:		LD A, NORTH
		LD (Dir), A
		JP _loop
_s:		LD A, SOUTH
		LD (Dir), A
		JP _loop
_e:		LD A, EAST
		LD (Dir), A
		JP _loop
_w:		LD A, WEST
		LD (Dir), A
		JP _loop
_end:
		RET
ENDP

PROC
snake_NmiHandler:
		PUSH AF					; save register state
		LD A, (DelayCounter)	; load the current value of delay counter
		CP DELAY				; check if we've reached the delay value
		JP Z, _reset			; if yes, reset te counter
		INC A					; otherwise increment it
		JP _set
_reset:
		LD A, 0
		CALL snake_move
_set:
		LD (DelayCounter), A	; store the new counter value
		POP AF					; restore register state
		RET
ENDP

snake_init:
		CALL clrScr
		CALL snake_drawFrame
		LD A, 0
		LD (Echo), A			; turn echo off
		LD (Cursor), A			; turn cursor off
		LD (Head), A			; set the first item in the Coeffs table to be the current one
		LD (Tail), A			; set tail to be at the same place as the head (length of the snake is zero)
		LD (Points), A			; zero the points
		INC A
		LD (Level), A			; set level to 1
		CALL cursorOff
		LD IX, Coeffs
		LD A, 20
		LD (IX), A
		LD A, 15
		LD (IX + 1), A
		CALL rnd
		AND 00000011b			; randomly select the direction
		LD (Dir), A
		CALL snake_placeDollar  
		LD HL, snake_NmiHandler
		CALL registerNmiHandler	; starts snake movement
		RET 
		
		
PROC
snake_move:		
		PUSH AF
		CALL snake_getHeadCoeffs
		LD D, (HL)				; current head X in D				
		INC HL
		LD E, (HL)				; current head Y in E					
		LD A, (Dir)
		CP NORTH
		JP Z, _n
		CP SOUTH
		JP Z, _s
		CP EAST
		JP Z, _e
		CP WEST
		JP Z, _w
_n:
		DEC E
		JP _cont
_s:
		INC E
		JP _cont
_e:
		INC D
		JP _cont
_w:
		DEC D
		JP _cont
_cont: 
		LD A, (Head)
		INC A
		INC A
		LD (Head), A 		; store new head index
		CALL snake_getHeadCoeffs
		LD (HL), D			; store new head X
		INC HL
		LD (HL), E			; store new head Y
		CALL snake_moveHead
		LD A, D
		CP '$'
		JR Z, _dollar		; if point is scored skip moving the tail, let the snake grow
		CP '#'
		JP Z, snake_gameOver
		CP '*'
		JP Z, snake_gameOver
		CALL snake_moveTail
		LD A, (Tail)
		INC A
		INC A
		LD (Tail), A	 ; move tail by one (two indices into the Coeffs table)
		JR _end
_dollar:
		LD A, (Points)
		INC A
		LD (Points), A
		CALL bzr_click
		CALL snake_printPoints
		CALL snake_placeDollar
_end:
		POP AF
		RET	
ENDP	

snake_printPoints:
	PUSH BC
	LD B, 0
	LD C, MAX_Y
	CALL gotoXY
	LD A, '$'
	CALL putChar
	LD A, ':'
	CALL putChar
	LD A, (Points)
	CALL bin2Bcd
	PUSH AF
	LD A, C
	CALL putChar
	LD A, B
	CALL putChar
	POP AF
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
		CALL getChar
		LD D, A
		CALL gotoXY
		LD A, '*'
		CALL putChar
		RET 
		
snake_moveTail:
		CALL snake_getTailCoeffs
		LD B, (HL)
		INC HL
		LD C, (HL)
		CALL gotoXY
		LD A, ' '
		CALL putChar
		RET 
		
; returns head coefficient in (HL) and (HL + 1)		
snake_getHeadCoeffs:
		LD HL, Coeffs
		LD B, 0
		LD A, (Head)
		LD C, A
		ADD HL, BC				; current head coefficient now in (HL) and (HL + 1)
		RET
		
; returns tail coefficient in (HL) and (HL + 1)
snake_getTailCoeffs:
		LD HL, Coeffs
		LD B, 0
		LD A, (Tail)
		LD C, A
		ADD HL, BC				; current tail coefficient now in (HL) and (HL + 1)
		RET
		
PROC
snake_placeDollar:
		CALL rnd
		LD B, WIDTH - 2
		CALL u8_div
		LD B, A
		INC B
		PUSH BC
		CALL rnd
		LD B, HEIGHT - 2
		CALL u8_div
		POP BC
		LD C, A
		INC C
		CALL gotoXY
		CALL getChar
		CP ' '
		JP NZ, snake_placeDollar ; only place the dollar in a free spot
		CALL gotoXY
		LD A, '$'
		CALL putChar
		RET
ENDP

PROC
snake_drawFrame:
		; vertical bars
		LD D, HEIGHT - 1
		LD B, 0
		LD C, 0
	    CALL gotoXY
_loop:
		LD B, 0
		CALL gotoXY
		LD IX, FRAME2
		CALL writeStr
		INC C
		DEC D
		JR NZ, _loop
		; horizontal bars
		LD B, 0
		LD C, 0
		CALL gotoXY
		LD IX, FRAME1
		CALL writeStr
		LD B, 0
		LD C, MAX_Y - 1
		CALL gotoXY
		LD IX, FRAME1
		CALL writeStr
		RET
ENDP


	
		

		
