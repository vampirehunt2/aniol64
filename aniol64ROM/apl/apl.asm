; apl tokenizer

SpecialChars: defb ".~+-*/\\:=[]()<>{}#&|!@^,;\n\r", 0


;
;	# 	string index
;	{}	also string index
;	%	comment
;	;	same as ENDIF
;


; operator tokens
ADD_T:			defb "+", 	0
SUB_T:			defb "-", 	0
MUL_T:			defb "*", 	0
DIV_T: 			defb "/", 	0
MOD_T: 			defb "\\", 	0
EQUAL_T:		defb "=", 	0
NOT_EQUAL_T:	defb "<>", 	0
QUOTE_T:		defb "\"", 	0
LEFT_PAREN_T:	defb "(", 	0
RIGHT_PAREN_T: 	defb ")", 	0
LEFT_BRACKET_T:	defb "[", 	0
RIGHT_BRACKET_T:defb "]", 	0
GREATER_T: 		defb "<", 	0
LESSER_T: 		defb ">", 	0
GREATER_EQUAL_T:defb ">=", 	0
LESSER_EQUAL_T:	defb "<=", 	0
ASSIGNMENT_T:	defb "<-", 	0
CONJUNCTION_T: 	defb "&", 	0
ALTERNATIVE_T: 	defb "|", 	0
NOT_T: 			defb "!", 	0
ADDR_T: 		defb "@", 	0
DEREFERENCE_T: 	defb "^", 	0
INDEX_T:		defb ".", 	0
STRINDEX_T:		defb "#", 	0
COMMA_T:		defb ",", 	0
TERMINATOR_T:	defb ";", 	0
SEPARATOR_T:	defb ":", 	0

; operator bytecodes
ADD_B			equ '+' 	
SUB_B			equ '-' 	
MINUS_B			equ '~'
MUL_B			equ '*' 	
DIV_B 			equ '/' 	
MOD_B 			equ '\' 		
EQUAL_B			equ '=' 	
NOT_EQUAL_B		equ 'n' 	
QUOTE_B			equ '"' 	
LEFT_PAREN_B	equ '(' 	
RIGHT_PAREN_B 	equ ')' 	
LEFT_BRACKET_B	equ '[' 	
RIGHT_BRACKET_B	equ ']' 
LEFT_CURLY_B	equ '{'
RIGHT_CURLY_B	equ '}'	
GREATER_B 		equ '>' 	
LESSER_B 		equ '<' 	
GREATER_EQUAL_B	equ 'g' 	
LESSER_EQUAL_B	equ 'l' 	
CONJUNCTION_B 	equ '&' 	
ALTERNATIVE_B 	equ '|' 	
NOT_B 			equ '!' 			
ADDR_B 			equ '@' 	
DEREFERENCE_B 	equ '^' 	
INDEX_B			equ '.' 
STRINDEX_B		equ '#'
SEPARATOR_B		equ ':'
TERMINATOR_B	equ ';'
COMMA_B			equ ','

; other bytecodes
ASSIGNMENT_B	equ 'a'
VAR_B			equ 'v'
USERCALL_B		equ 'u'
SYSCALL_B		equ 's'
NUM_B			equ 'm'	
COMMENT_B		equ '%'
IF_B			equ 'I'
ELSE_B			equ "E"
ENDIF_B			equ 'e'
LOOP_B			equ 'L'
WHILE_B			equ 'W'
END_B			equ 'D'
PROC_B			equ 'p'
RET_B			equ 'R'
STOP_B			equ 'T'
ARRAY_B			equ 'A'
STRING_B		equ 'S'
NL_B			equ 00h

; keyword tokens and their corresponding bytecodes
KeywordTokens:
PROG_T: 	defb "PROG", 	0, 'P'
PROC_T: 	defb "PROC", 	0, PROC_B
FUN_T:		defb "FUN", 	0, 'F'
END_T:		defb "END", 	0, END_B
RET_T:		defb "RET", 	0, RET_B
IF_T: 		defb "IF", 		0, IF_B
ELSE_T:		defb "ELSE", 	0, ELSE_B
ENDIF_T:	defb "ENDIF", 	0, ENDIF_B
WHILE_T:	defb "WHILE", 	0, WHILE_B
LOOP_T:		defb "LOOP", 	0, LOOP_B
FOR_T:		defb "FOR", 	0, 'f'
NEXT_T:		defb "NEXT", 	0, 'N'
ARRAY_T:	defb "ARR", 	0, ARRAY_B
RECORD_T:	defb "REC", 	0, ARRAY_B	; records are internally represented identically to arrays.
STRING_T:	defb "STR", 	0, STRING_B
STOP_T: 	defb "STOP", 	0, STOP_B
 defb 0

