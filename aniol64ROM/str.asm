;----------------------------------------------------
; Project: aniol64.zdsp
; File: str.asm
; Date: 8/26/2021 13:46:30
;
; Created with zDevStudio - Z80 Development Studio.
;
;----------------------------------------------------

; compares two null-terminated strings
; IX, IY: addresses of the strings to compare
; result in C: 0 if equal, 1 if different
str_cmp:
        LD A, (IX+0)
        LD B, (IY+0)
        CP B
        JR NZ, strCmpNeq
        CP 0
        JR Z, strCmpEq
        INC IX
        INC IY
        JP str_cmp
strCmpEq:
        LD C, 0
        RET
strCmpNeq:
        LD C, 1
        RET

; copies a null-terminated string
; IX: source string address
; IY: target address
str_copy:
        LD A, (IX+0)
        LD (IY+0), A
        CP 0
        RET Z
        INC IX
        INC IY
        JR str_copy

; finds the length of a null-terminated string
; IX: address of the string
; result in HL
PROC
str_len:
        LD HL, 0
_loop:
        LD A, (IX+0)
        CP 0
        RET Z
        INC HL
        INC IX
        JR _loop
ENDP


