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
        CALL snd_dataDelay
        LD A, 00011111b ; melody sound on, rythm instruments all on
        OUT (C), A
        CALL snd_dataDelay
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
        CALL snd_dataDelay
        RET

;
snd_playNote:

        RET
; no delay is actually needed
; the YM2413 only requires 12 clock cycles after an address write
; which roughly translates to 6 Z80 clock cycles.
; the LD C, * and LD A, * instructions preciding any write to the YM2413
; are therefore enough to satisfy the timing requirement
snd_ctrlDelay:
        RET

; 84 master clock cycles of the YM2413 are needed after a data write
; the YM2413 is clocked by a 3.5MHz clock, roughly twice the speed of the Z80 clock
; considering 17 Z80 clock cycles to perform the CALL and 4 to perform the RET
; this leaves us with 5.25 4-cycle NOP instructions.
; rounding this down to 5, as data load into A and C is performed after each write
; which takes up the remainder of the time
snd_dataDelay:
        NOP
        NOP
        NOP
        NOP
        NOP
        RET

snd_vibrato:
        RET

snd_beep:
        ; set the instrument and volume
        LD A, 30h ; channel 0 (30 + 0) for instrument selection
        LD C, SND_CMD
        OUT (C), A
        CALL snd_dataDelay
        LD A, 4Fh ; flute at max volume
        LD C, SND_DAT
        OUT (C), A
        CALL snd_dataDelay
        ; set the frequency LSBs
        LD A, 10h ; channel 0 (10 + 0)
        LD C, SND_CMD
        OUT (C), A
        CALL snd_dataDelay
        LD A, 9Fh ; some random F number
        LD C, SND_DAT
        OUT (C), A
        CALL snd_dataDelay
        ; play note
        LD A, 20h ; channel 0 (20 + 0)
        LD C, SND_CMD
        OUT (C), A
        CALL snd_dataDelay
        LD A, 0001000b ; D5: sustain off, D4: key ON, D3-D1: octave 4, D0: octave number MSB 0
        LD C, SND_DAT
        OUT (C), A
        ; stop the note after 200ms
        LD A, 20
        CALL delay
        LD A, 20h ; channel 0 (20 + 0)
        LD C, SND_CMD
        CALL snd_dataDelay
        OUT (C), A
        LD A, 0000000b ; D5: sustain off, D4: key OFF, D3-D1: octave 4, D0: octave number MSB 0
        LD C, SND_DAT
        OUT (C), A

        RET

snd_click:
        RET

snd_play:
        RET
