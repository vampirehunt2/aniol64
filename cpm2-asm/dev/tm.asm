; TellyMate PAL driver
; http://www.batsocks.co.uk/products/Other/TellyMate_UserGuide_ControlSequences.htm
; 

MAX_X equ 37
MAX_Y equ 24


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
		

; puts a single character on the screen
; and moves the cursor over by one
; A - character to be written
putChar:
	OUT (DART_B_DAT), A
    RET