; Built-In Functions
SYS_READ_B		equ 00h
SYS_WRITE_B 	equ 01h
SYS_BEEP_B		equ 02h
SYS_CLICK_B		equ 03h
SYS_NEWLN_B		equ 04h
SYS_ABS_B		equ 05h
SYS_RND_B		equ	06h
SYS_PEEK_B		equ 07h
SYS_READS_B		equ 08h
SYS_WRITES_B 	equ 09h
SYS_LEN_B 		equ 0Ah
SYS_GETCHAR_B	equ 0Bh
SYS_GET_B		equ 0Ch
SYS_CLRSCR_B	equ 0Dh
SYS_POKE_B		equ 0Eh
SYS_PUT_B		equ 0Fh
SYS_CMP_B		equ 10h
SYS_COPY_B		equ 11h
SYS_DELAY_B		equ 12h
SYS_PUTCHAR_B	equ 13h
SYS_GOTOXY_B	equ 14h
SYS_READKEY_B	equ 15h
SYS_UPPER_B		equ 16h
SYS_LOWER_B		equ 17h
SYS_OPEN_B		equ 18h
SYS_SAVE_B		equ 19h
SYS_RESET_B		equ 1Ah
SYS_SEEK_B		equ 1Bh
SYS_FREAD_B		equ 1Ch

BuiltInFunctions:

; Console functions
 defb "Read", 		0, SYS_READ_B
 defb "Write", 		0, SYS_WRITE_B
 defb "Beep",		0, SYS_BEEP_B
 defb "Click",		0, SYS_CLICK_B
 defb "NewLn", 		0, SYS_NEWLN_B
 defb "ReadS",		0, SYS_READS_B
 defb "WriteS",		0, SYS_WRITES_B
 defb "GetChar", 	0, SYS_GETCHAR_B
 defb "PutChar",	0, SYS_PUTCHAR_B
 defb "GotoXY",		0, SYS_GOTOXY_B
 defb "ClrScr",		0, SYS_CLRSCR_B
 defb "ReadKey",	0, SYS_READKEY_B

; Math functions:
 defb "Abs", 		0, SYS_ABS_B
 defb "Rnd",		0, SYS_RND_B

; String functions
 defb "Len", 		0, SYS_LEN_B
 defb "Cmp",		0, SYS_CMP_B
 defb "Copy",		0, SYS_COPY_B
 defb "Upper",		0, SYS_UPPER_B
 defb "Lower",		0, SYS_LOWER_B

; Miscallenous functions 
 defb "Peek", 		0, SYS_PEEK_B
 defb "Poke",		0, SYS_POKE_B
 defb "Get",		0, SYS_GET_B
 defb "Put",		0, SYS_PUT_B
 defb "Delay",		0, SYS_DELAY_B

; DOS functions:
 defb "Open", 		0, SYS_OPEN_B
 defb "Save", 		0, SYS_SAVE_B
 defb "Reset", 		0, SYS_RESET_B
 defb "Seek", 		0, SYS_SEEK_B
 defb "FRead",		0, SYS_FREAD_B
; defb "FWrite", 	0, SYS_FWRITE_B
; defb "ChDir", 	0, SYS_CHDIR_B
; defb "NextFile",0, SYS_NEXTFILE_B
; defb "NextDir", 0, SYS_NEXTDIR_B
; defb "Size", 	0, SYS_SIZE_B	
; defb "MkDir", 	0, SYS_MKDIR_B
; defb "RmDir", 	0, SYS_RMDIR_B
; defb "DosErr", 	0, SYS_DOSERR_B
; defb "Delete", 	0, SYS_DELETE_B
; defb "Pwd", 	0, SYS_PWD_B
; defb "Touch", 	0, SYS_TOUCH_B
 defb 0

; 128 variables with names of up to 8 characters, 
VARNAMES_SIZE equ 128 * 8
FUNNAMES_SIZE equ 128 * 8

; bytecode types
; TODO

