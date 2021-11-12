;----------------------------------------------------
; Project: aniol64.zdsp
; Main File: aniol64.asm
; Date: 11/21/2019 12:50:17
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

org 0038h
        ; respond to mode 1 interrupt
        EX AF, AF'
        EXX
        CALL kbd_input
        CALL lcd_putChar ; echo the character to screen, but don't remove it from the keyboard buffer
        CALL bzr_click
        CALL lcd_getPos
        CALL hex2asc
        LD A, D
        CALL lcd_putChar
        LD A, E
        CALL lcd_putChar
        EXX
        EX AF, AF'
        EI
        RETI

org 0066h
        ; NMI handler
        ;EX AF, AF'
        ;EXX
        ; respond to NMI
        ;EXX
        ;EX AF, AF'
        ;EI
        RETN

org 0100h
        ; interrupt vector table
        KeyClickHandler: defb 38h, 00h ; we're pointing back at the mode 1 INT handler
                                        ; so that the routine works for both mode 1 and 2
                                        ; note, low order byte goes first

boot:
        ; init LCD
        CALL lcd_init
        CALL lcd_clrScr

        ; <TEST>
        ;LD A, 45
        ;CALL lcd_setCursorPos
        ;LD IX, Hello
        ;CALL lcd_wriStr
        ;HALT
        ; </TEST>

        ; greetings
        LD IX, Aniol
        CALL lcd_wriStr


        ; check for NVRAM
        CALL lcd_gotoLn2
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

        CALL lcd_gotoLn3
        LD IX, Ready
        CALL lcd_wriStr
        CALL lcd_gotoLn4

        ; display prompt
        ;LD IX, Prompt
        ;CALL lcd_wriStr

        CALL bzr_beep
        LD A, 50
        CALL delay
        CALL bzr_beep
        LD A, 50
        CALL delay
        CALL bzr_beep
        ;CALL snd_init

        ; wait for user input from here on in
        ;CALL cmd_main
loop:
        HALT
        JP loop

Ready: defb     "Ready", 0
Hello: defb     "Hello", 0
Prompt: defb    ">", 0
NvRamOk: defb   "NVRAM OK", 0
NvRamNok: defb  "NVRAM Error", 0

include var.asm
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
include cmd.asm
include kbd.asm ; this goes last becasue of the org 2000h inside











