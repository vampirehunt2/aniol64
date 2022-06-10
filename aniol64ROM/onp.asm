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

BIN equ '%'
HEX equ '$'

ARITHMETIC_ERROR equ 1
SYNTAX_ERROR equ 2
 
SyntaxError: defb "Syntax error", 0
ArithmeticError: defb "Arithmetic error", 0

PROC
defb "onp_main"
onp_main:
		LD B, 0
		PUSH IX
		LD IX, Stack		
		CALL list_create	; creates a list that we will use as stack for the calculator
		POP IX
_loop:
		CALL str_tok
		PUSH HL
		CALL str_len
		CP 0
		JR Z, _end
		CALL onp_processToken
		POP IX
		JR _loop
_end:
		LD IX, Stack
		CALL list_len
		CP 1
		JR NZ, _syntaxErr
		CALL list_pull
		LD IX, Result
		CALL u16_formatDec
		CALL vga_writeLn
		RET
_syntaxErr:
		LD IX, SyntaxError
		CALL vga_writeLn
		RET
ENDP
		
PROC
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
		JP Z, _minus
		JP onp_processNumber
_minus:
		CALL str_len
		CP 1
		JP Z, onp_processOperator
		JP onp_processNumber
		RET
ENDP
		
PROC
onp_processNumber:
		LD A, (IX + 0) 	; load the first character of the token
		CP BIN
		JR Z, _parseBin
		CP HEX
		JR Z, _parseHex
		JR _parseDec
_parseBin:
		CALL u8_parseBin
		CP OK
		JP NZ, _error
		LD H, 0
		LD L, C
		JR _end
_parseHex:
		CALL u16_parseHex
		CP OK
		JP NZ, _error
		JR _end
_parseDec:
		CALL u16_parseDec
		CP OK
		JP NZ, _error
_end:
		CP 0
		JR NZ, _error
		LD IX, Stack
		CALL list_append
		LD A, OK		; fall through to return zero
_error:
		RET
ENDP

PROC
defb "onp_processOperator"	
onp_processOperator:
		LD A, (IX + 0) 	; load the first character of the token
		LD IX, Stack	; point IX to the stack
		CP PLUS
		JP Z, _plus
		CP DIVIDE
		JP Z, _divide
		CP MULTIPLY
		JP Z, _multiply
		CP MODULO
		JP Z, _mod
		CP MINUS
		JP Z, _minus
		CP NEGATE
		JP Z, _negate
_plus:
		CALL list_pull
		PUSH HL
		POP BC
		CALL list_pull
		CALL i16_add
		JR C, _error
		CALL list_append
		LD A, OK
		RET
_divide:
		CALL list_pull
		PUSH HL
		POP BC
		CALL list_pull
		CALL i16_div
		PUSH DE
		POP HL
		CALL list_append
		RET
_multiply:
		CALL list_pull
		PUSH HL
		POP BC
		CALL list_pull
		CALL i16_mul
		CALL list_append
		RET
_mod:
		CALL list_pull
		PUSH HL
		POP BC
		CALL list_pull
		CALL i16_div
		CALL list_append
		RET
_minus:
		CALL list_pull
		PUSH HL
		POP BC
		CALL list_pull
		CALL i16_sub
		CALL list_append
		RET
_negate:
		CALL list_pull
		PUSH HL
		CALL i16_neg
		CALL list_append
_error:
		LD A, ARITHMETIC_ERROR
		RET
ENDP
		
