;----------------------------------------------------
; Project: aniol64.zdsp
; File: util.asm
; Date: 10/26/2021 17:23:49
;
; Created with zDevStudio - Z80 Development Studio.
;
;----------------------------------------------------

; A - delay x10ms
delay:
        CP 0
        RET Z
        DEC A
        CALL delay10ms
        JP delay

; waits for 37us * 1,8432MHz = 69 clock cycles
; which is just 11 NOPs, 4 cycles each
; plus 10 cycles for the RET
; plus 17 cycles to CALL this routine
delay37us:
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        RET

; waits for 1520us,
; which is 22 calls to lcd_delay37us
delay1520us:
        CALL delay37us
        CALL delay37us
        CALL delay37us
        CALL delay37us
        CALL delay37us
        CALL delay37us
        CALL delay37us
        CALL delay37us
        CALL delay37us
        CALL delay37us
        CALL delay37us
        CALL delay37us
        CALL delay37us
        CALL delay37us
        CALL delay37us
        CALL delay37us
        CALL delay37us
        CALL delay37us
        CALL delay37us
        CALL delay37us
        CALL delay37us
        CALL delay37us
        RET

delay10ms:
        CALL delay1520us
        CALL delay1520us
        CALL delay1520us
        CALL delay1520us
        CALL delay1520us
        CALL delay1520us
        CALL delay1520us
        CALL delay1520us
        RET
