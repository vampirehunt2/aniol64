;----------------------------------------------------
; Project: aniol64.zdsp
; File: dart.asm
; Date: 8/27/2021 13:05:50
;
; Created with zDevStudio - Z80 Development Studio.
;
;----------------------------------------------------
 
 
DART_A_CMD equ 11101110b
DART_B_CMD equ 11101111b 
DART_A_DAT equ 11101100b
DART_B_DAT equ 11101101b
 
X_ON equ 13h 
X_OFF equ 11h

init_seq:
		defb 0, 00011000b	; channel reset
		defb 4, 11000100b	; x64 clock, no parity, 1 stop bit
		defb 3, 11000001b	; Rx 8 bits enable Rx
		defb 5, 01101000b	; Tx 8 bits, Tx enabled
		defb 1, 10000000b	; disable interrupts, enable WAIT

dart_init:
		LD HL, init_seq
		LD B, 10
		LD C, DART_B_CMD
		OTIR
        RET

; writes a character out through the serial port	
; A - character to write out
dart_putChar:
		OUT (DART_B_DAT), A
		; waiting for the character to be sent is done automatically
		; since WAIT function is enabled.
		RET
	 
PROC 
; synchronously reads a character from the serial port
; when a character is available, it's ASCII code is in A
dart_getChar:
		IN A, (DART_B_CMD)
		BIT 0, A
		JR Z, dart_getChar
		IN A, (DART_B_DAT)
		RET
ENDP
		
dart_xoff:
		PUSH AF
		LD A, X_OFF
		OUT (DART_B_DAT), A
		POP AF
		RET
		
dart_xon:
		PUSH AF
		LD A, X_ON
		OUT (DART_B_DAT), A
		POP AF
		RET
	
; waits until the Tx buffer is empty	
dart_TxWait:
		LD A, 1				; select RR1
		OUT (DART_B_CMD), A
		IN A,(DART_B_CMD) 	; read RR1
		BIT 0, A			; check if ALL SENT bit is set
		JR Z, dart_TxWait	; wait if not
		RET
		
