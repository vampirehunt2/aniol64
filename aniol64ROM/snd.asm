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
SND_DAT equ 01111111b ; ; content port of the YM2413

FLUTE equ 04h

snd_init:
        LD C, SND_CMD
        LD A, 0Eh       ; rythm control register
        OUT (C), A
        LD C, SND_DAT
        LD A, 00011111b ; melody sound on, rythm instruments all on
        OUT (C), A
        CALL snd_beep
        RET

; A - instrument 0-15, as per the datasheet
; B - channel 0-8, as per datasheet
snd_instrSel:
        PUSH AF    ; saving A for later
        LD A, 30h ; base address of instrument selection register sets
        ADD A, B
        LD C, SND_CMD
        OUT (C), A
        POP AF  ; instrument now in A
        AND A   ; clear carry
        RLA
        RLA
        RLA
        RLA     ; instrument now in D7-D4
        AND 0Fh ; set maximum volume
        LD C, SND_DAT
        OUT (C), A
        RET

;
snd_playNote:

        RET

snd_ctrlWait
        RET

snd_dataWait
        RET

snd_vibrato:
        RET

snd_beep:
        ; set the instrument and volume
        LD A, 30 ; channel 0 (30 + 0) for instrument selection
        LD C, SND_CMD
        OUT (C), A
        LD A, 4Fh ; flute at max volume
        LD C, SND_DAT
        OUT (C), A
        ; set the frequency LSBs
        LD A, 10h ; channel 0 (10 + 0)
        LD C, SND_CMD
        OUT (C), A
        LD A, 9Fh ; some random F number
        LD C, SND_DAT
        OUT (C), A
        ; play note
        LD A, 20h ; channel 0 (20 + 0)
        LD C, SND_CMD
        OUT (C), A
        LD A, 0001000b ; D5: sustain off, D4: key on, D3-D1: octave 4, D0: octave number MSB 0
        LD C, SND_DAT
        OUT (C), A

        ; TODO end the beep sometime

        RET

snd_click:
        RET

snd_play:
        RET
