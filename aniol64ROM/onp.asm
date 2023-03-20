; ONP (RPN) calculator

MAX_OPERANDS equ 20

Stack equ PROGRAM_DATA
Result equ PROGRAM_DATA + MAX_OPERANDS * 2 + 1 


PLUS equ '+'
MINUS equ '-'
DIVIDE equ '/'
MULTIPLY equ '*'
MODULO equ '\'
NEGATE equ '~'

BIN equ '!'
HEX equ '$'

ARITHMETIC_ERROR equ 1
SYNTAX_ERROR equ 2
 
SyntaxError: defb "Syntax error", 0
ArithmeticError: defb "Arithmetic error", 0


onp_main:
        CALL str_shift
		LD B, 0
		PUSH IX
		LD IX, Stack		
		CALL list_create	; creates a list that we will use as stack for the calculator
		POP IX
.loop:
		CALL str_tok
		PUSH HL
		CALL str_len
		CP 0
		JR Z, .end
		CALL onp_processToken
		POP IX
		JR .loop
.end:
		POP IX
		LD IX, Stack
		CALL list_len
		CP 1
		JR NZ, .syntaxErr
		CALL list_pull
		LD IX, Result
		CALL u16_formatDec
		CALL writeLn
		RET
.syntaxErr:
		LD IX, SyntaxError
		CALL writeLn
		RET

		

onp_processToken:
		LD A, (IX + 0)		; load the first character of the token
		CP PLUS
		JP Z, onp_processOperator
		CP DIVIDE
		JP Z, onp_processOperator
		CP MULTIPLY
		JP Z, onp_processOperator
		CP MODULO
		JP Z, onp_processOperator
		CP NEGATE
		JP Z, onp_processOperator
		CP MINUS
		JP Z, .minus
		JP onp_processNumber
.minus:
		CALL str_len
		CP 1
		JP Z, onp_processOperator
		JP onp_processNumber
		RET

		

onp_processNumber:
		LD A, (IX + 0) 	; load the first character of the token
		CP BIN
		JR Z, .parseBin
		CP HEX
		JR Z, .parseHex
		JR .parseDec
.parseBin:
		CALL u8_parseBin
		CP OK
		JP NZ, .error
		LD H, 0
		LD L, C
		JR .end
.parseHex:
		CALL u16_parseHex
		CP OK
		JP NZ, .error
		JR .end
.parseDec:
		CALL u16_parseDec
		CP OK
		JP NZ, .error
.end:
		CP 0
		JR NZ, .error
		LD IX, Stack
		CALL list_append
		LD A, OK		; fall through to return zero
.error:
		RET



 defb "onp_processOperator"	
onp_processOperator:
		LD A, (IX + 0) 	; load the first character of the token
		LD IX, Stack	; point IX to the stack
		CP PLUS
		JP Z, .plus
		CP DIVIDE
		JP Z, .divide
		CP MULTIPLY
		JP Z, .multiply
		CP MODULO
		JP Z, .mod
		CP MINUS
		JP Z, .minus
		CP NEGATE
		JP Z, .negate
.plus:
		CALL list_pull
		PUSH HL
		POP BC
		CALL list_pull
		CALL i16_add
		JR C, .error
		CALL list_append
		LD A, OK
		RET
.divide:
		CALL list_pull
		PUSH HL
		POP BC
		CALL list_pull
		CALL i16_div
		PUSH DE
		POP HL
		CALL list_append
		RET
.multiply:
		CALL list_pull
		PUSH HL
		POP BC
		CALL list_pull
		CALL i16_mul
		CALL list_append
		RET
.mod:
		CALL list_pull
		PUSH HL
		POP BC
		CALL list_pull
		CALL i16_div
		CALL list_append
		RET
.minus:
		CALL list_pull
		PUSH HL
		POP BC
		CALL list_pull
		CALL i16_sub
		CALL list_append
		RET
.negate:
		CALL list_pull
		PUSH HL
		CALL i16_neg
		CALL list_append
.error:
		LD A, ARITHMETIC_ERROR
		RET

		
