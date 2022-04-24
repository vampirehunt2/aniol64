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
TRUE equ 0ffh
FALSE equ 0

; adds to 16 bit integers
; arguments in HL nd BC
; result in HL
u16_add:
i16_add:
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
PROC
u16_cmp:
        LD A, H
        CP B
        JR NZ, _notEqual
        LD A, L
        CP C
        JR NZ, _notEqual
        LD A, EQUAL
        RET
_notEqual:
        LD A, H
        CP B
        JR C, _smaller
        JR NZ, _greater
        LD A, L
        CP C
        JR C, _smaller
        JR _greater
_smaller:
        LD A, SMALLER
        RET
_greater:
        LD A, GREATER
        RET
ENDP

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
PROC
i16_cmp:
        PUSH DE
        LD A, H
        CP B
        JR NZ, _notEqual
        LD A, L
        CP C
        JR NZ, _notEqual
_equal:
        LD A, EQUAL
        JR _end
_notEqual:
        LD A, B
        AND SIGN
        LD D, A    ; storing the sign oh BC in D
        LD A, H
        AND SIGN
        CP D
        JR Z, _sameSign
        JR C, _greater
        JR _smaller
_greater:
        LD A, GREATER
        JR _end
_smaller:
        LD A, SMALLER
        JR _end
_sameSign:
        CALL u16_cmp
        CP EQUAL
        JR Z, _equal
        LD E, A    ; save the comparison result
        LD A, D   ; get the stored sign of BC
        CP SIGN
        JR Z, _invert
        LD A, E
        JR _end
_invert:
        LD A, E  ; load the comparison result into A
        CP GREATER
        JR Z, _invertGreater
        LD A, GREATER
        JR _end
_invertGreater:
        LD A, SMALLER
        JR _end
_end:
        POP DE
        RET
ENDP

; divides two unsigned 16-bit integers
; arguments in HL and BC
; division result in DE
; mod result in HL
; errors reported in A
PROC
u16_div:
        LD A, B    ; checking if it's not a division by zero
        CP 0
        JR NZ, _proceed
        LD A, C
        CP 0
        JR NZ, _proceed
        LD A, DIVBY0
        RET
_proceed:
        LD D, 0
        LD E, 0
_loop:
        CALL u16_cmp
        CP SMALLER
        JR Z, _end
        AND A   ; clear carry
        CALL u16_sub
        INC E
        LD A, E
        CP 0
        JR NZ, _loop
        INC D
        JR _loop
_end:
        LD A, OK
        RET
ENDP

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
PROC
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
ENDP


; divides two signed 16-bit integers
; arguments in HL and BC
; division result in DE
; mod result in HL
; errors reported in A
PROC
defb "i16_div"
i16_div:
        PUSH BC
        CALL i16_mulSign
        PUSH AF       ; storing the sign of the result on stack
        CALL i16_operands2abs
        CALL u16_div ; dividing two positive values
        CP 0
        JR NZ, _divBy0
        POP AF       ; restoring the sign of the result in A
        CP 0
        JR Z, _end
        PUSH HL
        LD H, D
        LD L, E
        CALL i16_neg
        LD D, H
        LD E, L
        POP HL
_end:
        POP BC
        RET
_divBy0:
        POP BC
        LD A, DIVBY0
        RET
ENDP

PROC
i16_is0:
        LD A, D
        CP 0
        JR NZ, _false
        LD A, E
        CP 0
        JR NZ, _false
        LD A, TRUE
        JR _end
_false:
        LD A, FALSE
_end:
        RET
ENDP

; multiplies two unsigned 16-bit integers
; arguments in HL and BC
; division result in DE
; mod result in HL
; errors reported in A
PROC
defb "u16_mul"
u16_mul:
        PUSH DE        ; store register state on stack
        LD D, H        ; transfer HL to DE
        LD E, L
        LD HL, 0
