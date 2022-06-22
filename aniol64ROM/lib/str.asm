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
        LD A, (IX)
        LD B, (IY)
        CP B
        JR NZ, strCmpNeq
        CP 0
        JR Z, strCmpEq
        INC IX
        INC IY
        JP str_cmp
strCmpEq:
        LD A, 0
        RET
strCmpNeq:
        LD A, 1
        RET

; copies a null-terminated string
; IX: source string address
; IY: target address
str_copy:
        LD A, (IX)
        LD (IY), A
        CP 0
        RET Z
        INC IX
        INC IY
        JR str_copy

; finds the length of a null-terminated string
; only supports strings up to 255 characters
; IX: address of the string
; result in A
PROC
str_len:
        LD B, 0
        PUSH IX
_loop:
        LD A, (IX+0)
        CP 0
        JR Z, _eos
        INC B
        INC IX
        JR _loop
_eos:
        LD A, B
        POP IX
        RET
ENDP

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


; converts an area of memory to a null-terminated string
; IX - memory area address
; IY - string address
; B - number of bytes (length of the string)
PROC
str_2str:
		PUSH IX
		PUSH IY
_loop:
		LD A, (IX)
		LD (IY), A
		INC IX
		INC IY
		DJNZ _loop
		LD A, 0
		LD (IY), A
		POP IY
		POP IX
		RET
ENDP

; skips leading spaces in a string
; IX - string to trim
; result in IX
PROC
str_ltrim:
        LD A, (IX+0)
        CP 20h
        JR Z, _loop
        RET
_loop:
        INC IX
        JR str_ltrim
ENDP

PROC
str_rtrim:
		PUSH IX
_loop:
		LD A, (IX)
		INC IX
		CP 0
		JR NZ, _loop
_loop1:
		LD A, (IX)
		CP ' '
		DEC IX
		JR Z, _loop1
		LD A, 0
		LD (IX + 1), A
		POP IX
		RET
ENDP

str_cat:
		RET
		
str_contains:
		RET
		
str_indexOf:
		RET

str_sub:
		RET



