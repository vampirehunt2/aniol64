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

WIDTH equ 40
HEIGHT equ 30

FRAME1 defb "#######################################", 0
FRAME2 defb "#                                     #", 0

GameOver: defb "GAME OVER!!!", 0

PROC
snake_main:
		CALL snake_init
_loop:
		CALL kbd_readKey
		CP 'k'
		JP Z, _n
		CP 'n'
		JP Z, _s
		CP 'b'
		JP Z, _w
		CP 'm'
		JP Z, _e
		CP 'q'
		JP Z, _end
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
		CALL vga_clrScr
		CALL snake_drawFrame
		LD A, 0
		LD (Echo), A			; turn echo off
		LD (Cursor), A			; turn cursor off
		LD (Head), A			; set the first item in the Coeffs table to be the current one
		LD (Tail), A			; set tail to be at the same place as the head (length of the snake is zero)
		LD (Points), A			; zero the points
		INC A
		LD (Level), A			; set level to 1
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
defb "snake_move"
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
		; TODO print points
		CALL snake_placeDollar
_end:
		POP AF
		RET	
ENDP	

snake_gameOver:
		CALL vga_clrScr
		LD B, 14
		LD C, 10
		CALL vga_gotoXY
		LD IX, GameOver
		CALL vga_wriStr
		RET

; returns previous char at new head location in D
snake_moveHead:
		CALL snake_getHeadCoeffs
		LD B, (HL)
		INC HL
		LD C, (HL)
		CALL vga_gotoXY
		CALL vga_getChar
		LD D, A
		CALL vga_gotoXY
		LD A, '*'
		CALL vga_putChar
		RET 
		
snake_moveTail:
		CALL snake_getTailCoeffs
		LD B, (HL)
		INC HL
		LD C, (HL)
		CALL vga_gotoXY
		LD A, ' '
		CALL vga_putChar
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
		LD B, WIDTH
		CALL u8_div
		LD B, A
		PUSH BC
		CALL rnd
		LD B, HEIGHT
		CALL u8_div
		POP BC
		LD C, A
		CALL vga_gotoXY
		CALL vga_getChar
		CP ' '
		JP NZ, snake_placeDollar ; only place the dollar in a free spot
		CALL vga_gotoXY
		LD A, '$'
		CALL vga_putChar
		RET
ENDP

PROC
defb "snake_drawFrame"
snake_drawFrame:
		; vertical bars
		LD D, HEIGHT - 5
		LD B, 0
		LD C, 1
	    CALL vga_gotoXY
_loop:
		LD B, 0
		INC C
		CALL vga_gotoXY
		LD IX, FRAME2
		CALL vga_wriStr
		DEC D
		JR NZ, _loop
		; horizontal bars
		LD B, 0
		LD C, 1
		CALL vga_gotoXY
		LD IX, FRAME1
		CALL vga_wriStr
		LD B, 0
		LD C, HEIGHT - 4
		CALL vga_gotoXY
		LD IX, FRAME1
		CALL vga_wriStr
		RET
ENDP


	
		

		
