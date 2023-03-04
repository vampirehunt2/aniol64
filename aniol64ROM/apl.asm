; apl

SpecialChars: defb "+-*/\\:=[]<>&|!@^,;", 0

; operator tokens
ADD_T:			defb "+", 	0
SUB_T:			defb "-", 	0
MUL_T:			defb "*", 	0
DIV_T: 			defb "/", 	0
MOD_T: 			defb "\\", 	0
ASSIGN_T: 		defb ":", 	0
EQUAL_T:		defb "=", 	0
NOT_EQUAL_T:	defb "<>", 	0
QUOTE_T:		defb "'", 	0
LEFT_PAREN_T:	defb "(", 	0
RIGHT_PAREN_T: 	defb ")", 	0
LEFT_BRACKET_T:	defb "[", 	0
RIGHT_BRACKET_T:defb "]", 	0
GREATER_T: 		defb "<", 	0
LESSER_T: 		defb ">", 	0
GREATER_EQUAL_T:defb ">=", 	0
LESSER_EQUAL_T:	defb "<=", 	0
CONJUNCTION_T: 	defb "&", 	0
ALTERNATIVE_T: 	defb "|", 	0
NOT_T: 			defb "!", 	0
ADDR_T: 		defb "@", 	0
DEREFERENCE_T: 	defb "^", 	0
INDEX_T:		defb ".", 	0
SEPARATOR_T:	defb ",", 	0
TERMINATOR_T:	defb ";", 	0

; operator bytecodes
ADD_B			equ '+' 	
SUB_B			equ '-' 	
MUL_B			equ '*' 	
DIV_B 			equ '/' 	
MOD_B 			equ '\' 	
ASSIGN_B 		equ ':' 	
EQUAL_B			equ '=' 	
NOT_EQUAL_B		equ 'n' 	
QUOTE_B			equ '''' 	
LEFT_PAREN_B	equ '(' 	
RIGHT_PAREN_B 	equ ')' 	
LEFT_BRACKET_B	equ '[' 	
RIGHT_BRACKET_B	equ ']' 	
GREATER_B 		equ '<' 	
LESSER_B 		equ '>' 	
GREATER_EQUAL_B	equ 'g' 	
LESSER_EQUAL_B	equ 'l' 	
CONJUNCTION_B 	equ '&' 	
ALTERNATIVE_B 	equ '|' 	
NOT_B 			equ '!' 			
ADDR_B 			equ '@' 	
DEREFERENCE_B 	equ '^' 	
INDEX_B			equ '.' 
SEPARATOR_B		equ ','
TERMINATOR_B	equ ';'

; other bytecodes
VAR_B			equ 'v'
CALL_B			equ 'b'
SYSCALL_B		equ 's'
NUM_B			equ 'm'	
COMMENT_B		equ '#'
NL_B			equ 00h

; keyword tokens and their corresponding bytecodes
KeywordTokens:
PROG_T: 	defb "PROG", 	0, 'P'
.T: 	defb "PROC", 	0, 'p'
FUN_T:		defb "FUN", 	0, 'F'
END_T:		defb "END", 	0, 'D'
RET_T:		defb "RET", 	0, 'R'
IF_T: 		defb "IF", 		0, 'I'
ELSE_T:		defb "ELSE", 	0, 'E'
ENDIF_T:	defb "ENDIF", 	0, 'e'
WHILE_T:	defb "WHILE", 	0, 'W'
LOOP_T:		defb "LOOP", 	0, 'L'
FOR_T:		defb "FOR", 	0, 'f'
NEXT_T:		defb "NEXT", 	0, 'N'
ARRAY_T:	defb "ARR", 	0, 'A'
STRING_T:	defb "STR", 	0, 'S'	
 defb 0

; 128 variables with names of up to 8 characters, 
VARNAMES_SIZE equ 128 * 8

; bytecode types
; TODO

VarnamePtr	equ PROGRAM_DATA + 00h	; 2 byte pointer into the variable name table
ProgramPtr 	equ PROGRAM_DATA + 02h 	; 2 bytes
IsOperator	equ PROGRAM_DATA + 04h
Token 		equ PROGRAM_DATA + 08h	; 256 bytes for current token
Varnames 	equ PROGRAM_DATA + 108h	; need to be aligned to 8 byte boundary
Bytecodes 	equ PROGRAM_DATA + 108h + VARNAMES_SIZE




apl_main:
	LD A, FALSE
	LD (IsOperator), A
	CALL init_varnameTab
	LD HL, Bytecodes
	LD (ProgramPtr), HL
	CALL apl_tokenize
	RET



; fills the var names table with all zeroes
init_varnameTab:
	XOR A           ;LD A, 0
    LD HL, Varnames
    LD DE, Varnames + 1
    LD (HL), A   		
    LD BC, VARNAMES_SIZE  
    LDIR         
	RET


apl_getToken:
.loop:
	LD HL, Token
	CALL dos_fPeek
	LD B, A
	CALL apl_isWhitespace
	CP TRUE
	JR Z, .whitespace
	JR .next
.whitespace:
	CALL dos_fRead
	JR .loop
	; skipped whitespace
.next:
	CALL apl_isLetter
	CP TRUE
	JP Z, apl_tokenizeLiteral
	;
	CALL apl_isDecDigit
	CP TRUE
	JP Z, apl_tokenizeDec
	;
	LD A, B
	CP '-'
	JR Z, .checkNeg
	JR .cont
.checkNeg:
	LD A, (IsOperator)
	CP TRUE
	JR NZ, .cont
	JP Z, apl_tokenizeDec
.cont:	
	CALL apl_isSpecialChar
	CP TRUE
	JP Z, apl_tokenizeOperator
	;
	CALL apl_isBracket
	CP TRUE
	JP Z, apl_tokenizeBracket
	;
	LD A, B
	CP '$'
	JP Z, apl_tokenizeHex
	;
	LD A, B
	CP ''''
	JP Z, apl_tokenizeString
	;
	LD A, B
	CP '#'
	JP Z, apl_tokenizeComment
	RET



