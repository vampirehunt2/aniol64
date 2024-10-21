DART_A_CMD equ 11101110b
DART_B_CMD equ 11101111b 
DART_A_DAT equ 11101100b
DART_B_DAT equ 11101101b

	; init DART
	LD HL, init_seq
	LD B, 10
	LD C, DART_B_CMD
	OTIR

	; write out a message
	LD IX, msg
loop:
	LD A, (IX)
	CP 0
	JP Z, endLoop
	OUT (DART_B_DAT), A
	INC IX
	JP loop
endLoop:
	HALT

init_seq:
		defb 0, 00011000b	; channel reset
		defb 4, 11000100b	; x64 clock, no parity, 1 stop bit
		defb 3, 11000000b	; disable Rx
		defb 5, 01101000b	; Tx 8 bits, Tx enabled
		defb 1, 10000000b	; disable interrupts, enable wait
		
msg: defb "Hello", 0