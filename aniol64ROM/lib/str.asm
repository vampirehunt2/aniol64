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
; result in A: 0 if equal, 1 if different
; Z flag set if equal, reset if different
PROC
str_cmp:
		PUSH IX
		PUSH IY
_loop:
        LD A, (IX)
        LD B, (IY)
        CP B
        JR NZ, _neq
        CP 0
        JR Z, _eq
        INC IX
        INC IY
        JP _loop
_eq:
        LD A, 0
        JR _end
_neq:
        LD A, 1
        JR _end
_end:
		CP 0
		POP IY
		POP IX
		RET
ENDP

; compares a null-terminated string with a memory area, 
; ignoring the terminating zero
; IX: address of the memory buffer to compare to
; IY: address of the string to compare
; result in A: 0 if equal, 1 if different
; Z flag set if equal, reset if different
PROC
str_cmpMem:
		PUSH IX
		PUSH IY
_loop:
		LD A, (IY)
		CP 0
		JR Z, _eq
		CP (IX)
		JR NZ, _neq
		INC IX
		INC IY
		JR _loop
_eq:
        LD A, 0
        JR _end
_neq:
        LD A, 1
        JR _end
_end:
		CP 0
		POP IY
		POP IX
		RET
ENDP

; copies a null-terminated string
; IX: source string address
; IY: target address
PROC
str_copy:
		PUSH IX
		PUSH IY
_loop:
        LD A, (IX)
        LD (IY), A
        CP 0
        JR Z, _end
        INC IX
        INC IY
        JR _loop
_end:
		POP IY
		POP IX
		RET
ENDP

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

; shifts to the beginning of next token after calling str_tok
str_shift:
		PUSH HL
		POP IX
		RET


; converts an area of memory to a null-terminated string
; IX - memory area address
; IY - string address
; B - number of bytes (length of the string)
; result in IX
; destroys IY
PROC
str_2str:
		PUSH IY
_loop:
		LD A, (IX)
		LD (IY), A
		INC IX
		INC IY
		DJNZ _loop
		LD A, 0
		LD (IY), A
		POP IX
		RET
ENDP

PROC
str_2mem:
		PUSH IX
		PUSH IY
_loop:
		LD A, (IX)
		CP 0
		JR Z, _end
		LD (IY), A
		INC IX
		INC IY
		JR _loop
_end:
		POP IY
		POP IX
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

PROC
; concatenaes string pointed to by IX and IY
; result in IY
str_cat:
	PUSH IX
	PUSH IY
_start:
	LD A, (IX)
	CP 0
	JR Z, _cat
	INC IX
	JR _start
_cat:
	LD A, (IY)
	CP 0
	LD (IX), A
	JR Z, _end
	INC IX
	INC IY
	JR _cat
_end:
	LD (IX), A
	POP IY
	POP IX
	RET
ENDP
		
PROC
str_indexOf:
	PUSH IX
	LD B, 0
_loop:
	LD A, (IX)
	CP 0
	JR Z, _notFound
	CP C
	JR Z, _found
	INC B
	INC IX
	JR _loop
_found:
	LD A, TRUE
	JR _end
_notFound
	LD A, FALSE
_end:
	POP IX
	RET
ENDP

PROC
; returns Bth character of the string pointed to by IX
; result in A
str_charAt:
	PUSH IX
_loop:
	LD A, (IX)
	CP 0
	JR Z, _end
	DJNZ _loop
_end:
	POP IX
	RET
ENDP

PROC
; returns a substring of a string
; stops at the end of the source string 
; or C places after B, whichever is first
; IX - input string
; B - starting index
; C - length
; result in IY
str_sub:
	PUSH IX
_start:
	LD A, B
	CP 0
	JR Z, _sub
	DEC B
	INC IX
	JR _start
_sub:
	LD A, C
	CP 0
	JR Z, _end
	LD A, (IX)
	LD (IY), A
	CP 0
	JR Z, _end
	DEC C
	INC IX
	INC IY
_end:
	POP IX
	RET
ENDP

