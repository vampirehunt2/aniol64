; apl

SpecialChars: defb "+-*/\:='()<>&#~@^", 0

; operator tokens
ADD_T:			defb "+", 	0
SUB_T:			defb "-", 	0
MUL_T:			defb "*", 	0
DIV_T: 			defb "/", 	0
MOD_T: 			defb "\", 	0
ASSIGN_T: 		defb ":", 	0
EQUAL_T:		defb "=", 	0
NOT_EQUAL_T:	defb "<>", 	0
QUOTE_T:		defb "'", 	0
LEFT_PAREN_T:	defb "(", 	0
RIGHT_PAREN_T: 	defb ")", 	0
GREATER_T: 		defb "<", 	0
LESSER_T: 		defb ">", 	0
GREATER_EQUAL_T:defb ">=", 	0
LESSER_EQUAL_T:	defb "<=", 	0
CONJUNCTION_T: 	defb "&", 	0
ALTERNATIVE_T: 	defb "#", 	0
NOT_T: 			defb "~", 	0		; TODO perhaps change to ! and change the binary literal marker to %
ADDR_T: 		defb "@", 	0
DEREFERENCE_T: 	defb "^", 	0

; keyword tokens
PROG_T: 	defb "PROG", 	0
PROC_T: 	defb "PROC", 	0
FUN_T:		defb "FUN", 	0
END_T:		defb "END", 	0
RET_T:		defb "RET", 	0
IF_T: 		defb "IF", 		0
ELSE_T:		defb "ELSE", 	0
ENDIF_T:	defb "ENDIF", 	0
WHILE_T:	defb "WHILE", 	0
LOOP_T:		defb "LOOP", 	0
FOR_T:		defb "FOR", 	0
NEXT_T:		defb "NEXT", 	0




apl_isLCaseLetter:
		CP 'a'
        JR C, _no ; if less than '0' then it's not a hex digit
        CP 'z' + 1
        JR C, _yes ; if less than ':' (which is the next ascii code after '9' then it's a hex digit
        JR _no
_yes
        LD A, TRUE
        RET
_no
        LD A, FALSE
        RET
		
apl_isUCaseLetter:
		CP 'A'
        JR C, _no ; if less than '0' then it's not a hex digit
        CP 'Z' + 1
        JR C, _yes ; if less than ':' (which is the next ascii code after '9' then it's a hex digit
        JR _no
_yes
        LD A, TRUE
        RET
_no
        LD A, FALSE
        RET
		RET
		
PROC
apl_isLetter:
		PUSH AF
		CALL apl_isLCaseLetter
		CP TRUE
		JR Z, _true
		POP AF
		CALL apl_isUCaseLetter
		CP TRUE
		JR Z, _true
		LD A, FALSE
		RET
_true:
		LD A, TRUE
		RET
ENDP

PROC
apl_isSpecialChar:
		PUSH IX
		LD IX, SpecialChars
_loop:
		PUSH AF
		LD A, (IX)
		CP 0
		JR Z, _false
		LD B, A
		POP AF
		CP B
		JR Z, _true
		JR _loop
_true:
		LD A, TRUE
		JR _end
_false:
		LD A, FALSE
_end:
		POP IX
		RET
ENDP

PROC
apl_isSeparator:
		CP ' '
		JR Z, _true
		CP ','
		JR Z, _true
		LD A, FALSE
		RET
_true:
		LD A, TRUE
		RET
ENDP


