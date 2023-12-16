; Device driver for the cassette tape interface
; using channel A of the DART

cas_initSeq:
	defb 0, 00011000b	; channel reset
	defb 4, 00001111b	; x1 clock, 2 stop bits, odd parity 
	defb 3, 11000001b	; Rx 8 bits, enable Rx
	defb 5, 01101000b   ; no DTR, Tx 8 bits, enable Tx
	defb 1, 10000000b	; disable interrupts, enable WAIT

cas_init:
    LD HL, cas_initSeq
	LD B, 10
	LD C, DART_A_CMD
	OTIR
	RET

