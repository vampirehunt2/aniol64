; PS2 keyboard driver
; Physical Interface: 	http://www.burtonsys.com/ps2_chapweske.htm
; Logical protocol: 	http://www-ug.eecg.toronto.edu/msl/nios_devices/datasheets/PS2%20Keyboard%20Protocol.htm

DART_A_CMD equ 11101110b
DART_B_CMD equ 11101111b 
DART_A_DAT equ 11101100b
DART_B_DAT equ 11101101b

KEY_UP equ 0F0h
EXT_KEY equ 0E0h
LSHIFT equ 12h
RSHIFT equ 59h

TXA equ 01101000b	; DTR, 8 bits, Tx enabled

FALSE equ 00h
TRUE equ 0FFh

Ps2Shift: db 0


; waits for 37us * 2.5MHz = 92 clock cycles
; which is just 16 NOPs, 4 cycles each
; plus 10 cycles for the RET
; plus 17 cycles to CALL this routine
delay37us:
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	NOP
	RET


; waits for 1520us,
; which is 41 calls to delay37us
delay1520us:
	PUSH BC
	LD B, 41
.loop:		
	CALL delay37us
	DJNZ .loop
	POP BC
	RET

; A - delay x10ms
delay:
	CP 0
	RET Z
	DEC A
	CALL delay10ms
	JP delay

delay10ms:
	CALL delay1520us
	CALL delay1520us
	CALL delay1520us
	CALL delay1520us
	CALL delay1520us
	CALL delay1520us
	CALL delay1520us
	CALL delay1520us
	RET


ps2_initSeq:
		defb 0, 00011000b	; channel reset
		defb 4, 00000111b	; x1 clock, 1 stop bit, odd parity 
		defb 3, 11000001b	; Rx 8 bits enable Rx
		defb 5, TXA
		defb 1, 10000000b	; disable interrupts, enable WAIT

keyInit:
		LD HL, ps2_initSeq
		LD B, 10
		LD C, DART_A_CMD
		OTIR
		CALL ps2_readScancode
		LD A, 0FFh				; reset command
		CALL ps2_transmit		
		CALL ps2_wait4Tx		; wait for transmission to complete
		CALL ps2_readScancode	; consume BAT codes
		CALL ps2_readScancode
		CALL ps2_readScancode
		CALL ps2_readScancode
		LD A, FALSE
		LD (Ps2Shift), A
        RET

keyPressed:
		IN A, (DART_A_CMD)
		AND 00000001b
		RET
		
; synchronously reads a scancode from the serial port
; when the scancode is available, it's code is in A
ps2_readScancode:
		IN A, (DART_A_CMD)
		BIT 0, A
		JR Z, ps2_readScancode
		IN A, (DART_A_DAT)
		RET
		
; converts a scancode to the corresponding ascii character


ps2_scancode2asc:
		PUSH BC
		PUSH HL
		LD C, A
		LD B, 0
		LD A, (Ps2Shift)
		CP TRUE
		JR Z, .shift
		LD HL, ps2Scancodes
		JR .continue
.shift:
		LD HL, ps2ShiftScancodes
.continue:
		ADD HL, BC
		LD A, (HL)
		POP HL
		POP BC
		RET

readKey:
		CALL ps2_readScancode
		CP KEY_UP
		JR Z, .keyUp
		CP EXT_KEY
		JR Z, .extKey
		CP LSHIFT
		JR Z, .shiftDn
		CP RSHIFT
		JR Z, .shiftDn
		CALL ps2_scancode2asc
		CP 'a'					; if it's a letter, make sure it's uppercase
		RET C
		CP 'z' + 1
		RET NC
		ADD a, 'A' - 'a'
		RET
.shiftDn:
		LD A, TRUE
		LD (Ps2Shift), A
		JR readKey
.shiftUp:
		LD A, FALSE
		LD (Ps2Shift), A
		JR readKey