apl_tokenize:
.loop:
	CALL apl_getToken
	LD IX, Token
	LD IY, END_T
	CALL str_cmp
	CP 0
	JR NZ, .loop
	RET


apl_tokenizeLiteral:
	LD HL, Token
.loop:
	CALL dos_fPeek
	LD B, A
	CALL apl_isLetter
	CP TRUE
	JR Z, .next
	CALL apl_isDecDigit 
	CP TRUE
	JR Z, .next
	JR .end
.next:
	CALL dos_fRead
	LD (HL), A
	INC HL
	JR .loop
.end:
	LD (HL), 0
	INC HL
	CALL apl_processVar		; TODO add checking for keywords, constants, system calls, users calls
	LD A, FALSE
	LD (IsOperator), A
	RET


apl_tokenizeDec:
	LD HL, Token
	CALL dos_fPeek
	CP '-'
	JR Z, .neg
	JR .loop
.neg:
	CALL dos_fRead
	LD (HL), A
	INC HL
.loop:
	CALL dos_fPeek
	LD B, A
	CALL apl_isDecDigit 
	CP TRUE
	JR Z, .next
	JR .end
.next:
	CALL dos_fRead
	LD (HL), A
	INC HL
	JR .loop
.end:
	LD (HL), 0
	INC HL
	CALL apl_processDec
	LD A, FALSE
	LD (IsOperator), A
	RET



apl_processDec:
	LD IX, Token
	CALL i16_parseDec
	CALL apl_processNumber
	RET


apl_tokenizeHex:
	LD HL, Token
	CALL dos_fRead	; reading in the '$' symbol
	LD (HL), A
	INC HL
.loop:
	CALL dos_fPeek
	LD B, A
	CALL apl_isHexDigit 
	CP TRUE
	JR Z, .next
	JR .end
.next:
	CALL dos_fRead
	LD (HL), A
	INC HL
	JR .loop
.end:
	LD (HL), 0
	INC HL
	CALL apl_processHex
	LD A, FALSE
	LD (IsOperator), A
	RET



apl_processHex:
	LD IX, Token
	CALL u16_parseHex
	CALL apl_processNumber
	RET



