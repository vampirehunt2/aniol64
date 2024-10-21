;----------------------------------------------------
; Project: aniol64.zdsp
; File: io.asm
; Date: 10/1/2021 15:22:06
;
; Created with zDevStudio - Z80 Development Studio.
;
;----------------------------------------------------

; writes a null-terminated string to an output port
; IX: address of the string
; C: port number
wriStr:
        LD A,(IX+0)
        CP 0
        RET Z
        OUT (C),A
        INC IX
        JR wriStr

readLn:
        RET

readKey:
        RET
