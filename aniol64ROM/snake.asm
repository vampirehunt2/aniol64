; SNAKE

Head equ PROGRAM_DATA + 0
Tail equ PROGRAM_DATA + 1
DolX equ PROGRAM_DATA + 2
DolY equ PROGRAM_DATA + 3
DelayCounter equ PROGRAM_DATA + 4
Dir	equ PROGRAM_DATA + 5
Coeffs equ PROGRAM_DATA + 6

DELAY equ 30	; 0.5s
NORTH equ 0
SOUTH equ 1
EAST equ 2
WEST equ 3

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
_e:		LD A, (EAST)
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
		LD A, 0
		LD (Echo), A			; turn echo off
		LD (Cursor), A			; turn cursor off
		LD (Head), A			; set the first item in the Coeffs table to be the current one
		LD (Tail), A
		LD IX, Coeffs
		CALL rnd
		AND 32				; randomly select the X position
		ADD A, 4
		LD (IX), A
		CALL rnd
		AND 16				; randomly select the Y position
		ADD A, 7
		LD (IX + 1), A
		CALL rnd
		AND 00000011b			; randomly select the direction
		LD (Dir), A
		LD HL, snake_NmiHandler
		CALL registerNmiHandler
		RET 
		
PROC
snake_move:
		LD HL, Coeffs			
		LD B, 0
		LD A, (Head)
		
		LD C, A
		ADD HL, BC				; current hed coefficient now in HL and HL + 1
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
		INC HL
		LD A, (HL)
		DEC A
		LD (HL), A
		JP _end
_s:
		INC HL
		LD A, (HL)
		INC A
		LD (HL), A
		JP _end
_e:
		LD A, (HL)
		INC A
		LD (HL), A
		JP _end
_w:
		LD A, (HL)
		DEC A
		LD (HL), A
		JP _end
_end: 
		LD A, (Head)
		INC A
		INC A
		LD (Head), A 
		CALL snake_moveHead
		CALL snake_moveTail
		LD A, (Tail)
		INC A
		INC A
		LD (Tail), A
		RET	
ENDP		

snake_moveHead:
		LD HL, Coeffs
		LD B, 0
		LD A, (Head)
		LD C, A
		ADD HL, BC				; current hed coefficient now in HL and HL + 1
		LD A, (HL)
		LD B, A
		INC HL
		LD A, (HL)
		LD C, A
		CALL vga_gotoXY
		LD A, '*'
		CALL vga_putChar
		RET 
		
snake_moveTail:
		LD HL, Coeffs
		LD B, 0
		LD A, (Tail)
		LD C, A
		ADD HL, BC				; current hed coefficient now in HL and HL + 1
		LD A, (HL)
		LD B, A
		INC HL
		LD A, (HL)
		LD C, A
		CALL vga_gotoXY
		LD A, ' '
		CALL vga_putChar
		RET 
		
