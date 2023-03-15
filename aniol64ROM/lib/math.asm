;----------------------------------------------------
; Project: math.zdsp
; File: math.asm
; Date: 4/22/2022 8:06:22
;
; Created with zDevStudio - Z80 Development Studio.
;
;----------------------------------------------------
 
EQUAL equ 0
GREATER equ 1
SMALLER equ 0FFh
SIGN equ 10000000b
ABS equ 01111111b
DIVBY0 equ 1
OVERFLOW equ 2
FORMATERR equ 3
OK equ 0

; adds to 16 bit integers
; arguments in HL nd BC
; result in HL
u16_add:
i16_add:
		AND A		; clear carry
        ADD HL, BC
        RET

; subtracts two 16 bit integers
; subtracts BC from HL
; result in HL
u16_sub:
i16_sub:
        AND A   ; clear carry
        LD A, L
        SUB C
        LD L, A
        LD A, H
        SBC A, B
        LD H, A
        RET

; performs logical AND on two 16-bit integers
; arguments in HL nd BC
; result in HL
u16_and:
i16_and:
        LD A, H
        AND B
        LD H, A
        LD A, L
        AND C
        LD L, A
        RET

; performs logical OR on two 16-bit integers
; arguments in HL nd BC
; result in HL
u16_or:
i16_or:
        LD A, H
        OR B
        LD H, A
        LD A, L
        OR C
        LD L, A
        RET

; performs logical XOR on two 16-bit integers
; arguments in HL nd BC
; result in HL
i16_xor:
        LD A, H
        XOR B
        LD H, A
        LD A, L
        XOR C
        LD L, A
        RET

; compares two unsigned 16 bit integers
; arguments in HL and BC
; result in A
; returns 0 if they are equal
; 1 if HL is greater
; -1 (FF) if HL is smaller

u16_cmp:
        LD A, H
        CP B
        JR NZ, .notEqual
        LD A, L
        CP C
        JR NZ, .notEqual
        LD A, EQUAL
        RET
.notEqual:
        LD A, H
        CP B
        JR C, .smaller
        JR NZ, .greater
        LD A, L
        CP C
        JR C, .smaller
        JR .greater
.smaller:
        LD A, SMALLER
        RET
.greater:
        LD A, GREATER
        RET


; returns the absolute value of a signed 16-bit integer
; argument in HL
; result in HL
i16_abs:
        LD A, H
        AND SIGN
        CP 0
        RET Z
        CALL i16_neg
        RET
		
i8_abs:
		AND SIGN
		CP 0
		RET Z
		NEG
		RET

; returns the negative value of a signed 16-bit integer
; argument in HL
; result in HL
i16_neg:
        CALL i16_not
        INC HL
        RET

; returns the logical negation of a 16-bit value
; argument in HL
; result in HL
i16_not:
        LD A, H    ; inverting all the bits
        XOR 0FFh
        LD H, A
        LD A, L
        XOR 0FFh
        LD L, A
        LD A, H
        RET

; compares two signed 16 bit integers
; arguments in HL and BC
; result in A
; returns 0 if they are equal
; 1 if HL is greater
; -1 (FF) if HL is smaller

i16_cmp:
        PUSH DE
        LD A, H
        CP B
        JR NZ, .notEqual
        LD A, L
        CP C
        JR NZ, .notEqual
.equal:
        LD A, EQUAL
        JR .end
.notEqual:
        LD A, B
        AND SIGN
        LD D, A    ; storing the sign oh BC in D
        LD A, H
        AND SIGN
        CP D
        JR Z, .sameSign
        JR C, .greater
        JR .smaller
.greater:
        LD A, GREATER
        JR .end
.smaller:
        LD A, SMALLER
        JR .end
.sameSign:
        CALL u16_cmp
        CP EQUAL
        JR Z, .equal
        LD E, A    ; save the comparison result
        LD A, D   ; get the stored sign of BC
        CP SIGN
        JR Z, .invert
        LD A, E
        JR .end
.invert:
        LD A, E  ; load the comparison result into A
        CP GREATER
        JR Z, .invertGreater
        LD A, GREATER
        JR .end
.invertGreater:
        LD A, SMALLER
        JR .end
.end:
        POP DE
        RET


; divides two unsigned 16-bit integers
; arguments in HL and BC
; division result in DE
; mod result in HL
; errors reported in A

u16_div:
        LD A, B    ; checking if it's not a division by zero
        CP 0
        JR NZ, .proceed
        LD A, C
        CP 0
        JR NZ, .proceed
        LD A, DIVBY0
        RET
.proceed:
        LD D, 0
        LD E, 0