apl_processNumber:
	LD A, NUM_B
	LD IX, (ProgramPtr)
	LD (IX), A
	INC IX
	LD A, L
	LD (IX), A
	INC IX
	LD A, H
	LD (IX), A
	INC IX
	LD (ProgramPtr), IX
	RET


apl_tokenizeBracket:
	LD HL, Token
	CALL dos_fRead
	LD (HL), A
	INC HL
	LD (HL), 0
	INC HL
	CALL apl_processBracket
	LD A, FALSE
	LD (IsOperator), A
	RET

apl_processBracket:
	LD HL, (ProgramPtr)
	LD (HL), A
	INC HL
	LD (ProgramPtr), HL
	RET

apl_tokenizeOperator:
	LD HL, Token
	CALL dos_fRead
	LD (HL), A
	INC HL
	CP '<'
	JR Z, .next
	CP '>'
	JR Z, .next
	JR .end
.next:
	CALL dos_fPeek
	CP '>'
	JR Z, .ld
	CP '='
	JR Z, .ld
	JR .end
.ld:
	CALL dos_fRead
	LD (HL), A
	INC HL
.end:
	LD (HL), 0
	INC HL
	CALL apl_processOperator
	LD A, TRUE
	LD (IsOperator), A
	RET



apl_processOperator:
	CALL apl_getOperatorCode
	LD HL, (ProgramPtr)
	LD (HL), A
	INC HL
	LD (ProgramPtr), HL
	RET



apl_processVar:
	CALL apl_getVarCode
	LD HL, (ProgramPtr)
	LD (HL), A
	INC HL
	LD (ProgramPtr), HL
	RET



apl_tokenizeComment:
	LD HL, Token
.loop:
	CALL dos_fRead
	CP 13
	JR Z, .end
	LD (HL), A
	INC HL
	JR .loop
.end:
	LD (HL), 0
	INC HL
	RET 



apl_tokenizeString
	LD HL, Token
	CALL dos_fRead	; read the opening quote
	LD (HL), A
	INC HL
.loop:
	CALL dos_fRead
	CP ''''
	JR Z, .end
	LD (HL), A
	INC HL
	JR .loop
.end:
	LD (HL), ''''
	INC HL
	LD (HL), 0
	INC HL
	RET 



