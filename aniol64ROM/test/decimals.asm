;----------------------------------------------------
; Project: decimals.zdsp
; Main File: decimals.asm
; Date: 11/15/2021 9:45:44
;
; Created with zDevStudio - Z80 Development Studio.
;
;----------------------------------------------------

; A - the bonary number to convert:
; Result:
; hundreds in C
; tens in B
; units in A
PROC
dec_toBcd:
        CP 100
        JR C, _tens   ; if less than 100
        SUB 100
        INC C         ; hundreds counted in C
        JR dec_toBcd
_tens:
        CP 10
        JR C, _units   ; if less than 10
        SUB 10
        INC B           ; tens and hundreds counted in B
        JR _tens
_units:                 ; least significant digit now in A
        RET
ENDP

; converts a bcd number stored in C, B, A to ASCII
; result in C, B, A
PROC
dec_bcd2asc:
        PUSH AF
        LD A, C
        ADD 30h
        LD C, A
        LD A, B
        ADD 30h
        LD B, A
        POP AF
        ADD 30h
        RET
ENDP

PROC
dec_format:
        RET

ENDP

PROC
dec_parse:
        CP 10
        JR C, _units   ; if less than 10,
        SUB 10
        INC B
_units:
        RET
        RET

ENDP
