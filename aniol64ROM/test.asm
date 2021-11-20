;----------------------------------------------------
; Project: test.zdsp
; Main File: test.asm
; Date: 11/8/2021 11:52:05
;
; Created with zDevStudio - Z80 Development Studio.
;
;----------------------------------------------------


; returns the first token of a string
; and modifies the input string to cut out the token
; IX: address of the string
; result in IX
; rest of string in HL
PROC
str_tok:
        PUSH IX
_loop:
        LD A, (IX+0)
        CP 20h          ; check if we've reached a space
        JR Z, _space
        CP 0            ; check if we've reached end of line
        JR Z, _end
        INC IX
        JR _loop
_space:
        LD A, 0
        LD (IX+0), A
        INC IX
_end:
        PUSH IX
        POP HL
        POP IX
        RET
ENDP

