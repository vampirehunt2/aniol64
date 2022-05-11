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

; Connection parameters are
; 	- 2 stop bits
;	- even parity
; 	- 8bits per character
;	- x64 data clock, i.e. 38400kbaud for a 2.5MHz system clock
dart_init:
		LD A, 00110000b ;write into WR0: error reset, select WR0
		OUT(DART_B_CMD), A
		LD A, 00011000b ;write into WR0: channel reset
		OUT (DART_B_CMD), A
		LD A, 1 		; select WR1
		OUT(DART_B_CMD), A
		LD A, 10011000b ; WAIT enabled, INT on all characters
		OUT (DART_B_CMD), A
		LD A, 2 		; select WR2 
		OUT (DART_B_CMD), A 
		;LD A, 02h		  interrupt vector 2 
		OUT (DART_B_CMD), A 
		LD A, 3			; select WR3
		OUT (DART_B_CMD), A
		LD A, 11000001b	; 8 bits per character, Rx enabled
		OUT (DART_B_CMD), A
		LD A, 4
		OUT (DART_B_CMD), A
		LD A, 11001101b	; x64 clock, 2 stop bit, even parity
		OUT (DART_B_CMD), A
		LD A, 5			; select WR5
		OUT (DART_B_CMD), A
		LD A, 01101000b	; DTS disabled, 8 bits per character, Tx enabled
        RET
		
dart_putChar:
		OUT (DART_B_DAT), A
		CALL dart_TxWait
		RET
		
dart_getChar:
		IN A, (DART_B_DAT)
		RET
		
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
		IN A,(DART_B_CMD) 	;read RRx
		BIT 0, A			; check if ALL SENT bit is set
		JR Z, dart_TxWait	; wait if not
		RET
		