VarnamePtr	equ PROGRAM_DATA + 00h	; 2 byte pointer into the variable name table
ProgramPtr 	equ PROGRAM_DATA + 02h 	; 2 bytes
IsOperator	equ PROGRAM_DATA + 04h
IfOrWhile	equ PROGRAM_DATA + 05h
Token 		equ PROGRAM_DATA + 08h	; 256 bytes for current token
Varnames 	equ PROGRAM_DATA + 108h	; need to be aligned to 8 byte boundary
Funnames    equ PROGRAM_DATA + 108h + VARNAMES_SIZE
Bytecodes 	equ PROGRAM_DATA + 108h + VARNAMES_SIZE + FUNNAMES_SIZE


apl_main:
	LD A, FALSE
	LD (IsOperator), A
	CALL apl_initIdentifierTabs
	LD HL, Bytecodes
	LD (ProgramPtr), HL
	CALL apl_tokenize
	; CALL run_main DEBUG ONLY
	RET

; fills the identifier tables with all zeroes
apl_initIdentifierTabs:
	XOR A           ;LD A, 0
    LD HL, Varnames
    LD DE, Varnames + 1
    LD (HL), A   		
    LD BC, VARNAMES_SIZE + FUNNAMES_SIZE
    LDIR         
	RET

; moves the tokenised program file from Bytecodes to FilBuffer
; and sets the file length
apl_moveFile:
	LD HL, ProgramPtr
	LD BC, Bytecodes
	SUB HL, BC			; output file length in HL
	PUSH HL
	POP BC				; output file length in HL
	LD (CurrentFileSize), HL
	LD HL, Bytecodes
	LD DE, FileBuffer
	LDIR				; transfer the output file to the file buffer
	RET

; reads the next token from the input source code file
; and processes it
apl_nextToken:
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
	CP SUB_B
	JR Z, .checkNeg
	JR .cont
.checkNeg:
	LD A, (IsOperator)
	CP TRUE
	JR NZ, .cont
	CALL dos_fPeekAhead
	CALL isDecDigit
	CP FALSE
	JP Z, apl_tokenizeMinus
	JP NZ, apl_tokenizeDec
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
	CP '"'
	JP Z, apl_tokenizeString
	;
	LD A, B
	CP COMMENT_B
	JP Z, apl_tokenizeComment
	RET

; parses the input file and divides it into tokens
apl_tokenize:
	CALL dos_reset
.loop:
	CALL apl_nextToken
	LD IX, Token
	LD IY, END_T		; TODO: check for end of file
	CALL str_cmp
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
	JR .endLoop
.next:
	CALL dos_fRead
	LD (HL), A
	INC HL
	JR .loop
.endLoop:
	LD (HL), 0
	INC HL
	LD IX, Token
	LD B, (IX)
	CALL apl_isLCaseLetter	; variables start with a lowercase letter
	CP TRUE
	JR Z, .var
	CALL apl_isKeyword
	CP TRUE
	JR Z, .kwd
	CALL apl_isBuiltInFunction
	CP TRUE
	JR Z, .bif
	CALL apl_processFunction
	JR .end
.kwd:
	CALL apl_processKeyword
	JR .end
.bif:
	CALL apl_processBuiltInFunction
	JR .end
.var:
	CALL apl_processVar		; TODO add checking for keywords, constants, system calls, users calls
.end:
	LD A, FALSE
	LD (IsOperator), A
	RET

; checks if the token in Token is a keyword
; result in A
; if result is TRUE, the bytecode for the keyword is returned in B
apl_isKeyword:
	LD IX, KeywordTokens
.loop:
	LD IY, Token
	CALL str_len	; a zero-length keyword indicates end of the KeywordTokens table
	CP 0
	JR Z, .false	; if no match is found, return false
.loop2:
	LD A, (IY)		
	CP 0			; if we reached the end of the token, that means the token is a match
	JR Z, .true		; return true in that case
	LD B, (IX)		
	CP B			; compare Token character with the current keyword character
	JR NZ, .next	; if they're not equal, it's not a match, move to the next keyword
	INC IX
	INC IY
	JR .loop2
.next:
	LD A, (IX)		; check if we're at the end of a keyword
	CP 0
	JR Z, .endNext	
	INC IX			; if not, move to the next character
	JR .next		; and start over
.endNext:
	INC IX			; skipping over the null terminator
	INC IX			; skipping over the actual bytecode in the KeywordTokens table
	JR .loop		; check the next keyword
.true:
	LD A, TRUE
	INC IX 
	LD B, (IX)
	RET
.false:
	LD A, FALSE
	RET

