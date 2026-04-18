; Serial input driver
; Mostly for serial keyboard

MOVE_N	equ 'i'
MOVE_S equ 'n'
MOVE_W equ 'j'
MOVE_E equ 'l'
MOVE_NE equ 'o'
MOVE_SE equ 'm'
MOVE_NW equ 'u'
MOVE_SW equ 'b'

keyInit:
    ; initialise the ASCI that communicates with a serial device, like a keyboard
	LD B, 0				; making sure bits A15-A8 of the I/O port number are 0 for the subsequent I/O operations
	LD C, CNTLA1
	LD A, 01011100b		; MPE off, RE on, TE off, clock disable, EFR off, mode: 8 data bits, no parity, 1 stop bit
	OUT (C), A
	LD C, CNTLB1
	LD A, 00101100b		; MPBT off, MP off, prescale 30, parity whatever, divide ratio 64, speed select x16 (260 baud for 8MHz clock)
	OUT (C), A
	LD C, STAT1
	LD A, 00h			; disable interrupts
	OUT (C), A
    RET

; reads a single key from the buffer
keyInput:
    PUSH BC
    LD B, 0         ; making sure bits A15-A8 of the I/O port number are 0 for the subsequent I/O operations
    LD C, STAT1     
.loop:
    IN A, (C)       ; read the ASCI1 status word
    BIT 7, A        ; check the Receive Data Register Full bit
    JR Z, .loop     ; if zero, means a byte has not been received, waiting
    LD C, RDR1    
    IN A, (C)       ; read in the received byte into A
	POP BC
    RET

; checks if a key has been pressed and a character is available
; returns the NZ flag if key was pressed, Z flag if no key was pressed
keyPressed:
    PUSH BC
    LD B, 0         ; making sure bits A15-A8 of the I/O port number are 0 for the subsequent I/O operations
    LD C, STAT1     
    IN A, (C)       ; read the ASCI1 status word
    BIT 7, A        ; check the Receive Data Register Full bit
    POP BC
    RET

readKey:
	PUSH BC
	CALL keyInput
	LD B, A
    CP 08            	; check if BACKSPACE was pressed
    JR Z, .bkspc		
	CP 09				; check if TAB was pressed
	JR Z, .tab
    CP 20h              ; checks if the key corresponds to a control character
    JR C, .noEcho   	; skip echo if less	
	LD A, (Echo)
	CP FALSE
	JR Z, .noEcho
	LD A, B
    CALL putChar		; echo the character to screen, but don't remove it from the keyboard buffer
	CALL bzr_click
.noEcho:
	LD A, B
	POP BC
    RET
.bkspc:
    CALL cursorLShift  	; TODO: check if you're already in the beginning of line
    LD A, ' '
    CALL putChar
    CALL cursorLShift
    JR .noEcho
.tab:
	LD A, ' '
    CALL putChar
	LD A, ' '
    CALL putChar
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