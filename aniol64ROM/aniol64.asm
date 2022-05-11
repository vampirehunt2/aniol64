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
        EI              ; enable interrupts
        JP boot         ; jump over the interrupt handlers for NMI and mode 1 INT

; interrupt handlers
org 0038h
        ; respond to mode 1 interrupt
        JP handleKeyClick
        
org 003Ch
        JP handleDartRx


org 0066h
        ; NMI handler
        PUSH AF
        CALL handleNmi
        POP AF
        EI
        RETN

org 0100h
        ; interrupt vector table
        KeyClickHandler: defb 38h, 00h ; we're pointing back at the mode 1 INT handler
                                        ; so that the routine works for both mode 1 and 2
                                        ; note, low order byte goes first
        DartRxHandler: defb 3Ch, 00h                                                

Aniol: defb   "               _ANIOL640_", 0
RAMTOP equ 0BFFFh
TestAddr equ 8000h          ; points to the beginning of RAM
ClkScratchpad equ 8008h
ClkData equ 8009h
KbdBuff equ 8012h           ; a 1-byte buffer
LcdBuff equ 8020h           ; 20 byte long buffer + 1 byte for the trailing 0
NmiCount equ 8035h
Random equ 8036h            ; 2 bytes needed
Banks equ 8039h
VgaCurX equ 8040h
VgaCurY equ 8041h
LineBuff equ 8100h
PROGRAM_DATA equ 8200h

Ready: defb     "Ready", 0
Hello: defb     "Hello", 0
NvRamOk: defb   "NVRAM OK", 0
NvRamNok: defb  "NVRAM Error", 0

boot:
        LD A, 1
        CALL setRomBank
        LD A, 1
        CALL setRamBank
		
		LD A, 0
		LD (Random), A
		LD (Random + 1), A

        ; init LCD 
        CALL vga_init

        ; init the keyboard buffer to avoid a bogus character during the first read
        LD A, 0
        LD (KbdBuff), A

        ; greetings
        CALL vga_nextLine
        LD IX, Aniol
        CALL vga_writeLn

        ; check for NVRAM
        CALL memTest ; returns result in A
        CP 0
        JR Z, memTestOk
        LD IX, NvRamNok
        JP printMemTest
memTestOk:
        LD IX, NvRamOk
        JP printMemTest
printMemTest:
        CALL vga_writeLn
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


include mon.asm
include cmd.asm
include term.asm
include lib/str.asm
include lib/mem.asm
include lib/util.asm
include lib/math.asm
include dev/bzr.asm
include dev/lcd.asm
include dev/vga.asm
include dev/dart.asm
include dev/kbd.asm ; this goes last becasue of the org 2000h inside


PROC
handleKeyClick:
        EX AF, AF'       
        EXX
        LD A, (KbdBuff)
        CP 0                  ; checking if keyboard buffer is empty
        JP NZ, _end           ; this is essentially software debouncing
        CALL kbd_input
        CP 08                 ; check if BACKSPACE was pressed
        JR Z, _bkspc
        CP 20h                ; checks if the key corresponds to a control character
        JR C, _noEcho         ; skip echo if less
        CALL vga_putChar      ; echo the character to screen, but don't remove it from the keyboard buffer
_noEcho:
        CALL bzr_click
_end:
        EXX
        EX AF, AF'      
        EI
        RETI
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
        SRL A
        SRL A
        SRL A
        SRL A
        SRL A
        CP 31
        JR Z, _toggle
        RET
_toggle:
        CALL vga_XY2addr
        LD A, (HL)
        XOR 10000000b
        LD (HL), A
        RET
ENDP