_loop:
        CALL i16_is0
        CP TRUE
        JR Z, _correct
        AND A           ; clear carry
        ADD HL, BC      ; accumulate values into HL
        JR C, _overflow
        DEC DE          ; use DE as loop counter
        JR _loop
_overflow:
        LD A, OVERFLOW
        JR _end
_correct:
        LD A, 0
        JR _end
_end:
        POP DE         ; restore register state
        RET
ENDP

PROC
defb "i16_mul"
i16_mul:
        CALL i16_mulSign
        PUSH AF       ; storing the sign of the result on stack
        CALL i16_operands2abs
        CALL u16_mul ; multiply two positive values
        CP OK
        JR NZ, _overflow
        POP AF       ; restoring the sign of the result in A
        CP 0
        JR Z, _correct
        CALL i16_neg
        JR _correct
_overflow:
        LD A, OVERFLOW
        JR _end
_correct:
        LD A, OK
        JR _end
_end:
        RET
ENDP

; multiplies two unsigned 8 bit integers
; arguments in B and C
; result in HL
PROC
u8_mul:
        LD HL, 0
	LD A, B
	OR A
	RET Z
	LD D, 0
	LD E, C
_loop:
        ADD HL, DE
	DJNZ _loop
	RET
ENDP

PROC
i16_parseDec:
        RET
ENDP

PROC
u16_parseHex:
        RET
ENDP

PROC
u16_parseBin:
        RET
ENDP

PROC
defb "u16_parseDec"
u16_parseDec:
        LD HL, 0   ; will be accumulating the value in HL
_loop:
        LD A, (IX)
        SUB '0'  ; converts '0'-'9' to 0-9
        CP 10   ; check if we read a decimal digit
        JR NC, _parseError
        LD C, A
        LD B, 0
        ADD HL, BC
        INC IX
        LD A, (IX)
        CP 0    ; check if we've reached end of string
        JR Z, _end
        LD B, 0
        LD C, 10
        CALL u16_mul
        JR _loop
_parseError:
        LD A, FORMATERR
_end:
        RET
ENDP

PROC
i16_formatDec:
        RET
ENDP

PROC
u16_formatHex:
        RET
ENDP

; parses an 8-bit unsigned binary number from a null-terminated string
; string format is !xxxxxxxx\0 where x is either '1' or '0'
; leading zeroes are mandatory
; in case of error a non-zero error code is in A
; and the address of the first erroneous character is IX
; in case of success a 0 is in A and result is in C
; destroys B
PROC
u8_parseBin:
        LD A, (IX)
        CP '!'         ; check if the string starts with ! indicating it's a binary number
        JR NZ, _parseError
        INC IX
        LD B, 8         ; initialise the loop
        LD C, 0
_loop:
        SLA C
        LD A, (IX)
        SUB '0'         ; converting "0" and "1" to 0 and 1, respectively
        CP 2            ; check if the character is a binary digit
        JR NC, _parseError
        OR C
        LD C, A
        INC IX
        DJNZ _loop
        LD A, (IX)
        CP 0            ; check for end of string
        JR NZ, _parseError
        LD A, OK
        JR _end
_parseError:
        LD A, FORMATERR
_end:
        RET
ENDP

PROC
u8_formatBin:
        PUSH AF
        PUSH BC
        LD C, A
        LD (IX), '!'
        INC IX
        LD B, 8
_loop:
        LD A, C
        AND 10000000b
        CP 0
        JR Z, _zero
        LD (IX), '1'
        JR _endLoop
_zero:
        LD (IX), '0'
_endLoop:
        INC IX
        SLA C
        DJNZ _loop
        LD (IX), 0
        POP BC
        POP AF
        RET
ENDP

PROC
defb "u16_formatBin"
u16_formatBin:
        LD A, H
        CALL u8_formatBin
        LD A, L
        CALL u8_formatBin
        LD (IX - 9), '-'
        RET
ENDP