.loop:
        CALL u16_cmp
        CP SMALLER
        JR Z, .end
        AND A   ; clear carry
        CALL u16_sub
        INC E
        LD A, E
        CP 0
        JR NZ, .loop
        INC D
        JR .loop
.end:
        LD A, OK
        RET


; calculates the sign of multiplication or division result
; operands in HL and BC
; result in A
; zero if positive or 0, non-zero vaue if negative
i16_mulSign:
        PUSH DE
        LD A, H       ; calculate the sign of the result
        AND SIGN
        LD D, A
        LD A, B
        AND SIGN
        XOR D
        POP DE
        RET

; converts signed intenegers in HL and BC to their absolute values

i16_operands2abs:
        PUSH HL       ; converting both operands to their absolute values
        LD H, B
        LD L, C
        CALL i16_abs
        LD B, H
        LD C, L
        POP HL
        CALL i16_abs ; both operands now have their absolute values
        RET


; divides two signed 16-bit integers
; arguments in HL and BC
; division result in DE
; mod result in HL
; errors reported in A

i16_div:
        PUSH BC
        CALL i16_mulSign
        PUSH AF       ; storing the sign of the result on stack
        CALL i16_operands2abs
        CALL u16_div ; dividing two positive values
        CP 0
        JR NZ, .divBy0
        POP AF       ; restoring the sign of the result in A
        CP 0
        JR Z, .end
        PUSH HL
        LD H, D
        LD L, E
        CALL i16_neg
        LD D, H
        LD E, L
        POP HL
.end:
        POP BC
        RET
.divBy0:
        POP BC
        LD A, DIVBY0
        RET


; checks if a 16-bit integer is zero
; argument in DE
; result in A

i16_is0:
        LD A, D
        CP 0
        JR NZ, .false
        LD A, E
        CP 0
        JR NZ, .false
        LD A, TRUE
        JR .end
.false:
        LD A, FALSE
.end:
        RET


; multiplies two unsigned 16-bit integers
; arguments in HL and BC
; result in HL
; errors reported in A
u16_mul:
        PUSH DE        ; store register state on stack
        LD D, H        ; transfer HL to DE
        LD E, L
        LD HL, 0
.loop:
        CALL i16_is0
        CP TRUE
        JR Z, .correct
        AND A           ; clear carry
        ADD HL, BC      ; accumulate values into HL
        JR C, .overflow
        DEC DE          ; use DE as loop counter
        JR .loop
.overflow:
        LD A, OVERFLOW
        JR .end
.correct:
        LD A, OK
        JR .end
.end:
        POP DE         ; restore register state
        RET


