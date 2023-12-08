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
	LD B, 0				; making sure bits A15-A8 of the I/O port number are 0 for the subsequent I/O operations
	LD C, CNTLA0
	LD A, 00111100b		; MPE off, RE off, TE on, RTS on, EFR on, mode: 8 data bits, no parity, 1 stop bit
	CALL tm_txWaitSend
	LD C, CNTLB0
	LD A, 00000001b		; MPBT off, MP off, prescale off, parity whatever, divide ratio 10, speed select x320
	CALL tm_txWaitSend
	LD C, STAT0 
	LD A, 00h			; disable interrupts
	CALL tm_txWaitSend
	; LD A, 25
	; CALL delay
	; CALL tm_transmitEnable
    RET

; clears the screen 
clrScr:
	PUSH BC
	LD B, 0
	LD C, (TDR0)
	LD A, ESC
	CALL tm_txWaitSend
	LD A, 'E'
	CALL tm_txWaitSend
	POP BC
    RET

; moves the cursor to position (0,0)
home:
	PUSH BC
	LD B, 0
	LD C, (TDR0)
	LD A, ESC
	CALL tm_txWaitSend
	LD A, 'H'
	CALL tm_txWaitSend
	POP BC
    RET
 
; turns on the cursor for the character at the current cursor position
cursorOn:
	PUSH BC
	LD B, 0
	LD C, (TDR0)
	LD A, ESC
	CALL tm_txWaitSend
	LD A, 'e'
	CALL tm_txWaitSend
	POP BC
	RET

; turns off the cursor for the character at the current cursor position
cursorOff:
	PUSH BC
	LD B, 0
	LD C, (TDR0)
	LD A, ESC
	CALL tm_txWaitSend
	LD A, 'f'
	CALL tm_txWaitSend
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
	LD B, 0
	LD C, (TDR0)
	LD A, ESC
	CALL tm_txWaitSend
	LD A, 'Y'
	CALL tm_txWaitSend
	LD A, C
	ADD A, 32	; TellyMate magic number
	CALL tm_txWaitSend
	LD A, B
	ADD A, 32	; TellyMate magic number
	CALL tm_txWaitSend
	POP BC
    RET
		
cursorLShift:
	PUSH BC
	LD B, 0
	LD C, (TDR0)
	LD A, ESC
	CALL tm_txWaitSend
	LD A, 'D'
	CALL tm_txWaitSend
	POP BC
	RET

; puts a single character on the screen
; and moves the cursor over by one
; A - character to be written
putChar:
	PUSH BC
	LD B, 0
	LD C, (TDR0)
	CALL tm_txWaitSend
	POP BC
    RET


; gets a single character from the screen at current cursor position
; and moves the cursor over by one
; result in A
; TODO
getChar:
;	PUSH BC
;.empty:
;	IN A, (DART_B_CMD)
;	BIT 0, A
;	JR Z, .cont
;	IN A, (DART_B_DAT)
;	JR .empty				; make sure the transmitter buffer is empty
;.cont:
;	LD A, ESC				; send the transfer command
;	OUT (DART_B_DAT), A
;	LD A, '|'
;	OUT (DART_B_DAT), A
;	LD B, 50				; give some time the tm to respond
;.delay:						; 50x13 clock cycles...
;	DJNZ .delay				; ...is enough to send 10 bits at x64 UART clock
;.loop:
;	IN A, (DART_B_CMD)
;	BIT 0, A
;	JR Z, .loop
;	IN A, (DART_B_DAT)
;	POP BC
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
	LD B, 0
	LD C, (TDR0)
	LD A, CR
	CALL tm_txWaitSend
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
;	LD A, 18h			; Cancel any pending escape sequence
;	OUT (DART_B_DAT), A
;	LD A, ESC
;	OUT (DART_B_DAT), A
;	LD A, 7Eh			; ~ character
;	OUT (DART_B_DAT), A
;	OUT (DART_B_DAT), A
;	OUT (DART_B_DAT), A
;	OUT (DART_B_DAT), A
	RET
	
tm_diag:
	PUSH BC
	LD B, 0
	LD C, (TDR0)
	LD A, ESC
	CALL tm_txWaitSend
	LD A, 'Q'
	CALL tm_txWaitSend
	POP BC
	RET
	
tm_txWaitSend:
	PUSH AF
	PUSH BC
.loop:
	LD B, 0
	LD C, STAT0
	IN A, (C)
	BIT 1, A		; Transmit Data Register Empty bit
	JR Z, .loop
	POP BC
	POP AF
	OUT (C), A
	RET

tm_saveCursor:
	PUSH BC
	LD B, 0
	LD C, (TDR0)
	LD A, ESC
	CALL tm_txWaitSend
	LD A, 'j'
	CALL tm_txWaitSend
	POP BC
	RET

tm_restoreCursor:
	PUSH BC
	LD B, 0
	LD C, (TDR0)
	LD A, ESC
	CALL tm_txWaitSend
	LD A, 'k'
	CALL tm_txWaitSend
	POP BC
	RET
	