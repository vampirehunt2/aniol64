;----------------------------------------------------
; Project: aniol64.zdsp
; File: dsp.asm
; Date: 4/25/2022 19:08:56
;
; Created with zDevStudio - Z80 Development Studio.
;
;----------------------------------------------------

IF version=32
include lcd.asm

initDsp:
        CALL lcd_init
        RET

wriStr:
        CALL lcd_wriStr
        RET

scroll:
        CALL lcd_scroll
        RET

ELSE
include vga.asm

initDsp:
        CALL vga_init
        RET

wriStr:
        CALL vga_wriStr
        RET

scroll:
        CALL vga_scroll
        RET

ENDIF

