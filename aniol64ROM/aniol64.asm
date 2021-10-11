;----------------------------------------------------
; Project: aniol64.zdsp
; Main File: aniol64.asm
; Date: 11/21/2019 12:50:17
;
; Created with zDevStudio - Z80 Development Studio.
;
;----------------------------------------------------

 org 0
        LD SP, 0FFFFh   ; initialise stack pointer to the top of available RAM
        IM 1            ; set interupt mode to 1,
                        ; this may not work after DART is added
        EI              ; enable interrupts

        CALL lcd_init
        CALL lcd_clrScr

        LD IX, Ready
        CALL lcd_wriStr

        ;CALL snd_play  ; startup melody
        HALT

Ready: defb "Ready", 0

include dos.asm
include mon.asm
include lcd.asm
include str.asm
include kbd.asm
include dart.asm
include snd.asm
include mem.asm
include io.asm