.keyUp:
.extKey:
		CALL ps2_readScancode ; ignore the next scancode, it's the code of the key that's going up
		JR Z, .extKey
		CP LSHIFT
		JR Z, .shiftUp
		CP RSHIFT
		JR Z, .shiftUp
		JR readKey
		
;1)   Bring the Clock line low for at least 100 microseconds.
;2)   Bring the Data line low.
;3)   Release the Clock line.
;4)   Wait for the device to bring the Clock line low.
;5)   Set/reset the Data line to send the first data bit
;6)   Wait for the device to bring Clock high.
;7)   Wait for the device to bring Clock low.
;8)   Repeat steps 5-7 for the other seven data bits and the parity bit
;9)   Release the Data line.
;10) Wait for the device to bring Data low.
;11) Wait for the device to bring Clock  low.
;12) Wait for the device to release Data and Clock
ps2_transmit:
		CALL ps2_wait4Tx
		CALL ps2_clockInhibit
		CALL delay1520us
		CALL ps2_dataInhibit
		CALL ps2_clockRelease
		OUT (DART_A_DAT), A
		CALL ps2_dataRelease
		RET
		

ps2_wait4Tx:
		PUSH AF
.loop:
		IN A, (DART_A_CMD)
		AND 00000100b
		CP 0
		JR Z, .loop
		POP AF
		RET


ps2_clockInhibit:
		PUSH AF
		LD A, 5				; writing to WR5
		OUT (DART_A_CMD), A
		LD A, TXA		; get previous value of WR5
		OR 10000000b		; set  DTR (D7)	
		OUT (DART_A_CMD), A
		POP AF
		RET
	
ps2_clockRelease:
		PUSH AF				
		LD A, 5				; writing to WR5
		OUT (DART_A_CMD), A
		LD A, TXA
		AND 01111111b		; clear  DTR (D7)
		OUT (DART_A_CMD), A	
		POP AF
		RET
	
ps2_dataInhibit:
		PUSH AF
		LD A, 5				; writing to WR5
		OUT (DART_A_CMD), A
		LD A, TXA
		OR 00010000b		; send break (D4)
		OUT (DART_A_CMD), A
		POP AF
		RET
	
ps2_dataRelease:
		PUSH AF				
		LD A, 5				; writing to WR5
		OUT (DART_A_CMD), A
		LD A, TXA
		AND 11101111b		; clear break (D4)
		OUT (DART_A_CMD), A	
		POP AF
		RET	