; checks if the token in Token is a built-in funtion
; result in A
; if result is TRUE, the bytecode for the built-in funtion is returned in BC
apl_isBuiltInFunction:
	LD IX, BuiltInFunctions
.loop:
	LD IY, Token
	CALL str_len	; a zero-length keyword indicates end of the KeywordTokens table
	CP 0
	JR Z, .false	; if no match is found, return false
.loop2:
	LD A, (IY)		
	CP 0			; if we reached the end of the token, that means the token is a match
	JR Z, .true		; return true in that case
	LD B, (IX)		
	CP B			; compare Token character with the current keyword character
	JR NZ, .next	; if they're not equal, it's not a match, move to the next keyword
	INC IX
	INC IY
	JR .loop2
.next:
	LD A, (IX)		; check if we're at the end of a keyword
	CP 0
	JR Z, .endNext	
	INC IX			; if not, move to the next character
	JR .next		; and start over
.endNext:
	INC IX			; skipping over the null terminator
	INC IX			; skipping over the actual bytecodes in the BuiltInFunctions table
	JR .loop		; check the next keyword
.true:
	LD B, SYSCALL_B
	INC IX 
	LD C, (IX)
	LD A, TRUE
	RET
.false:
	LD A, FALSE
	RET

; parses out a token representing a decimal number
; and puts in in Token
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


apl_tokenizeMinus:
	LD HL, Token
	CALL dos_fRead		; will read a minus '-' character. 
						; We just call this to advance the file pointer 
						; and discard the value
	LD (HL), MINUS_B
	INC HL
	LD (HL), 0
	INC HL
	CALL apl_processMinus
	LD A, FALSE			; TODO: is this really required?
	LD (IsOperator), A
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
	CP '-'
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

apl_processMinus:
	LD HL, (ProgramPtr)
	LD (HL), MINUS_B
	INC HL
	LD (ProgramPtr), HL
	RET

; adds the bytecode for the operator to the output file
apl_processOperator:
	LD HL, (ProgramPtr)
	CALL apl_getOperatorCode
	CP SEPARATOR_B				; check if the code is for the statement separator
	JR NZ, .cont				; if not, continue
	DEC HL						; move to the previous bytecode
	LD A, (HL)
	CP SEPARATOR_B				; check if the previous bytecode is also a separator
	RET Z 						; if yes, do nothing. This avoids duplicated separators
	INC HL						; otherwise, move back to the current bytecode
	LD A, SEPARATOR_B
.cont:
	CP LEFT_BRACKET_B
	JR NZ, .cont1
	LD A, INDEX_B
	LD (HL), A
	INC HL
	LD A, LEFT_PAREN_B
	JR .cont2
.cont1:
	CP LEFT_CURLY_B
	JR NZ, .cont2
	LD A, STRINDEX_B
	LD (HL), A
	INC HL
	LD A, LEFT_PAREN_B
	JR .cont2
.cont2:
	CP ';'
	JR NZ, .cont3
	LD A, SEPARATOR_B
	LD (HL), A
	INC HL
	LD A, (IfOrWhile)
	CP IF_B
	JR Z, .if
	CP WHILE_B
	JR Z, .while
	JR .syntaxErr
.if:
	LD A, ENDIF_B
	JR .cont3
.while
	LD A, LOOP_B
.cont3:
	LD (HL), A
	INC HL
	LD (ProgramPtr), HL
	RET
.syntaxErr: ; TODO
	RET

apl_processFunction:
	LD HL, (ProgramPtr)
	LD (HL), USERCALL_B
	INC HL
	CALL apl_getFunCode
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

; adds the keyword bytecode to the output file 
; assumes the keyword bytecode is in B
; i.e. apl_isKeyword was called and returned TRUE
apl_processKeyword:
	LD A, B
	CP WHILE_B
	JR Z, .ifOrwhile
	CP IF_B
	JR Z, .ifOrwhile
	JR .cont
.ifOrwhile:
	LD (IfOrWhile), A
.cont:
	LD HL, (ProgramPtr)
	LD (HL), B
	INC HL
	LD (ProgramPtr), HL
	RET

; adds built-in function bytecodes to the output file 
; assumes the built-in function bytecodes are in BC
; i.e. apl_isBuiltInFunction was called and returned TRUE
apl_processBuiltInFunction:
	LD HL, (ProgramPtr)
	LD (HL), B
	INC HL
	LD (HL), C
	INC HL
	LD (ProgramPtr), HL
	RET

