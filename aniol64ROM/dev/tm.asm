; TellyMate PAL driver
; http://www.batsocks.co.uk/products/Other/TellyMate_UserGuide_ControlSequences.htm
; 

MAX_X equ 37
MAX_Y equ 24
ESC   equ 1Bh
LF    equ 10
CR	  equ 13


Blank: defb "                                    ", 0

dspInit:
	; initialise the ASCI that communicates with TellyMate	
	LD B, 0	
	LD C, CNTLA0
	LD A, 00111100b		; MPE off, RE off, TE on, RTS on, EFR on, mode: 8 data bits, no parity, 1 stop bit
	OUT (C) , A
	LD C, CNTLB0
	LD A, 00000001b		; MPBT off, MP off, prescale 10, parity whatever, divide ratio 16, speed select x2 (25kbaud for 8MHz clock)
	OUT (C), A
	LD C, STAT0 
	LD A, 00h			; disable interrupts
	OUT (C), A
	; initialise the TellyMate
	LD C, TDR0
	LD A, 'V'			
	CALL putChar
	CALL putChar
	CALL clrScr
	LD A, 25
	CALL delay
	CALL tm_transmitEnable
    RET

; clears the screen 
clrScr:
	PUSH BC
	LD A, ESC
	CALL putChar
	LD A, 'E'
	CALL putChar
	POP BC
    RET

; moves the cursor to position (0,0)
home:
	PUSH BC
	LD A, ESC
	CALL putChar
	LD A, 'H'
	CALL putChar
	POP BC
    RET
 
; turns on the cursor for the character at the current cursor position
cursorOn:
	PUSH BC
	LD A, ESC
	CALL putChar
	LD A, 'e'
	CALL putChar
	POP BC
	RET

; turns off the cursor for the character at the current cursor position
cursorOff:
	PUSH BC
	LD A, ESC
	CALL putChar
	LD A, 'f'
	CALL putChar
	POP BC
    RET
		
writeLn:
	CALL writeStr
	CALL nextLine
	RET

; moves the cursor to a new X, Y position on screen
; B - X position
; C - Y position
; destroys A
; TODO: do error checking
gotoXY:
	PUSH BC
	LD A, ESC
	CALL putChar
	LD A, 'Y'
	CALL putChar
	LD A, C
	ADD A, 32	; TellyMate magic number
	CALL putChar
	LD A, B
	ADD A, 32	; TellyMate magic number
	CALL putChar
	POP BC
    RET
		
cursorLShift:
	PUSH BC
	LD C, TDR0
	LD A, ESC
	CALL putChar
	LD A, 'D'
	CALL putChar
	POP BC
	RET

; sends a character to TellyMate.
; for printable characters,
; puts the character on the screen
; and moves the cursor over by one
; can also be used to write control sequences.
; A - character to be written
putChar:
	PUSH BC
	PUSH AF			; save the character to send
	LD B, 0			; making sure bits A15-A8 of the I/O port number are 0 for the subsequent I/O operations
.loop:
	LD C, STAT0
	IN A, (C)
	BIT 1, A		; Transmit Data Register Empty bit
	JR Z, .loop
	POP AF			; restore the character to send
	LD C, TDR0
	OUT (C), A
	POP BC
	RET


; gets a single character from the screen at current cursor position
; and moves the cursor over by one
; result in A
; TODO
getChar:
	PUSH BC
	LD A, ESC			; send the transfer command
	CALL putChar
	LD A, '|'
	CALL putChar
    LD C, STAT0
.rxloop:
	IN A, (C)       	; read the ASCI0 status word
    BIT 7, A        	; check the Receive Data Register Full bit
    JR Z, .rxloop     	; if zero, means a byte has not been received, waiting
    LD C, RDR0   
    IN A, (C)       	; read in the received byte into A
	POP BC
    RET



; writes a string to the display at current cursor position
; IX - null-terminated string to write
writeStr:
	PUSH IX
.loop:
	LD A, (IX)
	CP 0
    JR Z, .end
	CALL putChar
	INC IX
	JR .loop
.end:
	POP IX
	RET


; goes to the next line of the display
; if there are free lines below the current ones, goes to the next one
; if we're already in the last line, the whole display is scrolled up
nextLine:
	PUSH BC
	LD A, CR
	CALL putChar
	POP BC
    RET

scroll:
	CALL tm_saveCursor
	LD B, 0
	LD C, MAX_Y
	CALL gotoXY
	CALL nextLine
	CALL tm_restoreCursor
	RET
	
	
; ###########################################################################
; ################ private routines #########################################
; ###########################################################################

; TODO
tm_transmitEnable:
	LD A, 18h			; Cancel any pending escape sequence
	CALL putChar
	LD A, ESC
	CALL putChar
	LD A, 7Eh			; ~ character
	CALL putChar
	CALL putChar
	CALL putChar
	CALL putChar
	RET
	
tm_diag:
	PUSH BC
	LD A, ESC
	CALL putChar
	LD A, 'Q'
	CALL putChar
	POP BC
	RET

tm_saveCursor:
	PUSH BC
	LD C, TDR0
	LD A, ESC
	CALL putChar
	LD A, 'j'
	CALL putChar
	POP BC
	RET

tm_restoreCursor:
	PUSH BC
	LD C, TDR0
	LD A, ESC
	CALL putChar
	LD A, 'k'
	CALL putChar
	POP BC
	RET
	