ps2Scancodes:
		defb 00		; scancode 00
		defb 00		; scancode 01
		defb 00		; scancode 02
		defb 00		; scancode 03	
		defb 00		; scancode 04
		defb 00		; scancode 05
		defb 00		; scancode 06
		defb 00		; scancode 07		
		defb 00		; scancode 08
		defb 00		; scancode 09
		defb 00		; scancode 0A
		defb 00		; scancode 0B	
		defb 00		; scancode 0C
		defb 09h	; scancode 0D TAB character
		defb '`'	; scancode 0E
		defb 00		; scancode 0F		
		defb 00		; scancode 10
		defb 00		; scancode 11
		defb 00		; scancode 12
		defb 00		; scancode 13	
		defb 00		; scancode 14
		defb 'q'	; scancode 15
		defb '1'	; scancode 16
		defb 00		; scancode 17		
		defb 00		; scancode 18
		defb 00		; scancode 19
		defb 'z'	; scancode 1A
		defb 's'	; scancode 1B	
		defb 'a'	; scancode 1C
		defb 'w'	; scancode 1D
		defb '2'	; scancode 1E
		defb 00		; scancode 1F		
		defb 00		; scancode 20
		defb 'c'	; scancode 21
		defb 'x'	; scancode 22
		defb 'd'	; scancode 23	
		defb 'e'	; scancode 24
		defb '4'	; scancode 25
		defb '3' 	; scancode 26
		defb 00		; scancode 27		
		defb 00		; scancode 28
		defb ' '	; scancode 29
		defb 'v'	; scancode 2A
		defb 'f'	; scancode 2B	
		defb 't'	; scancode 2C
		defb 'r'	; scancode 2D
		defb '5'	; scancode 2E
		defb 00		; scancode 2F		
		defb 00		; scancode 30
		defb 'n'	; scancode 31
		defb 'b'	; scancode 32
		defb 'h'	; scancode 33	
		defb 'g'	; scancode 34
		defb 'y'	; scancode 35
		defb '6'	; scancode 36
		defb 00		; scancode 37		
		defb 00		; scancode 38
		defb 00		; scancode 39
		defb 'm'	; scancode 3A
		defb 'j'	; scancode 3B	
		defb 'u'	; scancode 3C
		defb '7'	; scancode 3D
		defb '8'	; scancode 3E
		defb 00		; scancode 3F		
		defb 00		; scancode 40
		defb ','	; scancode 41
		defb 'k'	; scancode 42
		defb 'i'	; scancode 43	
		defb 'o'	; scancode 44
		defb '0'	; scancode 45
		defb '9'	; scancode 46
		defb 00		; scancode 47		
		defb 00		; scancode 48
		defb '.'	; scancode 49
		defb '/'	; scancode 4A
		defb 'l'	; scancode 4B	
		defb ';'	; scancode 4C
		defb 'p'	; scancode 4D
		defb '-'	; scancode 4E
		defb 00		; scancode 4F		
		defb 00		; scancode 50
		defb 00		; scancode 51
		defb 27h	; scancode 52	apostrophe
		defb 00		; scancode 53	
		defb '['	; scancode 54
		defb '='	; scancode 55
		defb 00		; scancode 56
		defb 00		; scancode 57		
		defb 00		; scancode 58
		defb 00		; scancode 59
		defb 13		; scancode 5A
		defb ']'	; scancode 5B	
		defb 00		; scancode 5C
		defb '\\'	; scancode 5D
		defb 00		; scancode 5E
		defb 00		; scancode 5F		
		defb 00		; scancode 60
		defb 00		; scancode 61
		defb 00		; scancode 62
		defb 00		; scancode 63	
		defb 00		; scancode 64
		defb 00		; scancode 65
		defb 08h	; scancode 66	BACKSPACE
		defb 00		; scancode 67		
		defb 00		; scancode 68
		defb '1'	; scancode 69
		defb 00		; scancode 6A
		defb '4'	; scancode 6B	
		defb '7' 	; scancode 6C
		defb 00		; scancode 6D
		defb 00		; scancode 6E
		defb 00		; scancode 6F		
		defb '0'	; scancode 70
		defb '.'	; scancode 71
		defb '2'	; scancode 72
		defb '5'	; scancode 73	
		defb '6'	; scancode 74
		defb '8'	; scancode 75
		defb 00		; scancode 76
		defb 00		; scancode 77		
		defb 00		; scancode 78
		defb '+'	; scancode 79
		defb '3'	; scancode 7A
		defb '-'	; scancode 7B	
		defb '*'	; scancode 7C
		defb '9'	; scancode 7D
		defb 00		; scancode 7E
		defb 00		; scancode 7F		

