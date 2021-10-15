;----------------------------------------------------
; Project: aniol64.zdsp
; File: snd.asm
; Date: 9/2/2021 10:33:00
;
; Created with zDevStudio - Z80 Development Studio.
;
; Handling of YM2413 sound chip
;
;----------------------------------------------------

; sound chip is selected with A7
SND_CMD equ 01111110b ; control port of the YM2413
SND_DAT equ 01111111b ; ; content port of the YM241

snd_init:
        LD C, SND_CMD
        LD A, 0Eh       ; rythm control register
        OUT (C), A
        LD C, SND_DAT
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
