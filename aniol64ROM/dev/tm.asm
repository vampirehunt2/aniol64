; TellyMate PAL driver
; http://www.batsocks.co.uk/products/Other/TellyMate_UserGuide_ControlSequences.htm
; 

MAX_X equ 37
MAX_Y equ 24
ESC   equ 1Bh
LF    equ 10
CR	  equ 13

tm_initSeq:
	defb 0, 00011000b	; channel reset
	defb 4, 11000100b	; x64 clock, no parity, 1 stop bit
	defb 3, 11000001b	; Rx 8 bits enable Rx
	defb 5, 01101000b	; Tx 8 bits, Tx enabled
	defb 1, 10000000b	; disable interrupts, enable WAIT

Blank: defb "                                    ", 0

dspInit:
	LD HL, tm_initSeq
	LD B, 10
	LD C, DART_B_CMD
	OTIR
	CALL tm_transmitEnable
    RET

; clears the screen 
clrScr:
	LD A, ESC
	OUT (DART_B_DAT), A
	LD A, 'E'
	OUT (DART_B_DAT), A
    RET

; moves the cursor to position (0,0)
home:
	LD A, ESC
	OUT (DART_B_DAT), A
	LD A, 'H'
	OUT (DART_B_DAT), A
    RET
 
; turns on the cursor for the character at the current cursor position
cursorOn:
	LD A, ESC
	OUT (DART_B_DAT), A
	LD A, 'e'
	OUT (DART_B_DAT), A
	RET

; turns off the cursor for the character at the current cursor position
cursorOff:
	LD A, ESC
	OUT (DART_B_DAT), A
	LD A, 'f'
	OUT (DART_B_DAT), A
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
	LD A, ESC
	OUT (DART_B_DAT), A
	LD A, 'Y'
	OUT (DART_B_DAT), A
	LD A, C
	ADD A, 32	; TellyMate magic number
	OUT (DART_B_DAT), A
	LD A, B
	ADD A, 32	; TellyMate magic number
	OUT (DART_B_DAT), A
    RET
		
cursorLShift:
	LD A, ESC
	OUT (DART_B_DAT), A
	LD A, 'D'
	OUT (DART_B_DAT), A
	RET

; puts a single character on the screen
; and moves the cursor over by one
; A - character to be written
putChar:
	OUT (DART_B_DAT), A
	; waiting for the character to be sent is done automatically
	; since WAIT function is enabled.
    RET

PROC
; gets a single character from the screen at current cursor position
; and moves the cursor over by one
; result in A
getChar:
	LD A, ESC
	OUT (DART_B_DAT), A
	LD A, '|'
	OUT (DART_B_DAT), A
_loop:
	IN A, (DART_B_CMD)
	BIT 0, A
	JR Z, _loop
	IN A, (DART_B_DAT)
    RET
ENDP

PROC
; writes a string to the display at current cursor position
; IX - null-terminated string to write
writeStr:
	PUSH IX
_loop:
	LD A, (IX)
	CP 0
    JR Z, _end
	CALL putChar
	INC IX
	JR _loop
_end:
	POP IX
	RET
ENDP

; goes to the next line of the display
; if there are free lines below the current ones, goes to the next one
; if we're already in the last line, the whole display is scrolled up
nextLine:
	LD A, CR
	OUT (DART_B_DAT), A
    RET
	
	
; ###########################################################################
; ################ private routines #########################################
; ###########################################################################


tm_transmitEnable:
	LD A, ESC
	OUT (DART_B_DAT), A
	LD A, '~'
	OUT (DART_B_DAT), A
	OUT (DART_B_DAT), A
	OUT (DART_B_DAT), A
	OUT (DART_B_DAT), A
	RET
	
tm_diag:
	LD A, ESC
	OUT (DART_B_DAT), A
	LD A, 'Q'
	OUT (DART_B_DAT), A