; tokenizes the comment
; since comments are not present in the compiled bytecode
; the comment is not processed and is discarded after tokenization
apl_tokenizeComment:
	LD HL, Token
.loop:
	CALL dos_fRead
	CP LF
	JR Z, .end
	CP CR
	JR Z, .end
	LD (HL), A
	INC HL
	JR .loop
.end:
	PUSH HL
	LD HL, (ProgramPtr)
	LD (HL), SEPARATOR_B
	INC HL
	LD (ProgramPtr), HL
	POP HL
	LD (HL), 0
	INC HL
	RET 

apl_tokenizeString
	LD HL, (ProgramPtr)
	CALL dos_fRead	; read the opening quote
	LD (HL), A
	INC HL
.loop:
	CALL dos_fRead
	CP '"'
	JR Z, .endQuote
	CP SEPARATOR_B 
	JR Z, .nl
	CP LF
	JR Z, .nl
	CP CR
	JR Z, .nl
	LD (HL), A
	INC HL
	JR .loop
.endQuote:
	LD (HL), 0
	INC HL
	JR .end
.nl:
	LD (HL), 0
	INC HL
	LD (HL), SEPARATOR_B
	INC HL
.end:
	LD (ProgramPtr), HL
	RET 

; checks whether the character in B is an lowercaseletter
; result in A
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

; checks whether the character in B is an uppercaseletter
; result in A
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

; checks whether the character in B is a letter
; result in A
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

; checks whether the character in B represents (part of) an APL operator
; result in A
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

; checks whether the character in B is a whitespace
; result in A
apl_isWhitespace:
	LD A, B
	CP ' '
	JR Z, .true
	CP 8		 	; tab
	JR Z, .true
	CP LF
	JR Z, .true
	LD A, FALSE
	RET
.true:
	LD A, TRUE
	RET

; checks whether the character in B is a decimal digit
; result in A
apl_isDecDigit:
	LD A, B
	CALL isDecDigit
	CP FALSE
	JR NZ, .true
	RET
.true:
	LD A, TRUE
	RET

; checks whether the character in B is a hexadecimal digit
; result in A
apl_isHexDigit:
	LD A, B
	CALL isHexDigit
	CP FALSE
	JR NZ, .true
	RET
.true:
	LD A, TRUE
	RET

; checks whether the character in B is a bracket
; result in A
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
	CALL apl_nameMatch
	CP TRUE
	JR Z, .found
	CALL apl_nextIdentifier
	INC D
	JR .loop
.notFound:
	CALL apl_newIdentifier
.found:
	LD A, D
	OR 10000000b
	RET

; function name is passed in the Token variable
; and is a null-terminated string
; characters past the 8th are silently ignored
; returns the index of the function in the Funnames table
; adds the function at the end of the table if not already present
; result in A
; destroys D, IX
apl_getFunCode:
	PUSH HL
	LD D, 0		; counting the variables within the varname table in D
	LD IX, Funnames
.loop:
	LD A, (IX)
	CP 0
	JR Z, .notFound
	CALL apl_nameMatch
	CP TRUE
	JR Z, .found
	CALL apl_nextIdentifier
	INC D
	JR .loop
.notFound:
	CALL apl_newIdentifier
.found:
	LD A, D
	POP HL
	RET

; checks whether identifier names pointed to by IX and IY match.
; the identifier name at IX has an 8-byte maximum lenght
; and it is null-terminated only if the length is less than 8
; destroys E, IY, A, B, IX
apl_nameMatch:
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

; adds a new record to an identifier table
; at the current IX position (assumes IX is at the end of the table)
; destroys A, E, IX, IY
apl_newIdentifier:
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
; in the identifier table
; assumes identifiers are aligned at 8 byte boundary
; destroys A, HL, BC
apl_nextIdentifier:
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
	JR Z, .neq
	LD IX, GREATER_EQUAL_T
	CALL str_cmp
	JR Z, .ge
	LD IX, LESSER_EQUAL_T
	CALL str_cmp
	JR Z, .le
	LD IX, ASSIGNMENT_T
	CALL str_cmp
	JR Z, .ass
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
.ass:
	LD A, ASSIGNMENT_B
	RET
.one:
	LD A, (IY)
	CP CR
	JR Z, .sep
	CP RIGHT_CURLY_B
	JR Z, .paren
	CP RIGHT_BRACKET_B
	JR Z, .paren
	JR .end
.paren:
	LD A, RIGHT_PAREN_B
.end:
	RET
.sep:
	LD A, SEPARATOR_B
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





