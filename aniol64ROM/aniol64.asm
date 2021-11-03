;----------------------------------------------------
; Project: aniol64.zdsp
; Main File: aniol64.asm
; Date: 11/21/2019 12:50:17
;
; Created with zDevStudio - Z80 Development Studio.
;
;----------------------------------------------------

org 0000h
        LD SP, 0FFFFh   ; initialise stack pointer to the top of available RAM
        IM 1            ; set interupt mode to 1,
                        ; TODO: this may not work after DART is added
        EI              ; enable interrupts
        JP boot ; jump over the interrupt handlers for NMI and mode 1 INT

org 0038h
        ; respond to interrupt
        EX AF, AF'
        EXX
        CALL kbd_input
        CALL lcd_putChar ; echo the character to screen, but don't remove it from the keyboard buffer
        EXX
        EX AF, AF'
        EI
        RETI

org 0066h
        ; respond to NMI
        EI
        RETN

boot:
        ; init LCD
        CALL lcd_init
        CALL lcd_clrScr

        ; greetings
        LD IX, Aniol64
        CALL lcd_wriStr
        LD IX, Ready
        CALL lcd_wriStr

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
        CALL lcd_wriStr

        ; display prompt
        LD IX, Prompt
        CALL lcd_wriStr

        CALL bzr_beep
        LD A, 50
        CALL delay
        CALL bzr_beep
        LD A, 50
        CALL delay
        CALL bzr_beep
        ;CALL snd_init

        ; wait for user input from here on in
        HALT

Aniol64: defb   "     _ANIOL 64_     ", 0
Ready: defb     "Ready               ", 0
Hello: defb     "Hello", 0
Prompt: defb    ">", 0
NvRamOk: defb   "NVRAM OK            ", 0
NvRamNok: defb  "NVRAM Error         ", 0

include util.asm
include bzr.asm
include dos.asm
include mon.asm
include lcd.asm
include str.asm
include dart.asm
include snd.asm
include mem.asm
include io.asm
include clk.asm
include kbd.asm ; this goes last becasue of the org 4000h inside











