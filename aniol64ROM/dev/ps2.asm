; 1 start bit, one stop bit, one parity bit

KEY_UP equ 0F0h
EXT_KEY equ 0E0h


ps2_initSeq:
		defb 0, 00011000b	; channel reset
		defb 4, 00000111b	; x1 clock, 1 stop bit, odd parity 
		defb 3, 11000001b	; Rx 8 bits enable Rx
		defb 5, 00000000b	; Tx disabled
		defb 1, 10000000b	; disable interrupts, enable WAIT

ps2_dartInit:
		LD HL, ps2_initSeq
		LD B, 10
		LD C, DART_A_CMD
		OTIR
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
defb "ps2_scancode2asc"
ps2_scancode2asc:
		PUSH BC
		PUSH HL
		LD C, A
		LD B, 0
		LD HL, ps2Scancodes
		ADD HL, BC
		LD A, (HL)
		POP HL
		POP BC
		RET

PROC
ps2_readKey:
		CALL ps2_readScancode
		CP KEY_UP
		JR Z, _keyUp
		CP EXT_KEY
		JR Z, _extKey
		CALL ps2_scancode2asc
		RET
_keyUp:
_extKey:
		CALL ps2_readScancode	; ignore the next scancode, it's the code of the key that's going up
		JR ps2_readKey
		RET
ENDP
		
		
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
		defb '\'	; scancode 5D
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
		
		