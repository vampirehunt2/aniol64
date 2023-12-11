; PS2 keyboard driver
; Physical Interface: 	http://www.burtonsys.com/ps2_chapweske.htm
; Logical protocol: 	http://www-ug.eecg.toronto.edu/msl/nios_devices/datasheets/PS2%20Keyboard%20Protocol.htm

KEY_UP equ 0F0h
EXT_KEY equ 0E0h
LSHIFT equ 12h
RSHIFT equ 59h
TXA	equ 01101000b	; DTR, 8 bits, Tx enabled
PS2_DATA_PORT 	equ	0FFh
PS2_START_BIT 	equ 1		; first bit is the start bit
PS2_PARITY_BIT	equ 10		; tenth bit is the parity bit
PS2_STOP_BIT	equ 11		; eleventh bit is the stop bit

MOVE_N	equ '8'
MOVE_S equ 'k'
MOVE_W equ 'u'
MOVE_E equ 'o'
MOVE_NE equ '9'
MOVE_SE equ 'l'
MOVE_NW equ '7'
MOVE_SW equ 'j'

ps2_initSeq:
		defb 0, 00011000b	; channel reset
		defb 4, 00000111b	; x1 clock, 1 stop bit, odd parity 
		defb 3, 11000001b	; Rx 8 bits enable Rx
		defb 5, TXA
		defb 1, 10000000b	; disable interrupts, enable WAIT
		
handleInt:
	RET

keyInit:
        LD A, 0
        LD (KbdBuff), A			; init the keyboard buffer to avoid a bogus character during the first read
		LD A, TRUE
		LD (Cursor), A
		LD (Echo), A
		; enable interrupts
		LD A, (IntTrapControl)
		LD B, 0
		LD C, ITC
		OR 00000010b			; set bit 1, which it ITE1, unmasking INT1
		OUT (C), A
		LD (IntTrapControl), A
		; consume BAT codes
		CALL ps2_readScancode	
		CALL ps2_readScancode
		CALL ps2_readScancode
		CALL ps2_readScancode
        RET


; shifts in a single bit of a PS2 scancode
ps2_shiftIn:
	EX AF, AF'					; 4 clock cycles
	PUSH BC						; 11
	IN A, (PS2_DATA_PORT)		; 11	reads one bit on D7 from the PS2 data line
	AND 10000000b				; 7 	isolates D7
	LD B, A						; 8		store the bit for later
	LD (ShiftCount), A			; 13
	INC A						; 4
	LD A, (ShiftCount)			; 13	increment the number of bits shifted in
	CP PS2_STOP_BIT				; 7
	JR Z, .stopBit				; 7
	CP PS2_START_BIT			; 7		all the non-data bits are checked for errors, and not shifted it
	JR Z, .startBit				; 7
	CP PS2_PARITY_BIT			; 7
	JR Z, .parityBit			; 7
	LD A, (ShiftReg)			; 13
	OR B						; 4		OR with the previously-stored data bit 
	SRL A						; 8		shift the scancode by one bit
	LD (ShiftReg), A			; 13	store the new value of the shifted byte
	JR .end						; 12
.startBit:
	LD A, B
	CP 0
	JR NZ, .framingErr
	JR Z, .end
.parityBit:
	; TODO: handle parity checking
	JR .end
.stopBit:
	LD A, (ShiftBit)
	CP 0
	JR Z, .framingErr
	; successfully reached the end of the transmission
	LD A, (KbdBuff)
	CP 0
	JR Z, .end					; ignoring the scancode if the buffer is full 
	LD A, (ShiftReg)			; copy the shifted-in scancode to the keyboard buffer
	LD (KbdBuff), A
	LD A, 0
	LD (ShiftReg), A
	LD (ShiftCount), A			; get things ready for the next transmission
	JR .end
.framingErr: 	; TODO: handle framing errors
.parityErr:		; TODO: handle parity errors
.end:
	POP BC						; 11
	EX AF, AF'					; 4
	EI							; 4
	RETI						; 14
		
; synchronously reads a scancode from the PS2 keyboard
; when the scancode is available, it's code is in A
ps2_readScancode:
		LD A, (KbdBuff)
		CP 0
		JR Z, ps2_readScancode		; wait until there's a value in the keyboard buffer
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

readKeyAsync:
		RET

keyInput:
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
		RET
.shiftDn:
		LD A, TRUE
		LD (Ps2Shift), A
		JR keyInput
.shiftUp:
		LD A, FALSE
		LD (Ps2Shift), A
		JR keyInput
.keyUp:
.extKey:
		CALL ps2_readScancode ; ignore the next scancode, it's the code of the key that's going up
		JR Z, .extKey
		CP LSHIFT
		JR Z, .shiftUp
		CP RSHIFT
		JR Z, .shiftUp
		JR keyInput


readKey:
		PUSH BC
		CALL keyInput
		LD B, A
        CP 08            	; check if BACKSPACE was pressed
        JR Z, .bkspc
        CP 20h              ; checks if the key corresponds to a control character
        JR C, .noEcho   	; skip echo if less	
		LD A, (Echo)
		CP FALSE
		JR Z, .noEcho
		LD A, B
        CALL putChar	; echo the character to screen, but don't remove it from the keyboard buffer
		CALL bzr_click
.noEcho:
		LD A, B
		POP BC
        RET
.bkspc:
        CALL cursorLShift  ; TODO: check if you're already in the beginning of line
        LD A, ' '
        CALL putChar
        CALL cursorLShift
        JR .noEcho


; reads a line from keyboard
; result in LineBuff
; result is only valid until next call of readLine
; if the result needs to persist, it needs to be copied to elswhere in memory
; TODO: check for max line length (buffer overflow)

readLine:
		PUSH BC
        LD BC, LineBuff       ; point BC to the beginning of the keyboard buffer
.loop:
        CALL readKey     	 ; wait for a key to be pressed
        CP 13                ; check if RETURN key was pressed
        JR Z, .return
        CP 08                 ; check if BACKSPACE was pressed
        JR Z, .bkspc
        CP 20h                ; checks if the key corresponds to a control character
        JR C, .loop           ; skip if less
        LD (BC), A            ; store the character in the keyboard buffer
        INC C                 ; point BC to the new position of keyboard buffer
        JR .loop
.bkspc:
        LD A, C                ; check if line buffer not empty
        CP 0
        JR Z, .loop             ; TODO: beep if buffer is empty
        DEC C                   ; go back one character
        JR .loop
.return:
        LD A, 0                ; store end of line
        LD (BC), A
		POP BC
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

