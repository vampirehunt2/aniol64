; SNAKE
 
HeadX equ PROGRAM_DATA + 0
HeadY equ PROGRAM_DATA + 1
TailX equ PROGRAM_DATA + 2
TailY equ PROGRAM_DATA + 3
DolX equ PROGRAM_DATA + 4
DolY equ PROGRAM_DATA + 5
DelayCounter equ PROGRAM_DATA + 6
Dir	equ PROGRAM_DATA + 7

DELAY equ 30	; 0.5s
NORTH equ 0
SOUTH equ 1
EAST equ 2
WEST equ 3

org 4000h
defb "snake", 0, 0, 0	; 8 bytes for the command name

org 4008h
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
_set:
		LD (DelayCounter), A	; store the new counter value
		POP AF					; restore register state
		RET
ENDP

snake_init:
		CALL vga_clrScr
		CALL rnd
		
		RET
		
		