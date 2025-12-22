; TellyMate PAL driver
; http://www.batsocks.co.uk/products/Other/TellyMate_UserGuide_ControlSequences.htm
; 

MAX_X equ 37
MAX_Y equ 24
ESC   equ 1Bh
LF    equ 10
CR	  equ 13

DART_B_CMD equ 11101111b
DART_B_DAT equ 11101101b

tm_initSeq:
	defb 0, 00011000b	; channel reset
	defb 4, 11000100b	; x64 clock, no parity, 1 stop bit
	defb 3, 11000001b	; Rx 8 bits enable Rx
	defb 5, 01101000b	; DTR, Tx 8 bits, Tx enabled
	defb 1, 10000000b	; disable interrupts, enable WAIT

dspInit:
	LD HL, tm_initSeq
	LD B, 10
	LD C, DART_B_CMD
	OTIR
    RET

; clears the screen 
clrScr:
	LD A, ESC
	OUT (DART_B_DAT), A
	LD A, 'E'
	OUT (DART_B_DAT), A
    RET

; moves the cursor to position (0,0)
home:
	LD A, ESC
	OUT (DART_B_DAT), A
	LD A, 'H'
	OUT (DART_B_DAT), A
    RET
 
putChar:
	OUT (DART_B_DAT), A
	; waiting for the character to be sent is done automatically
	; since WAIT function is enabled.
    RET

	