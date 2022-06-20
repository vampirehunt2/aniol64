; apl

SpecialChars: defb "+-*/\:='()<>&|~@^", 0

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


