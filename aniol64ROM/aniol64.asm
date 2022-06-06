;----------------------------------------------------
; Project: aniol64.zdsp
; File: aniol64.asm
; Date: 4/26/2022 18:42:17
;
; Created with zDevStudio - Z80 Development Studio.
;
;----------------------------------------------------


org 0000h
        LD SP, RAMTOP   ; initialise stack pointer to the top of available RAM
        IM 2            ; set interupt mode to 2
        LD A, 01h       ; higher byte of the interrupt vector table
        LD I, A         ; set the vector table address
		EI				; enable interrupts
		CALL resetNmiHandler
        JP boot         ; jump over the interrupt handlers for NMI and mode 1 INT

org 0020h
		Version: defb 0, 0, 0, 0
		Build: defw 0000h

org 0038h
        ; respond to mode 1 interrupt
        EX AF, AF'       
        EXX
        CALL handleInt 
        EXX
        EX AF, AF'		
        EI
        RETI

org 0066h
        ; NMI handler
        PUSH AF
        CALL handleNmi
		CALL customNmiHandler
        POP AF
        EI
        RETN

org 0100h
        ; interrupt vector table
        KeyClickHandler: defb 38h, 00h ; we're pointing back at the mode 1 INT handler
                                        ; so that the routine works for both mode 1 and 2
                                        ; note, low order byte goes first
		; DartRxHandler: 


Aniol: defb   "               _ANIOL640_", 0
RAMTOP 				equ 0BFFFh
TestAddr 			equ 8001h  		; points to the beginning of RAM
KbdBuff 			equ 8012h       ; 1 byte buffer
Echo 				equ 8013h
Cursor				equ 8014h
NmiCount 			equ 8035h		; 2 byte number
Random 				equ 8037h		; 2 byte number
Banks 				equ 8039h
VgaCurX 			equ 8040h
VgaCurY 			equ 8041h
customNmiHandler 	equ 8042h		; 3 byte procedure, either RET or JP **
LineBuff 			equ 8100h		; 256 byte buffer
PROGRAM_DATA 		equ 8200h


Ready: defb     "Ready", 0
Hello: defb     "Hello", 0

boot:
        LD A, 1
        CALL setRomBank
        LD A, 1
        CALL setRamBank
        ; init devices 
        CALL vga_init

        ; init the keyboard buffer to avoid a bogus character during the first read
        LD A, 0
        LD (KbdBuff), A
		LD (Random), A
		LD (Random + 1), A
		
		LD A, TRUE
		LD (Cursor), A
		LD (Echo), A

        ; greetings
		CALL vga_nextLine
        LD IX, Aniol
        CALL vga_writeLn
		; set up permanent storage
		CALL dos_setUpCf
		CALL dos_checkNvram
		
        LD IX, Ready
        CALL vga_writeLn
		
        CALL bzr_beep
        LD A, 50
        CALL delay
        CALL bzr_beep
        LD A, 50
        CALL delay
        CALL bzr_beep

        ; wait for user input from here on in
        CALL cmd_main
loop:
        HALT
        JP loop

include cmd.asm
include mon.asm
include term.asm
include dos.asm
include snake.asm
include test/test.asm
include lib/util.asm
include lib/str.asm
include lib/mem.asm
;include lib/list.asm
include dev/bzr.asm
include dev/vga.asm
include dev/dart.asm
include dev/cf.asm
include dev/kbd.asm ; this goes last becasue of the org 3700h inside


PROC
handleInt:
        LD A, (KbdBuff)
        CP 0            	; checking if keyboard buffer is empty
        RET NZ         		; this is essentially software debouncing
        CALL kbd_input
        CP 08            	; check if BACKSPACE was pressed
        JR Z, _bkspc
        CP 20h              ; checks if the key corresponds to a control character
        JR C, _noEcho   	; skip echo if less	
		LD B, A
		LD A, (Echo)
		CP FALSE
		JR Z, _noEcho
		LD A, B
        CALL vga_putChar	; echo the character to screen, but don't remove it from the keyboard buffer
_noEcho:
        CALL bzr_click
        RET
_bkspc:
        CALL vga_cursorLShift  ; TODO: check if you're already in the beginning of line
        LD A, ' '
        CALL vga_putChar
        CALL vga_cursorLShift
        JR _noEcho
ENDP

PROC
handleNmi:
        LD A, (NmiCount)
        INC A
        LD (NmiCount), A
		CP 0
		JR Z, _inc2
		JR _end
_inc2:
		LD A, (NmiCount + 1)
		INC A
		LD (NmiCount + 1), A
_end:
        RET
ENDP

; allows to register a routine that will be executed each time NMI is fired
; the routine needs to end with a RET instruction
; address of the routine in HL
; destroys A
registerNmiHandler:
		LD A, $C3					; JP ** instruction code
		LD (customNmiHandler), A
		LD (customNmiHandler + 1), HL
		RET

; restores the default NMI handler that is called each time NMI is fired		
; the default hadler consists of an empty routine, i.e. just the RET instruction
; destroys A
resetNmiHandler:
		LD A, 0C9h					; RET instruction
		LD (customNmiHandler), A	; by default we just return from the custom NMI handler
		RET