ps2ShiftScancodes:
		defb 00		; scancode 00
		defb 00		; scancode 01 	F9
		defb 00		; scancode 02
		defb 00		; scancode 03	
		defb 00		; scancode 04
		defb 00		; scancode 05
		defb 00		; scancode 06
		defb 00		; scancode 07		
		defb 00		; scancode 08
		defb 00		; scancode 09
		defb 00		; scancode 0A
		defb 00		; scancode 0B	
		defb 00		; scancode 0C
		defb 00		; scancode 0D
		defb '~'	; scancode 0E
		defb 00		; scancode 0F		
		defb 00		; scancode 10
		defb 00		; scancode 11
		defb 00		; scancode 12
		defb 00		; scancode 13	
		defb 00		; scancode 14
		defb 'Q'	; scancode 15
		defb '!'	; scancode 16
		defb 00		; scancode 17		
		defb 00		; scancode 18
		defb 00		; scancode 19
		defb 'Z'	; scancode 1A
		defb 'S'	; scancode 1B	
		defb 'A'	; scancode 1C
		defb 'W'	; scancode 1D
		defb '@'	; scancode 1E
		defb 00		; scancode 1F		
		defb 00		; scancode 20
		defb 'C'	; scancode 21
		defb 'X'	; scancode 22
		defb 'D'	; scancode 23	
		defb 'E'	; scancode 24
		defb '$'	; scancode 25
		defb '#' 	; scancode 26
		defb 00		; scancode 27		
		defb 00		; scancode 28
		defb 00		; scancode 29
		defb 'V'	; scancode 2A
		defb 'F'	; scancode 2B	
		defb 'T'	; scancode 2C
		defb 'R'	; scancode 2D
		defb '%'	; scancode 2E
		defb 00		; scancode 2F		
		defb 00		; scancode 30
		defb 'N'	; scancode 31
		defb 'B'	; scancode 32
		defb 'H'	; scancode 33	
		defb 'G'	; scancode 34
		defb 'Y'	; scancode 35
		defb '^'	; scancode 36
		defb 00		; scancode 37		
		defb 00		; scancode 38
		defb 00		; scancode 39
		defb 'M'	; scancode 3A
		defb 'J'	; scancode 3B	
		defb 'U'	; scancode 3C
		defb '&'	; scancode 3D
		defb '*'	; scancode 3E
		defb 00		; scancode 3F		
		defb 00		; scancode 40
		defb '<'	; scancode 41
		defb 'K'	; scancode 42
		defb 'I'	; scancode 43	
		defb 'O'	; scancode 44
		defb ')'	; scancode 45
		defb '('	; scancode 46
		defb 00		; scancode 47		
		defb 00		; scancode 48
		defb '>'	; scancode 49
		defb '?'	; scancode 4A
		defb 'L'	; scancode 4B	
		defb ':'	; scancode 4C
		defb 'P'	; scancode 4D
		defb '_'	; scancode 4E
		defb 00		; scancode 4F		
		defb 00		; scancode 50
		defb 00		; scancode 51
		defb '"'	; scancode 52
		defb 00		; scancode 53	
		defb '{'	; scancode 54
		defb '+'	; scancode 55
		defb 00		; scancode 56
		defb 00		; scancode 57		
		defb 00		; scancode 58
		defb 00		; scancode 59
		defb 13		; scancode 5A
		defb '}'	; scancode 5B	
		defb 00		; scancode 5C
		defb '|'	; scancode 5D
		defb 00		; scancode 5E
		defb 00		; scancode 5F		
		defb 00		; scancode 60
		defb 00		; scancode 61
		defb 00		; scancode 62
		defb 00		; scancode 63	
		defb 00		; scancode 64
		defb 00		; scancode 65
		defb 00		; scancode 66
		defb 00		; scancode 67		
		defb 00		; scancode 68
		defb '1'	; scancode 69
		defb 00		; scancode 6A
		defb '4'	; scancode 6B	
		defb '7' 	; scancode 6C
		defb 00		; scancode 6D
		defb 00		; scancode 6E
		defb 00		; scancode 6F		
		defb '0'	; scancode 70
		defb '.'	; scancode 71
		defb '2'	; scancode 72
		defb '5'	; scancode 73	
		defb '6'	; scancode 74
		defb '8'	; scancode 75
		defb 00		; scancode 76
		defb 00		; scancode 77		
		defb 00		; scancode 78
		defb '+'	; scancode 79
		defb '3'	; scancode 7A
		defb '-'	; scancode 7B	
		defb '*'	; scancode 7C
		defb '9'	; scancode 7D
		defb 00		; scancode 7E
		defb 00		; scancode 7F		