; multiplies two signed 16-bit integers
; operands in HL and BC
; result in B
; overflow reported in A (TODO: doesn't work)

i16_mul:
        CALL i16_mulSign
        PUSH AF       ; storing the sign of the result on stack
        CALL i16_operands2abs
        CALL u16_mul ; multiply two positive values
        CP OK
        JR NZ, .overflow
        POP AF       ; restoring the sign of the result in A
        CP 0
        JR Z, .correct
        CALL i16_neg
        JR .correct
.overflow:
        LD A, OVERFLOW
        JR .end
.correct:
        LD A, OK
        JR .end
.end:
        RET


; multiplies two unsigned 8 bit integers
; arguments in B and C
; result in HL

u8_mul:
        LD HL, 0
		LD A, B
		OR A
		RET Z
		LD D, 0
		LD E, C
.loop:
        ADD HL, DE
		DJNZ .loop
		RET



; divides A by B
; result in C
; rest in A
u8_div:
		LD C, 0
.loop:
		CP B
		JR C, .end
		SUB B
		INC C
		JP .loop
.end:
		RET



i16_parseDec:
	LD A, (IX)
	CP '-'		; check for leading minus
	JR NZ, .pos
	INC IX		; move past the minus sign
	CALL u16_parseDec ; parse the absolute value of the number
	CALL i16_neg
	RET
.pos:
	CALL u16_parseDec  
    RET



u16_parseHex:
		LD A, (IX)
        CP '$'         ; check if the string starts with $ indicating it's a hex number
        JR NZ, .parseError
        INC IX
		CALL parseDByte
		RET
.parseError:
		LD A, FORMATERR
        RET



u16_parseBin:
		CALL u8_parseBin
		LD L, C
		LD H, 0  
        RET


; parses a 16-bit unsigned number
; leading zeroes are not mandatory
; string to parse is pointed to by IX
; result in HL
; errors reported in A
; in case of errors, address of first erroneous character is in IX
; destroys IX

u16_parseDec:
        PUSH BC
        LD HL, 0   ; will be accumulating the value in HL
.loop:
        LD A, (IX)
        SUB '0'  ; converts '0'-'9' to 0-9
        CP 10   ; check if we read a decimal digit
        JR NC, .parseError
        LD C, A
        LD B, 0
        ADD HL, BC
        INC IX
        LD A, (IX)
        CP 0    ; check if we've reached end of string
        JR Z, .end
        LD BC, 10
        CALL u16_mul
        CP OK
        JR NZ, .overflow
        JR .loop
.parseError:
        LD A, FORMATERR
        JR .end
.overflow:
        LD A, OVERFLOW
.end:
        POP BC
        RET


; formats a 16-bit unsigned number as string
; result is a null-terminated string with leading zeroes
; argument in HL
; result in a string pointed to by IX
; conserves both HL and IX

u16_formatDec:
        PUSH BC
        PUSH HL
        PUSH IX
        LD BC, 10000    ; divider stored in BC, numbers of up to 5 decimal digits are supported
.loop:
        CALL u16_div    ; divide the number by divider to get the current digit
        LD A, E         ; load the division result to A
        AND A           ; clear carry
        ADD A, '0'      ; convert digit to its ASCII representation
        LD (IX), A      ; store ASCII digit to the result string
        INC IX          ; move to the next digit
        PUSH HL
        LD H, B
        LD L, C
        LD BC, 10
        CALL u16_div   ; divide the divider by 10
        LD B, D
        LD C, E
        POP HL
        CALL i16_is0   ; check if divider is zero
        CP FALSE       ; if not, perform another loop
        JR Z, .loop
        LD (IX), 0     ; store end of line
        POP IX
        POP HL
        POP BC
        RET



i16_formatDec:
	LD A, H
	AND 10000000b	; isolate the sign of the number
	CP 0
	JR Z, .pos
	LD A, H
	AND 011111111b	; isolate the absolute value of the number
	LD H, A
	LD A, '-'
	LD (IX), A
	INC IX
.pos:
	CALL u16_formatDec
	RET



u16_formatHex:
		LD (IX), '$'
		LD A, H
		CALL byte2asc
		LD (IX + 2), A
		LD A, B
		LD (IX + 1), A
		LD A, L
		CALL byte2asc
		LD (IX + 4), A
		LD A, B
		LD (IX + 3), A
		LD A, 0
		LD (IX + 5), A
        RET


; parses an 8-bit unsigned binary number from a null-terminated string
; string format is !xxxxxxxx\0 where x is either '1' or '0'
; leading zeroes are mandatory
; in case of error a non-zero error code is in A
; and the address of the first erroneous character is IX
; in case of success a 0 is in A and result is in C
; destroys B

u8_parseBin:
        LD A, (IX)
        CP '!'         ; check if the string starts with ! indicating it's a binary number
        JR NZ, .parseError
        INC IX
        LD B, 8         ; initialise the loop
        LD C, 0
.loop:
        SLA C
        LD A, (IX)
        SUB '0'         ; converting "0" and "1" to 0 and 1, respectively
        CP 2            ; check if the character is a binary digit
        JR NC, .parseError
        OR C
        LD C, A
        INC IX
        DJNZ .loop
        LD A, (IX)
        CP 0            ; check for end of string
        JR NZ, .parseError
        LD A, OK
        JR .end
.parseError:
        LD A, FORMATERR
.end:
        RET


; converts an 8-bit unsigned number to its string representation
; number passed in A
; result in a null-terminated string pointed to by IX

u8_formatBin:
        PUSH AF
        PUSH BC
        LD C, A
        LD (IX), '!'
        INC IX
        LD B, 8
.loop:
        LD A, C
        AND 10000000b
        CP 0
        JR Z, .zero
        LD (IX), '1'
        JR .endLoop
.zero:
        LD (IX), '0'
.endLoop:
        INC IX
        SLA C
        DJNZ .loop
        LD (IX), 0
        POP BC
        POP AF
        RET


u8_min:
		CP B
		RET C
		LD A, B
		RET

u8_max:
		CP B
		RET NC
		LD A, B
		RET

; trims leading zeroes from a formatted number
; and replaces them with spaces for text adjustems
; number in a string pointed to by IX

trimLeading0s:
        PUSH AF
        PUSH IX
.loop:
        LD A, (IX)
        CP '0'
        JR NZ, .end
        LD (IX), ' '
        INC IX
        JR .loop
.end:
        POP IX
        POP AF


; converts a 16-bit unsigned number to its string representation
; number passed in HL
; result in a null-terminated string pointed to by IX

u16_formatBin:
        LD A, H
        CALL u8_formatBin
        LD A, L
        CALL u8_formatBin
        LD (IX - 9), '-'     ; put a divider between higher and lower byte to enhance readability
        RET

