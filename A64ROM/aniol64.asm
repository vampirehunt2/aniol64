;----------------------------------------------------
; Project: aniol64.zdsp
; File: aniol64.asm
; Date: 4/26/2022 18:42:17
;
; Created with zDevStudio - Z80 Development Studio.
;
;----------------------------------------------------
 
 device NOSLOT64K 

 org 0000h

	LD SP, RAMTOP   ; initialise stack pointer to the top of available RAM
	IM 2			; set interupt mode to 2
	LD A, 01h	   	; higher byte of the interrupt vector table
	LD I, A		 	; set the vector table address
	;CALL copyRom2Ram
	EI				; enable interrupts
	CALL resetNmiHandler
	JP boot		 	; jump over the interrupt handlers for NMI and mode 1 INT

 ds 0020h - $, 0
Version: defb 0, 0, 0, 0
Build: defw 0000h

 ds 0038h - $, 0
	; respond to mode 1 interrupt
	EX AF, AF'	   
	EXX
	CALL handleInt 
	EXX
	EX AF, AF'		
	EI
	RETI

 ds 0066h - $, 0
	; NMI handler
	PUSH AF
	CALL handleNmi
	CALL customNmiHandler
	POP AF
	EI
	RETN

 ds 0100h - $, 0
	; interrupt vector table
KeyClickHandler: defb 38h, 00h ; we're pointing back at the mode 1 INT handler
									; so that the routine works for both mode 1 and 2
									; note, low order byte goes first



Aniol: 
 ds (MAX_X / 2) - 5, ' ' ; center the title message
 defb   "_ANIOL 64_"
 defb 0

RAMTOP 				equ 0BFFFh
HIGHROM				equ 4000h
JUMP_TABLE          equ 7E00h
TestAddr 			equ 8001h  		; points to the beginning of RAM
KbdBuff 			equ 8012h	   ; 1 byte buffer
Echo 				equ 8013h
Cursor				equ 8014h
TxChA				equ 8015h
TxChB				equ 8016h
Scroll		    	equ 8017h	
Colour              equ 8018h
FontAddr            equ 8019h       ; 2 byte font address
PrevChar            equ 8021h
NmiCount 			equ 8035h		; 2 byte number
Random 				equ 8037h		; 2 byte number
Banks 				equ 8039h
CurX 				equ 8040h
CurY 				equ 8041h
customNmiHandler 	equ 8042h		; 3 byte procedure, either RET or JP **
Ps2Shift			equ 8045h
DOS_AREA			equ 8046h
LineBuff 			equ 8100h		; 128 byte buffer
PrevLineBuff        equ 8180h
PROGRAM_DATA 		equ 8200h


Ready: defb	 "Ready", 0


boot:
	CALL bzr_beep	
	LD A, 25
	CALL delay
	CALL bzr_beep
	LD A, 25
	CALL delay
	CALL bzr_beep

	; init the RNG:
	LD A, 0
	LD (Random), A
	LD (Random + 1), A

	;CALL mem_copyRom2Ram
	
	; init the display
	CALL dspInit

	; initialise the keyboard
	CALL keyInit


	; greetings
	CALL nextLine
	LD IX, Aniol
    LD A, CYAN
    LD (Colour), A
	CALL writeLn
	
	; set up permanent storage
    LD A, GREEN * 16
    LD (Colour), A
	CALL dos_setUpCf
	CALL dos_checkNvram
	CALL dos_autoExec

    LD IX, Ready
	CALL writeLn
	
	; wait for user input from here on in
	CALL cmd_main
loop:
	HALT
	JP loop


handleNmi:
	LD A, (NmiCount)
	INC A
	LD (NmiCount), A
	CP 0
	JR Z, .inc2
	JR .end
.inc2:
	LD A, (NmiCount + 1)
	INC A
	LD (NmiCount + 1), A
.end:
	RET


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


; device drivers
 include dev/bzr.asm
 include dev/dart.asm
 include dev/cf.asm

; display drivers
 ;include dev/pal.asm
 ;include dev/colourvga.asm
 ;include dev/80col.asm
 ;include dev/tm.asm
 include dev/vga.asm

; keyboard drivers
 include dev/kbd.asm
 ;include dev/ps2.asm

; libraries
 include lib/util.asm
 include lib/str.asm
 include lib/mem.asm
 include lib/list.asm
 include lib/math.asm

; test routines
 include test/test.asm

; OS components
 include cmd.asm
 include dos.asm
 include cpm.asm

; built-in programs
 include prg/mon.asm
 include prg/term.asm
 include prg/snake.asm
 include prg/rogue.asm
 include prg/onp.asm
 include prg/edit.asm
 include prg/tar.asm
 include prg/man.asm

 display "Low ROM program size: ", $
 assert $ < 3800h, "program leaks over the VRAM"

; 3800h-3FFFh reserved for VRAM in case vga.asm is used.
; high ROM code
 ds HIGHROM - $, 0      ; skip assembly over VGA VRAM
 include apl/apl.asm
 include apl/run.asm
 include apl/sys.asm
 
 display "High ROM program size: ", $
 assert $ < JUMP_TABLE, "program leaks over the jump table"

  ds JUMP_TABLE - $, 0      ; put the jump table in the last page of ROM
  include lib/jmp.asm    
