;----------------------------------------------------
; Project: aniol64.zdsp
; File: bzr.asm
; Date: 10/26/2021 17:20:30
;
; Created with zDevStudio - Z80 Development Studio.
;
;----------------------------------------------------

bzr_beep:
        LD C, 01111111b ; buzzer is activated by A7
        LD A, 0FFh
        OUT (C), A
        LD A, 20 ; delay 200ms
        CALL delay
        LD A, 00h
        OUT (C), A
        RET

bzr_click:
        LD C, 01111111b ; buzzer is activated by A7
        LD A, 0FFh
        OUT (C), A
        CALL delay37us
        LD A, 00h
        OUT (C), A
        RET
