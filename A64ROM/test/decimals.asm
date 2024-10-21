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
dec_toBcd:
        CP 100
        JR C, .tens   ; if less than 100
        SUB 100
        INC C         ; hundreds counted in C
        JR dec_toBcd
.tens:
        CP 10
        JR C, .units   ; if less than 10
        SUB 10
        INC B           ; tens and hundreds counted in B
        JR .tens
.units:                 ; least significant digit now in A
        RET

; converts a bcd number stored in C, B, A to ASCII
; result in C, B, A
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

dec_format:
        RET


dec_parse:
        CP 10
        JR C, .units   ; if less than 10,
        SUB 10
        INC B
.units:
        RET
        RET

