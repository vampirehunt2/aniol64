;----------------------------------------------------
; Project: aniol64.zdsp
; File: snd.asm
; Date: 9/2/2021 10:33:00
;
; Created with zDevStudio - Z80 Development Studio.
;
;----------------------------------------------------

snd_init:
        LD C, 11101110b ; control port of the YM2413
        LD A, 0Eh       ; rythm control register
        OUT (C), A
        LD C, 11101111b ; content port of the YM2413
        LD A, 00011111b ; rythm on, rythm instruments all on
        OUT (C), A

        CALL snd_beep

        RET

snd_ctrlWait
        RET

snd_dataWait
        RET

snd_vibrato:
        RET

snd_beep:
        RET

snd_click:
        RET

snd_play:
        RET
