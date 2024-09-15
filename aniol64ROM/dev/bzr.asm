;----------------------------------------------------
; Project: aniol64.zdsp
; File: bzr.asm
; Date: 10/26/2021 17:20:30
;
; Created with zDevStudio - Z80 Development Studio.
;
;----------------------------------------------------

BZR_PORT equ 10111111b  ; BFh buzzer is activated by A6

bzr_beep:
		PUSH AF
		PUSH BC
        LD C, BZR_PORT
        LD A, 0FFh
        OUT (C), A
        LD A, 10 ; delay 100ms
        CALL delay
        LD A, 00h
        OUT (C), A
		POP BC
		POP AF
        RET

bzr_click:
		PUSH AF
		PUSH BC
        LD C, BZR_PORT
        LD A, 0FFh
        OUT (C), A
        CALL delay37us
        LD A, 00h
        OUT (C), A
		POP BC
		POP AF
        RET
