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

str_cmp:
		PUSH IX
		PUSH IY
.loop:
        LD A, (IX)
        LD B, (IY)
        CP B
        JR NZ, .neq
        CP 0
        JR Z, .eq
        INC IX
        INC IY
        JP .loop
.eq:
        LD A, 0
        JR .end
.neq:
        LD A, 1
        JR .end
.end:
		CP 0
		POP IY
		POP IX
		RET


; compares a null-terminated string with a memory area, 
; ignoring the terminating zero
; IX: address of the memory buffer to compare to
; IY: address of the string to compare
; result in A: 0 if equal, 1 if different
; Z flag set if equal, reset if different

str_cmpMem:
		PUSH IX
		PUSH IY
.loop:
		LD A, (IY)
		CP 0
		JR Z, .eq
		CP (IX)
		JR NZ, .neq
		INC IX
		INC IY
		JR .loop
.eq:
        LD A, 0
        JR .end
.neq:
        LD A, 1
        JR .end
.end:
		CP 0
		POP IY
		POP IX
		RET


; copies a null-terminated string
; IX: source string address
; IY: target address
str_copy:
	PUSH IX
	PUSH IY
.loop:
    LD A, (IX)
    LD (IY), A
    CP 0
    JR Z, .end
    INC IX
    INC IY
    JR .loop
.end:
	POP IY
	POP IX
	RET

; copies a number of characters of a null-terminated string
; IX: source string address
; IY: target address
; B: maximum number of characters to copy
str_ncpy:
	PUSH IX		; store register values
	PUSH IY
.loop:
	LD A, (IX)	; load a character from the source string
	CP 0		; check if end of source string reached
	JR Z, .end	; if yes, store the terminating zero in the target string
	LD (IY), A	; if not, load the character into the target string
	INC IX		; increment both string indices
	INC IY
	DJNZ .loop	; if B charcters not copied yet, copy another charatcter
	LD A, 0		; if B characters copied, load the terminting zero
.end:
	LD (IY), A	; store the terminating zero in the target string
	POP IY		; restore register values
	POP IX 
	RET



; finds the length of a null-terminated string
; only supports strings up to 255 characters
; IX: address of the string
; result in A
str_len:
        LD B, 0
        PUSH IX
.loop:
        LD A, (IX+0)
        CP 0
        JR Z, .eos
        INC B
        INC IX
        JR .loop
.eos:
        LD A, B
        POP IX
        RET


; returns the first token of a string
; and modifies the input string to cut out the token
; IX: address of the string
; result in IX
; rest of string in HL
str_tok:
        PUSH IX
.loop:
        LD A, (IX+0)
        CP 20h          ; check if we've reached a space
        JR Z, .space
        CP 0            ; check if we've reached end of line
        JR Z, .end
        INC IX
        JR .loop
.space:
        LD A, 0
        LD (IX+0), A
        INC IX
.end:
        PUSH IX
        POP HL
        POP IX
        RET


; reutrns a substring of a string
; IX - input string
; B - start index
; C - maximum length of the substring
; result in IX
str_sub:
	LD A, B
.loop:			; this loop skips the first B characters of the input string
	CP 0
	JR Z, .cont
	LD D, A		; save loop counter in D
	LD A, (IX)	; check the character at the current string pointer
	CP 0		; if it's a null character, we've reached the end of the input string
	RET Z		; so we return an empty string immediately
	INC IX
	LD A, D		; restore loop counter
	DEC A
	JR .loop
.cont:
	PUSH IX
	LD A, C
.loop1:			; this loop iterates through the first C characters of the substring
	CP 0		
	JR Z, .end
	LD D, A		; save loop counter in D
	LD A, (IX)	; check the character at the current string pointer
	CP 0		; if it's a null character, we've reached the end of the input string
	JR Z, .end	; so we return immediately
	INC IX
	LD A, D		; restore loop counter
	DEC A
	JR .loop1
.end:
	LD (IX), A
	POP IX
	RET

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
str_2str:
		PUSH IY
.loop:
		LD A, (IX)
		LD (IY), A
		INC IX
		INC IY
		DJNZ .loop
		LD A, 0
		LD (IY), A
		POP IX
		RET



str_2mem:
	PUSH IX
	PUSH IY
.loop:
	LD A, (IX)
	CP 0
	JR Z, .end
	LD (IY), A
	INC IX
	INC IY
	JR .loop
.end:
	POP IY
	POP IX
	RET

; skips leading spaces in a string
; IX - string to trim
; result in IX
str_ltrim:
    LD A, (IX+0)
	CP 20h
    JR Z, .loop
    RET
.loop:
    INC IX
    JR str_ltrim



str_rtrim:
	PUSH IX
.loop:
	LD A, (IX)
	CP 0
	INC IX
	JR NZ, .loop
	DEC IX
.loop1:
	DEC IX
	LD A, (IX)
	CP ' '
	JR Z, .loop1
	LD A, 0
	LD (IX + 1), A
	POP IX
	RET



; concatenaes string pointed to by IX and IY
; result in IY
str_cat:
	PUSH IX
	PUSH IY
.start:
	LD A, (IX)
	CP 0
	JR Z, .cat
	INC IX
	JR .start
.cat:
	LD A, (IY)
	CP 0
	LD (IX), A
	JR Z, .end
	INC IX
	INC IY
	JR .cat
.end:
	LD (IX), A
	POP IY
	POP IX
	RET

		

str_indexOf:
	PUSH IX
	LD B, 0
.loop:
	LD A, (IX)
	CP 0
	JR Z, .notFound
	CP C
	JR Z, .found
	INC B
	INC IX
	JR .loop
.found:
	LD A, TRUE
	JR .end
.notFound
	LD A, FALSE
.end:
	POP IX
	RET



; returns Bth character of the string pointed to by IX
; result in A
str_charAt:
	PUSH IX
.loop:
	LD A, (IX)
	CP 0
	JR Z, .end
	DJNZ .loop
.end:
	POP IX
	RET



str_toUpper:
	PUSH IX
	PUSH BC
.loop:
	LD A, (IX)
	CP 0
	JR Z, .end
	LD B, A
	CALL isLowercaseLetter
	CP FALSE
	JR Z, .next
	LD A, B
	SUB 32	; convert to uppercase
	LD (IX), A
.next:
	INC IX
	JR .loop
.end:
	POP BC
	POP IX
	RET



str_toLower:
	PUSH IX
	PUSH BC
.loop:
	LD A, (IX)
	CP 0
	JR Z, .end
	LD B, A
	CALL isUppercaseLetter
	CP FALSE
	JR Z, .next
	LD A, B
	ADD A, 32	; convert to lowercase
	LD (IX), A
.next:
	INC IX
	JR .loop
.end:
	POP BC
	POP IX
	RET



; checks if the string pointed to by IX 
; starts with the string pointed to by IY
; result in A
str_startsWith:
	PUSH IX
	PUSH IY
	PUSH BC
.loop:
	LD A, (IY)
	CP 0
	JR Z, .true
	LD B, (IX)
	CP B
	JR NZ, .false
	INC IX
	INC IY
	JR .loop
.false:
	LD A, FALSE
	JR .end
.true:
	LD A, TRUE
.end:
	POP BC
	POP IY
	POP IX
	RET


