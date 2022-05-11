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
; There is no terdown procedure implemented at this point,
; to exit the terminal program you have to reset the machine.

Program defb "A-Term", 0
Separator defb "========================================", 0

IntVector equ PROGRAM_DATA
INT_TABLE_INDEX equ 02h

term_main: 
		CALL dart_init
		CALL setupInterrupts
		CALL vga_clrScr
		LD IX, Program
		CALL vga_writeLn
		LD IX, Separator
		CALL vga_writeLn
		RET 
		
		
PROC
handleDartRx:
		EX AF, AF'       
        EXX
		CALL dart_xoff
		CALL dart_getChar
		CALL vga_putChar
		CALL dart_xon
		EXX
        EX AF, AF'		
		EI
		RET
ENDP

PROC
setupInterrupts:
		LD H, 01h			; interrupt handler table address
		LD L, 02h   		; interrupt handler table index
		LD (IntVector), HL	; save original interrupt vector 
		RET
ENDP

PROC 
restoreInterrupts:
ENDP
		