apl_isLCaseLetter:
	LD A, B
	CP 'a'
	JR C, .no ; if less than '0' then it's not a hex digit
	CP 'z'
	JR Z, .yes
	JR C, .yes ; if less than ':' (which is the next ascii code after '9' then it's a hex digit
	JR .no
.yes
	LD A, TRUE
	RET
.no
	LD A, FALSE
	RET

	

apl_isUCaseLetter:
	LD A, B
	CP 'A'
	JR C, .no ; if less than '0' then it's not a hex digit
	CP 'Z'
	JR Z, .yes
	JR C, .yes ; if less than ':' (which is the next ascii code after '9' then it's a hex digit
	JR .no
.yes:
	LD A, TRUE
	RET
.no:
	LD A, FALSE
	RET

	

apl_isLetter:
	CALL apl_isLCaseLetter
	CP TRUE
	JR Z, .true
	CALL apl_isUCaseLetter
	CP TRUE
	JR Z, .true
	LD A, FALSE
	RET
.true:
	LD A, TRUE
	RET



apl_isSpecialChar:
	PUSH IX
	LD IX, SpecialChars
.loop:
	LD A, (IX)
	CP 0
	JR Z, .false
	CP B
	JR Z, .true
	INC IX
	JR .loop
.true:
	LD A, TRUE
	JR .end
.false:
	LD A, FALSE
.end:
	POP IX
	RET



apl_isWhitespace:
	LD A, B
	CP ' '
	JR Z, .true
	CP '\t' 	;TODO not recognized by sjasmplus
	JR Z, .true
	CP LF
	JR Z, .true
	LD A, FALSE
	RET
.true:
	LD A, TRUE
	RET



apl_isDecDigit:
	LD A, B
	CALL isDecDigit
	CP FALSE
	JR NZ, .true
	RET
.true:
	LD A, TRUE
	RET



apl_isHexDigit:
	LD A, B
	CALL isHexDigit
	CP FALSE
	JR NZ, .true
	RET
.true:
	LD A, TRUE
	RET



apl_isBracket:
	LD A, B
	CP '('
	JR Z, .true
	CP ')'
	JR Z, .true
	LD A, FALSE
	RET
.true:
	LD A, TRUE
	RET



; variable name is passed in the Token variable
; and is a null-terminated string
; characters past the 8th are silently ignored
; returns the index of the variable in the Varnames table
; adds the variable at the end of the table if not already present
; result in A
; destroys D, IX
apl_getVarCode:
	LD D, 0		; counting the variables within the varname table in D
	LD IX, Varnames
.loop:
	LD A, (IX)
	CP 0
	JR Z, .notFound
	CALL apl_varnameMatch
	CP TRUE
	JR Z, .found
	CALL apl_nextVar
	INC D
	JR .loop
.notFound:
	CALL apl_newVar
.found:
	LD A, D
	OR 10000000b
	RET



; checks whether variable names pointed to by IX and IY match.
; the variable name at IX has an 8-byte maximum lenght
; and it is null-terminated only if the length is less than 8
; destroys E, IY, A, B, IX
apl_varnameMatch:
	LD E, 0
	LD IY, Token
.loop:
	LD A, (IX)
	LD B, (IY)
	CP B
	JR NZ, .false
	CP 0
	JR Z, .true
	INC E
	LD A, 8
	CP E
	JR Z, .true
	INC IX
	INC IY
	JR .loop
.true:
	LD A, TRUE
	RET
.false:
	LD A, FALSE
	RET



; adds a new record to the Varnames table
; at the current IX position (assumes IX is at the end of the table)
; destroys A, E, IX, IY
apl_newVar:
	LD IY, Token
	LD E, 0
.loop:
	LD A, (IY)
	LD (IX), A
	CP 0
	RET Z
	INC E
	LD A, 8
	CP E
	RET Z
	INC IX
	INC IY
	JR .loop



; moves IX to the begginign of the next record
; in the Varnames table
; assumes Varnames is aligned at 8 byte boundary
; destroys A, HL, BC
apl_nextVar:
	PUSH IX
	POP HL
	LD A, L
	AND 11111000b
	LD L, A
	LD B, 0
	LD C, 8
	ADD HL, BC
	PUSH HL
	POP IX
	RET	



; token in Token
apl_getOperatorCode:
	LD IY, Token
	LD A, (IY + 1)	; checking if it's an operator with length of 1
	CP 0
	JR Z, .one
	LD IX, NOT_EQUAL_T
	CALL str_cmp
	CP 0
	JR Z, .neq
	LD IX, GREATER_EQUAL_T
	CALL str_cmp
	CP 0
	JR Z, .ge
	LD IX, LESSER_EQUAL_T
	CALL str_cmp
	CP 0
	JR Z, .le
	LD A, 0		; not a known operator
	RET
.neq:
	LD A, NOT_EQUAL_B
	RET
.ge:
	LD A, GREATER_EQUAL_B
	RET
.le:
	LD A, LESSER_EQUAL_B
	RET
.one:
	LD A, (IY)
	RET



; returns the bytecode corresponding to the keyword
; passed in IY, or zero if it's not a keyword
; result in A
apl_getKeywordCode:
	PUSH IX
	PUSH BC
	LD IX, KeywordTokens
.loop:
	CALL str_len	; check the length of the keyword token
	CP 0			; the keyword token table ends with an empty string
	JR Z, .end		; so if we find a zero-length token it means we've reached the end
	CALL apl_keywordCmp
	CP 0
	JR NZ, .end
	JR .loop
.end:
	POP BC
	POP IX
	RET			; just return the zero that's already in A



; destroys BC
apl_keywordCmp:
	PUSH IY
	LD C, TRUE
.loop:
	LD A, (IX)
	LD B, (IY)
	CP B
	JR Z, .next
	LD C, FALSE
.next:
	CP 0
	JR Z, .end
	INC IX
	INC IY
	JR .loop
.end:
	INC IX
	INC IX
	LD A, C
	POP IY
	CP FALSE
	RET Z
	LD A, (IX - 1)
	RET





