; Project: aniol64
; terminal program
; 09/05/2022

; This program turns the computer into a dumb terminal 
; running on the B port of the DART at 38400kbaud.
; Connection parameters are
; 	- 2 stop bits
;	- even parity
; 	- 8bits per character
; It uses software handshaking with Xon/Xoff on the receiving side.
; It uses no handshaking on the transmitting side, assuming the 
; computer on the other side is able to handle keyclicks in time.
; There is no teardown procedure implemented at this point,
; to exit the terminal program you have to reset the machine.
 
Program defb "A-Term", 0
Separator ds MAX_X, "="
defb 0

IntTable equ 0A000h
IntTableSize equ 8   ; just a guess


PROC
term_main: 
		CALL dart_init
		CALL term_resetScreen
		CALL term_setupInterrupts
		CALL term_greet
_loop:
		CALL dart_getChar	; using polling for now
		AND 01111111b		; make sure cursor is not stored
		CP 13				; check if it's a carriage return
		JR Z, _wrapLine
		CALL putChar	; put the received character on screen
		LD A, (VgaCurY)		; check if we're at the end of the screen
		CP MAX_Y
		CALL Z, term_wrapScreen	; if yes, wrap around to the top
		JR _loop
_wrapLine:
		CALL term_wrapLine
		JR _loop
		RET 
ENDP

term_wrapScreen:
		LD B, 0
		LD C, 3
		CALL gotoXY
		RET
		
term_wrapLine:
		CALL cursorOff
        XOR A           ; LD A, 0
        LD (VgaCurX), A ; move the cursor to the beginning of line
        LD A, (VgaCurY) ; load current cursor Y position (line number)
        INC A           
		LD (VgaCurY), A
		CALL cursorOn
		RET

term_resetScreen:
		CALL clrScr
		CALL home
		LD IX, Blank
		CALL writeLn
		LD IX, Program
		CALL writeLn
		LD IX, Separator
		CALL writeLn
		RET
		
PROC	
term_handleKeyClick:
		EX AF, AF'       
        EXX 
        CALL keyInput		  ; read a character from the keyboard
        CALL dart_putChar     ; send the character to the serial port    
        EXX
        EX AF, AF'		
        EI
        RETI
ENDP
				
PROC
handleDartRx:
		EX AF, AF'       
        EXX
		CALL dart_xoff
		CALL dart_getChar
		CALL putChar
		CALL dart_xon
		EXX
        EX AF, AF'		
		EI
		RETI
ENDP

PROC
term_setupInterrupts:
		DI
		LD HL, 0100h				; original interrupt handler table address
        LD DE, IntTable 			; new interrupt handler table address
        LD BC, IntTableSize  		; set loop counter to the size of the interrupt table
        LDIR         				; copy the interrupt handler table to the new location
		LD A, D 					; load the top byte of the new interrupt handler table to A
		LD I, A						; replace the original table address with the new one
		LD HL, term_handleKeyClick	; load the new keyClick interrupt handler address to HL
		LD (IntTable + 0), HL		; switch the keyClick interrupt handler to the new one
		EI
		RET
ENDP

PROC
term_greet:
		LD IX, Program
_loop:
		LD A, (IX)
		CP 0
		JR Z, _end
		CALL dart_putChar
		INC IX
		JR _loop
_end:
		RET
ENDP

		