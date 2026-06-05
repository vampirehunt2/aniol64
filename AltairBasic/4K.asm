; ----------------------------------------------------------------------------
;Micro-Soft Altair BASIC 3.2 (4K) - Annotated Disassembly
;	
;Copyright 1975, Bill Gates, Paul Allen, Monte Davidoff
;Source: http://altairbasic.org/ compiled by Reuben Harris
;Additional cleanup, relocation by Charles Mangin, March, 2019
; ----------------------------------------------------------------------------


	ORG	00

START:	
	DI
	JP	INIT

	DEFW	0490H
	DEFW	07F9H

SYNTAXCHECK:
	
	LD	A,(HL)		; A=Byte of BASIC program.
	EX	(SP),HL		; HL=return address.
	CP	(HL)		; Compare to byte expected.
	INC	HL		; Return address++;
	EX	(SP),HL		; 
	JP	NZ,SYNTAXERROR	; Error if not what was expected.
NEXTCHAR:
	
	INC	HL
	LD	A,(HL)
	CP	0X3A
	RET	NC
	JP	NEXTCHAR_TAIL
OUTCHAR:
	PUSH	AF
	LD	A,(TERMINAL_X)
	JP	OUTCHAR_TAIL
	NOP
COMPAREHLDE:
	
	LD	A,H
	SUB	D
	RET	NZ
	LD	A,L
	SUB	E
	RET
TERMINAL_Y:
	DEFB	01
TERMINAL_X:
	DEFB	00
FTESTSIGN:
	
	LD	A,(FACCUM+3)
	OR	A
	JP	NZ,FTESTSIGN_TAIL
	RET
PUSHNEXTWORD:
	
	EX	(SP),HL
	LD	(L003A+1),HL
	POP	HL
	LD	C,(HL)
	INC	HL
	LD	B,(HL)
	INC	HL
	PUSH	BC
L003A:	
	JP	L003A
KW_INLINE_FNS:
	
	DEFW	SGN
	DEFW	INT
	DEFW	_ABS
	DEFW	FUNCTIONCALLERROR
	DEFW	SQR
	DEFW	RND
	DEFW	SIN
KW_ARITH_OP_FNS:
	
	DEFB	79H
	DEFW	FADD		; +
	DEFB	79H
	DEFW	FSUB		; -
	DEFB	7CH
	DEFW	FMUL		; *
	DEFB	7CH
	DEFW	FDIV		; /
KEYWORDS:
	
	DEFB	45H, 4EH, 0C4H	; 	"END"	80
	DEFB	46H, 4FH, 0D2H	; 	"FOR"
	DEFB	4EH, 45H, 58H, 0D4H ; 	"NEXT"	82
	DEFB	44H, 41H, 54H, 0C1H ; 	"DATA"	83
	DEFB	49H, 4EH, 50H, 55H, 0D4H ; 	"INPUT"	84
	DEFB	44H, 49H, 0CDH	; 	"DIM"	85
	DEFB	52H, 45H, 41H, 0C4H ; 	"READ"	86
	DEFB	4CH, 45H, 0D4H	; 	"LET"	87
	DEFB	47H, 4FH, 54H, 0CFH ; 	"GOTO"	88
	DEFB	52H, 55H, 0CEH	; 	"RUN"	89
	DEFB	49H, 0C6H	; 	"IF"	8A
	DEFB	52H, 45H, 53H, 54H, 4FH, 52H, 0C5H ; 	"RESTORE"	8B
	DEFB	47H, 4FH, 53H, 55H, 0C2H ; 	"GOSUB"	8C
	DEFB	52H, 45H, 54H, 55H, 52H, 0CEH ; 	"RETURN"	8D
	DEFB	52H, 45H, 0CDH	; 	"REM"	8E
	DEFB	53H, 54H, 4FH, 0D0H ; 	"STOP"	8F
	DEFB	50H, 52H, 49H, 4EH, 0D4H ; 	"PRINT"	90
	DEFB	4CH, 49H, 53H, 0D4H ; 	"LIST"	91
	DEFB	43H, 4CH, 45H, 41H, 0D2H ; 	"CLEAR"	92
	DEFB	4EH, 45H, 0D7H	; 	"NEW"	93
;
	DEFB	54H, 41H, 42H, 0A8H ; 	"TAB("	94
	DEFB	54H, 0CFH	; 	"TO"	95
	DEFB	54H, 48H, 45H, 0CEH ; 	"THEN"	96
	DEFB	53H, 54H, 45H, 0D0H ; 	"STEP"	97
;
	DEFB	0XAB		; 	"+"	98
	DEFB	0XAD		; 	"-"	99
	DEFB	0XAA		; 	"*"	9A
	DEFB	0XAF		; 	"/"	9B
	DEFB	0XBE		; 	">"	9C
	DEFB	0XBD		; 	"="	9D
	DEFB	0XBC		; 	"<"	9E
;
	DEFB	53H, 47H, 0CEH	; 	"SGN"	9F
	DEFB	49H, 4EH, 0D4H	; 	"INT"	A0
	DEFB	41H, 42H, 0D3H	; 	"ABS"	A1
	DEFB	55H, 53H, 0D2H	; 	"USR"	A2
	DEFB	53H, 51H, 0D2H	; 	"SQR"	A3
	DEFB	52H, 4EH, 0C4H	; 	"RND"	A4
	DEFB	53H, 49H, 0CEH	; 	"SIN"	A5
				; 
	DEFB	0X00		; 	 	
				; 
KW_GENERAL_FNS:
	
	DEFW	STOP		; END
	DEFW	FOR		; FOR
	DEFW	NEXT		; NEXT
	DEFW	FINDNEXTSTATEMENT ; DATA
	DEFW	INPUT		; INPUT
	DEFW	DIM		; DIM
	DEFW	READ		; READ
	DEFW	LET		; LET
	DEFW	GOTO		; GOTO
	DEFW	RUN		; RUN
	DEFW	IF		; IF
	DEFW	RESTORE		; RESTORE
	DEFW	GOSUB		; GOSUB
	DEFW	RETURN		; RETURN
	DEFW	REM		; REM
	DEFW	STOP		; STOP
	DEFW	PRINT		; PRINT
	DEFW	LIST		; LIST
	DEFW	CLEAR		; CLEAR
	DEFW	NEW		; NEW

ERROR_CODES:
	
	DEFB	4EH, 0C6H	; "NF"	NEXT without FOR.
	DEFB	53H, 0CEH	; "SN"	Syntax Error
	DEFB	52H, 0C7H	; "RG"	RETURN without GOSUB.
	DEFB	4FH, 0C4H	; "OD"	Out of Data
	DEFB	46H, 0C3H	; "FC"	Illegal Function Call
	DEFB	4FH, 0D6H	; "OV"	Overflow.
	DEFB	4FH, 0CDH	; "OM"	Out of memory.
	DEFB	55H, 0D3H	; "US"	Undefined Subroutine
	DEFB	42H, 0D3H	; "BS"	Bad Subscript
	DEFB	44H, 0C4H	; "DD"	Duplicate Definition
	DEFB	2FH, 0B0H	; "\0"	Division by zero.
	DEFB	49H, 0C4H	; "ID"	Invalid in Direct mode.

	DEFB	','		; 
	
DIM_OR_EVAL 	equ 8000h
	;DEFB	00H		; 
INPUT_OR_READ 	equ 8001h
	;DEFB	00H		; 
PROG_PTR_TEMP 	equ 8002h
	;DEFW	0000H		; 
L015F			equ 8004h	
	;DEFW	0000H		; 
CURRENT_LINE	equ 8006h
	;DEFW	0000H		; 
STACK_TOP		equ 8008h
	;DEFW	0FFFFH		; RELOCATE***
PROGRAM_BASE	equ 800Ah
	;DEFW	0000H		; 
VAR_BASE		equ 800Ch
	;DEFW	0000H		; 
VAR_ARRAY_BASE	equ 800Eh
	;DEFW	0000H		; 
VAR_TOP 		equ 8010h 
	;DEFW	0000H		; 
DATA_PROG_PTR	equ 8012h
	;DEFW	0000H		; 
FACCUM			equ 8014h
	;DEFB	00000000H	; 
FTEMP			equ 8018h	
	;DEFB	00H		; 
FBUFFER 		equ 8019h
	;DEFW	0000,0000,0000
	;DEFW	0000,0000,0000
	;DEFB	00		; 
LINE_BUFFER 	equ FBUFFER + 13
	
	;DEFW	0000,0000,0000,0000H ; 72 chars
	;DEFW	0000,0000,0000,0000H ; 
	;DEFW	0000,0000,0000,0000H ; 
	;DEFW	0000,0000,0000,0000H ; 
	;DEFW	0000,0000,0000,0000H ; 
	;DEFW	0000,0000,0000,0000H ; 
	;DEFW	0000,0000,0000,0000H ; 
	;DEFW	0000,0000,0000,0000H ; 
	;DEFW	0000,0000,0000,0000H ; 	

VAREND			equ LINE_BUFFER	+ 72

SZERROR:
	DEFB	0X20,0X45,0X52,0X52,0X4F,0XD2,0X00 ; " ERROR\0"	 
SZIN:	DEFB	0X20,0X49,0X4E,0XA0,0X00 ; " IN \0"
SZOK:	
	DEFB	0X0D,0X4F,0XCB,0X0D,0X00 ; "\rOK\r\0"	 
GETFLOWPTR:
	
	LD	HL,0004H	; HL=SP+4 (ie get word
	ADD	HL,SP		; Just past return addr)
	LD	A,(HL)		; 
	INC	HL		; 
	CP	0X81		; 'FOR'?
	RET	NZ		; Return if not 'FOR'
	RST	8*6		; RST PushNextWord	;PUSH (HL)
	EX	(SP),HL		; POP HL (ie HL=(HL))
	RST	8*4		; RST CompareHLDE	;HL==DE?
	LD	BC,000DH	; 
	POP	HL		; Restore HL
	RET	Z		; Return if var ptrs match.
	ADD	HL,BC		; HL+=000D
	JP	GETFLOWPTR+4	; Loop
COPYMEMORYUP:
	
	CALL	CHECKENOUGHMEM	; 
	PUSH	BC		; Exchange BC with HL.
	EX	(SP),HL		; 
	POP	BC		; 
COPYMEMLOOP:
	
	RST	8*4		; HL==DE?
	LD	A,(HL)		; 
	LD	(BC),A		; 
	RET	Z		; Exit if DE reached.
	DEC	BC		; 
	DEC	HL		; 
	JP	COPYMEMLOOP	; 
CHECKENOUGHVARSPACE:
	
	PUSH	HL		; 
	LD	HL,(VAR_TOP)	; 
	LD	B,00H		; BC=C*4
	ADD	HL,BC		; 
	ADD	HL,BC		; 
	CALL	CHECKENOUGHMEM	; 
	POP	HL		; 
	RET			; 
CHECKENOUGHMEM:
	
	PUSH	DE		; 
	EX	DE,HL		; 
	LD	HL,0XFFDE	; HL=-34 (extra 2 bytes for return address)
	ADD	HL,SP		; 
	RST	8*4		; 
	EX	DE,HL		; 
	POP	DE		; 
	RET	NC		; 
OUTOFMEMORY:
	
	LD	E,0CH		; 
	DEFB	01		; LXI B,....	;
SYNTAXERROR:
	
	LD	E,02H		; 
	DEFB	01		; LXI B,....	;
DIVIDEBYZERO:
	
	LD	E,14H		; 
ERROR:	
	CALL	RESETSTACK	; 
	CALL	NEWLINE		; 
	LD	HL,ERROR_CODES	; 
	LD	D,A		; 
	LD	A,'?'		; Print '?'
	RST	8*03		; RST OutChar	;
	ADD	HL,DE		; HL points to error code.
	LD	A,(HL)		; 
	RST	8*03		; RST OutChar 11 011 111	;Print first char of code.
	RST	8*02		; RST NextChar 11 010 111	;
	RST	8*03		; RST OutChar	;Print second char of code.
	LD	HL,SZERROR	; Print " ERROR".
	CALL	PRINTSTRING	; 
	LD	HL,(CURRENT_LINE) ; 
	LD	A,H		; 
	AND	L		; 
	INC	A		; 
	CALL	NZ,PRINTIN	; 
	DEFB	01		; LXI B,....	;LXI over Stop and fall into Main
STOP:	
	RET	NZ		; Syntax Error if args.
	POP	BC		; Lose return address.
MAIN:	
	LD	HL,SZOK		; 
	CALL	INIT		; 
GETNONBLANKLINE:
	
	LD	HL,0XFFFF	; 
	LD	(CURRENT_LINE),HL ; 
	CALL	INPUTLINE	; 
	RST	8*02		; RST NextChar	; 
	INC	A		; 
	DEC	A		; 
	JP	Z,GETNONBLANKLINE ; 
	PUSH	AF
	CALL	LINENUMBERFROMSTR
	PUSH	DE
	CALL	TOKENIZE
	LD	B,A
	POP	DE
	POP	AF
	JP	NC,EXEC
STOREPROGRAMLINE:
	
	PUSH	DE		; Push line number
	PUSH	BC		; Push line length
	RST	8*02		; RST NextChar	;Get first char of line
	OR	A		; Zero set if line is empty (ie removing a line)
	PUSH	AF		; Preserve line-empty flag
	CALL	FINDPROGRAMLINE	; Get nearest program line address in BC.
	PUSH	BC		; Push line address.
	JP	NC,INSERTPROGRAMLINE ; If line doesn't exist, jump ahead to insert it.
REMOVEPROGRAMLINE:
	
	EX	DE,HL		; DE=Next line address.
	LD	HL,(VAR_BASE)	; 
REMOVELINE:
	
	LD	A,(DE)		; Move byte of program remainder down
	LD	(BC),A		; In memory.
	INC	BC		; 
	INC	DE		; 
	RST	8*4		; Loop until DE==VAR_BASE, ie whole
	JP	NZ,REMOVELINE	; Program remainder done.
	LD	H,B		; 
	LD	L,C		; Update VAR_BASE from BC.
	LD	(VAR_BASE),HL	; 
INSERTPROGRAMLINE:
	
	POP	DE		; DE=Line address (from 224)
	POP	AF		; Restore line-empty flag (see above)
	JP	Z,UPDATELINKEDLIST ; If line is empty, then we don't need to insert it so can j
	LD	HL,(VAR_BASE)	; 
	EX	(SP),HL		; HL = Line length (see 21D)
	POP	BC		; BC = VAR_BASE
	ADD	HL,BC		; HL = VAR_BASE + line length.
	PUSH	HL		; 
	CALL	COPYMEMORYUP	; Move remainder of program so there's enough space for the n
	POP	HL		; 
	LD	(VAR_BASE),HL	; Update VAR_BASE
	EX	DE,HL		; HL=Line address, DE=VAR_BASE
	LD	(HL),H		; ???
	INC	HL		; Skip over next line ptr (updated below)
	INC	HL		; 
	POP	DE		; DE = line number (see 21C)
	LD	(HL),E		; Write line number to program line memory.
	INC	HL		; 
	LD	(HL),D		; 
	INC	HL		; 
COPYFROMBUFFER:
	
	LD	DE,LINE_BUFFER	; Copy the line into the program.
	LD	A,(DE)		; 
	LD	(HL),A		; 
	INC	HL		; 
	INC	DE		; 
	OR	A		; 
	JP	NZ,COPYFROMBUFFER+3 ; 
UPDATELINKEDLIST:
	
	CALL	RESETALL	; 
	INC	HL		; 
	EX	DE,HL		; 
L0265:	
	LD	H,D		; 
	LD	L,E		; 
	LD	A,(HL)		; If the pointer to the next line is a null
	INC	HL		; Word then we've reached the end of the
	OR	(HL)		; Program, job is done, and we can jump back
	JP	Z,GETNONBLANKLINE ; To let the user type in the next line.
	INC	HL		; Skip over line number.
	INC	HL		; 
	INC	HL		; 
	XOR	A		; 
L0271:	
	CP	(HL)		; 
	INC	HL		; 
	JP	NZ,L0271	; 
	EX	DE,HL		; 
	LD	(HL),E		; 
	INC	HL		; 
	LD	(HL),D		; 
	JP	L0265		; 
FINDPROGRAMLINE:
	
	LD	HL,(PROGRAM_BASE) ; 
	LD	B,H		; BC=this line
	LD	C,L		; 
	LD	A,(HL)		; If we've found two consecutive
	INC	HL		; Null bytes, then we've reached the end
	OR	(HL)		; Of the program and so return.
	DEC	HL		; 
	RET	Z		; 
	PUSH	BC		; Push this line address
	RST	8*6		; Push (next line address)
	RST	8*6		; Push (this line number)
	POP	HL		; HL = this line number
	RST	8*4		; Compare line numbers
	POP	HL		; HL = next line address
	POP	BC		; BC = this line address
	CCF			; 
	RET	Z		; Return carry set if line numbers match.
	CCF			; 
	RET	NC		; Return if we've reached a line number greater than the one required.
	JP	FINDPROGRAMLINE+3
NEW:	
	RET	NZ
	LD	HL,(PROGRAM_BASE)
	XOR	A
	LD	(HL),A
	INC	HL
	LD	(HL),A
	INC	HL
	LD	(VAR_BASE),HL
RUN:	
	RET	NZ
RESETALL:
	LD	HL,(PROGRAM_BASE)
	DEC	HL
CLEAR:	
	LD	(PROG_PTR_TEMP),HL
	CALL	RESTORE
	LD	HL,(VAR_BASE)
	LD	(VAR_ARRAY_BASE),HL
	LD	(VAR_TOP),HL
RESETSTACK:
	
	POP	BC
	LD	HL,(STACK_TOP)
	LD	SP,HL
	XOR	A
	LD	L,A
	PUSH	HL
	PUSH	BC
	LD	HL,(PROG_PTR_TEMP)
	RET
INPUTLINEWITH:
	
	LD	A,'?'		; Print '?'
	RST	8*03		; RST OutChar	;
	LD	A,' '		; Print ' '
	RST	8*03		; RST OutChar	;
	CALL	INPUTLINE	; 
	INC	HL		; 
TOKENIZE:
	
	LD	C,05		; Initialise line length to 5.
	LD	DE,LINE_BUFFER	; Ie, output ptr is same as input ptr at start.
	LD	A,(HL)		; 
	CP	' '		; 
	JP	Z,WRITECHAR	; 
	LD	B,A		; 
	CP	'"'		; 
	JP	Z,FREECOPY	; 
	OR	A		; 
	JP	Z,EXIT		; 
	PUSH	DE		; Preserve output ptr.
	LD	B,00		; Initialise Keyword ID to 0.
	LD	DE,KEYWORDS-1	; 
	PUSH	HL		; Preserve input ptr.
	DEFB	3EH		; LXI over get-next-char
KWCOMPARE:
	
	RST	8*02		; RST 01	; SyntaxCheck0	;Get next input char
	INC	DE		; 
	LD	A,(DE)		; Get keyword char to compare with.
	AND	7FH		; Ignore bit 7 of keyword char.
	JP	Z,NOTAKEYWORD	; If keyword char==0, then end of keywords reached.
	CP	(HL)		; Keyword char matches input char?
	JP	NZ,NEXTKEYWORD	; If not, jump to get next keyword.
	LD	A,(DE)		; 
	OR	A		; 
	JP	P,KWCOMPARE	; 
	POP	AF		; Remove input ptr from stack. We don't need it.
	LD	A,B		; A=Keyword ID
	OR	0X80		; Set bit 7 (indicates a keyword)
	DEFB	0XF2		; JP ....	;LXI trick again.
NOTAKEYWORD:
	
	POP	HL		; Restore input ptr
	LD	A,(HL)		; And get input char
	POP	DE		; Restore output ptr
WRITECHAR:
	
	INC	HL		; Advance input ptr
	LD	(DE),A		; Store output char
	INC	DE		; Advance output ptr
	INC	C		; C++ (arf!).
	SUB	8EH		; If it's not the
	JP	NZ,TOKENIZE+5	; 
	LD	B,A		; B=0
FREECOPYLOOP:
	
	LD	A,(HL)		; A=Input char
	OR	A		; If char is null then exit
	JP	Z,EXIT		; 
	CP	B		; If input char is term char then
	JP	Z,WRITECHAR	; We're done free copying.
FREECOPY:
	
	INC	HL		; 
	LD	(DE),A		; 
	INC	C		; 
	INC	DE		; 
	JP	FREECOPYLOOP	; 
NEXTKEYWORD:
	
	POP	HL		; Restore input ptr
	PUSH	HL		; 
	INC	B		; Keyword ID ++;
	EX	DE,HL		; HL=keyword table ptr
NEXTKWLOOP:
	
	OR	(HL)		; Loop until
	INC	HL		; Bit 7 of previous
	JP	P,NEXTKWLOOP	; Keyword char is set.
	EX	DE,HL		; DE=keyword ptr, HL=input ptr
	JP	KWCOMPARE+2	; 
EXIT:	
	LD	HL,LINE_BUFFER-1 ; 
	LD	(DE),A		; 
	INC	DE		; 
	LD	(DE),A		; 
	INC	DE		; 
	LD	(DE),A		; 
	RET			; 
BACKSPACE:
	
	DEC	B		; Char count--;
	DEC	HL		; Input ptr--;
	RST	8*03		; RST OutChar	;Print backspace char.
	JP	NZ,INPUTNEXT	; 
RESETINPUT:
	
	RST	8*03		; RST OutChar	;
	CALL	NEWLINE		; 
INPUTLINE:
	
	LD	HL,LINE_BUFFER	; 
	LD	B,01		; 
INPUTNEXT:
	
	CALL	INPUTCHAR	; 
	CP	0X0D		; 
	JP	Z,TERMINATEINPUT ; 
	CP	' '		; If < ' '
	JP	C,INPUTNEXT	; Or
	CP	0X7D		; > '}'
	JP	NC,INPUTNEXT	; Then loop back.
	CP	'@'		; 
	JP	Z,RESETINPUT	; 
	CP	'_'		; 
	JP	Z,BACKSPACE	; 
	LD	C,A		; 
	LD	A,B		; 
	CP	0X48		; 
	LD	A,07		; 
	JP	NC,L036A	; 
	LD	A,C		; Write char to LINE_BUFFER.
	LD	(HL),C		; 
	INC	HL		; 
	INC	B		; 
L036A:	
	RST	8*03		; RST OutChar	;
	JP	INPUTNEXT	; 
OUTCHAR_TAIL:
	
	CP	0X48		; 
	CALL	Z,NEWLINE	; 
	INC	A		; 
	LD	(TERMINAL_X),A	; 
WAITTERMREADY:
	
	IN	A,(00)		; 		; TODO Piotr this is where output procedure needs to be changed
	AND	80H		; 
	JP	NZ,WAITTERMREADY ; 
	POP	AF		; 
	OUT	(01),A		; 
	RET			; 
INPUTCHAR:
	
				; TODO Piotr this is where input procedure needs to be changed
	IN	A,(00)		; 
	AND	01		; 
	JP	NZ,INPUTCHAR	; 
	IN	A,(01)		; 
	AND	7FH		; 
	RET			; 
LIST:	
	CALL	LINENUMBERFROMSTR
	RET	NZ
	POP	BC		; ?why get return address?
	CALL	FINDPROGRAMLINE
	PUSH	BC
LISTNEXTLINE:
	
	POP	HL
	RST	8*6
	POP	BC
	LD	A,B
	OR	C
	JP	Z,MAIN
	CALL	TESTBREAKKEY
	PUSH	BC
	CALL	NEWLINE
	RST	8*6
	EX	(SP),HL
	CALL	PRINTINT
	LD	A,' '
	POP	HL
LISTCHAR:
	
	RST	8*03		; RST OutChar	
	LD	A,(HL)
	OR	A
	INC	HL
	JP	Z,LISTNEXTLINE
	JP	P,LISTCHAR
	SUB	7FH		; A is now keyword index + 1.
	LD	C,A
	PUSH	HL
	LD	DE,KEYWORDS
	PUSH	DE
TONEXTKEYWORD:
	
	LD	A,(DE)
	INC	DE
	OR	A
	JP	P,TONEXTKEYWORD
	DEC	C
	POP	HL
	JP	NZ,TONEXTKEYWORD-1
PRINTKEYWORD:
	
	LD	A,(HL)
	OR	A
	JP	M,LISTCHAR-1
	RST	8*03		; RST OutChar	
	INC	HL
	JP	PRINTKEYWORD
FOR:	
	CALL	LET
	EX	(SP),HL
	CALL	GETFLOWPTR
	POP	DE
	JP	NZ,L03E2
	ADD	HL,BC
	LD	SP,HL
L03E2:	
	EX	DE,HL
	LD	C,08
	CALL	CHECKENOUGHVARSPACE
	PUSH	HL
	CALL	FINDNEXTSTATEMENT
	EX	(SP),HL
	PUSH	HL
	LD	HL,(CURRENT_LINE)
	EX	(SP),HL
	RST	8*01		; SyntaxCheck; SyntaxCheck	
	DEFB	95H		; KWID_TO	
	CALL	EVALEXPRESSION
	PUSH	HL
	CALL	FCOPYTOBCDE
	POP	HL
	PUSH	BC
	PUSH	DE
	LD	BC,8100H
	LD	D,C
	LD	E,D
	LD	A,(HL)
	CP	0X97		; KWID_STEP	
	LD	A,01H
	JP	NZ,PUSHSTEPVALUE
	CALL	EVALEXPRESSION+1
	PUSH	HL
	CALL	FCOPYTOBCDE
	RST	8*05		; FTestSign	
	POP	HL
PUSHSTEPVALUE:
	
	PUSH	BC
	PUSH	DE
	PUSH	AF
	INC	SP
	PUSH	HL
	LD	HL,(PROG_PTR_TEMP)
	EX	(SP),HL
ENDOFFORHANDLER:
	
	LD	B,0X81
	PUSH	BC
	INC	SP
EXECNEXT:
	
	CALL	TESTBREAKKEY
	LD	A,(HL)
	CP	':'
	JP	Z,EXEC
	OR	A
	JP	NZ,SYNTAXERROR
	INC	HL
	LD	A,(HL)
	INC	HL
	OR	(HL)
	INC	HL
	JP	Z,MAIN
	LD	E,(HL)
	INC	HL
	LD	D,(HL)
	EX	DE,HL
	LD	(CURRENT_LINE),HL
	EX	DE,HL
EXEC:	
	RST	8*02		; RST NextChar	
	LD	DE,EXECNEXT
	PUSH	DE
	RET	Z
	SUB	80H
	JP	C,LET
	CP	0X14
	JP	NC,SYNTAXERROR
	RLCA			; BC = A*2
	LD	C,A
	LD	B,00H
	EX	DE,HL
	LD	HL,KW_GENERAL_FNS
	ADD	HL,BC
	LD	C,(HL)
	INC	HL
	LD	B,(HL)
	PUSH	BC
	EX	DE,HL
	RST	8*02		; RST NextChar	
	RET
NEXTCHAR_TAIL:
	CP	' '
	JP	Z,NEXTCHAR
	CP	'0'
	CCF
	INC	A
	DEC	A
	RET
RESTORE:
	EX	DE,HL
	LD	HL,(PROGRAM_BASE)
	DEC	HL
L046E:	
	LD	(DATA_PROG_PTR),HL
	EX	DE,HL
	RET
TESTBREAKKEY:
	
	IN	A,(00)		; Exit if no key pressed.
	AND	01		; 
	RET	NZ		; 
	CALL	INPUTCHAR	; 
	CP	0X03		; Break key?
	JP	STOP
CHARISALPHA:
	
	LD	A,(HL)
	CP	'A'
	RET	C
	CP	'Z'+1
	CCF
	RET
GETSUBSCRIPT:
	
	RST	8*02		; RST NextChar	
	CALL	EVALEXPRESSION
	RST	8*05		; FTestSign	
	JP	M,FUNCTIONCALLERROR
	LD	A,(FACCUM+3)
	CP	0X90
	JP	C,FASINTEGER
FUNCTIONCALLERROR:
	
	LD	E,08H
	JP	ERROR
LINENUMBERFROMSTR:
	
	DEC	HL
	LD	DE,0000
NEXTLINENUMCHAR:
	
	RST	8*02		; RST NextChar	
	RET	NC
	PUSH	HL
	PUSH	AF		; Preserve flags
	LD	HL,1998H	; Decimal 6552
	RST	8*4
	JP	C,SYNTAXERROR
	LD	H,D
	LD	L,E
	ADD	HL,DE
	ADD	HL,HL
	ADD	HL,DE
	ADD	HL,HL
	POP	AF
	SUB	'0'
	LD	E,A
	LD	D,00H
	ADD	HL,DE
	EX	DE,HL
	POP	HL
	JP	NEXTLINENUMCHAR
GOSUB:	
	LD	C,03H
	CALL	CHECKENOUGHVARSPACE
	POP	BC
	PUSH	HL
	PUSH	HL
	LD	HL,(CURRENT_LINE)
	EX	(SP),HL
	LD	D,0X8C
	PUSH	DE
	INC	SP
	PUSH	BC
GOTO:	
	CALL	LINENUMBERFROMSTR
	RET	NZ
	CALL	FINDPROGRAMLINE
	LD	H,B
	LD	L,C
	DEC	HL
	RET	C
	LD	E,0EH
	JP	ERROR
RETURN:	
	RET	NZ
	LD	D,0XFF
	CALL	GETFLOWPTR
	LD	SP,HL
	CP	0X8C
	LD	E,04H
	JP	NZ,ERROR
	POP	HL
	LD	(CURRENT_LINE),HL
	LD	HL,EXECNEXT
	EX	(SP),HL
FINDNEXTSTATEMENT:
	
	DEFB	01H, 3AH	; LXI B,..3A	
REM:	DEFB	10H
	NOP
FINDNEXTSTATEMENTLOOP:
	
	LD	A,(HL)
	OR	A
	RET	Z
	CP	C
	RET	Z
	INC	HL
	JP	FINDNEXTSTATEMENTLOOP
LET:	
	CALL	GETVAR
	RST	8*01		; SyntaxCheck	
	DEFB	9DH
ASSIGNVAR:
	
	PUSH	DE
	CALL	EVALEXPRESSION
	EX	(SP),HL
	LD	(PROG_PTR_TEMP),HL
	PUSH	HL
	CALL	FCOPYTOMEM
	POP	DE
	POP	HL
	RET
IF:	
	CALL	EVALEXPRESSION
	LD	A,(HL)
	CALL	FPUSH
	LD	D,00
GETCOMPAREOPLOOP:
	
	SUB	9CH		; KWID_>	
	JP	C,GOTCOMPAREOP
	CP	0X03
	JP	NC,GOTCOMPAREOP
	CP	0X01
	RLA
	OR	D
	LD	D,A
	RST	8*02		; RST NextChar	
	JP	GETCOMPAREOPLOOP
GOTCOMPAREOP:
	
	LD	A,D
	OR	A
	JP	Z,SYNTAXERROR
	PUSH	AF
	CALL	EVALEXPRESSION
	RST	8*01		; SyntaxCheck	
	DEFB	96H		; KWID_THEN	
	DEC	HL
	POP	AF
	POP	BC
	POP	DE
	PUSH	HL
	PUSH	AF
	CALL	FCOMPARE
	INC	A
	RLA
	POP	BC
	AND	B
	POP	HL
	JP	Z,REM
	RST	8*02		; RST NextChar	
	JP	C,GOTO
	JP	EXEC+5
	DEC	HL
	RST	8*02		; RST NextChar	
PRINT:	
	JP	Z,NEWLINE
	RET	Z
	CP	'"'
	CALL	Z,PRINTSTRING-1
	JP	Z,PRINT-2
	CP	0X94		; KWID_TAB	 
	JP	Z,TAB
	PUSH	HL
	CP	','
	JP	Z,TONEXTTABBREAK
	CP	';'
	JP	Z,EXITTAB
	POP	BC
	CALL	EVALEXPRESSION
	PUSH	HL
	CALL	FOUT
	CALL	PRINTSTRING
	LD	A,' '
	RST	8*03		; RST OutChar	
	POP	HL
	JP	PRINT-2
TERMINATEINPUT:
	
	LD	(HL),00H
	LD	HL,LINE_BUFFER-1
NEWLINE:
	LD	A,0DH
	LD	(TERMINAL_X),A
	RST	8*03		; RST OutChar	
	LD	A,0AH
	RST	8*03		; RST OutChar	
	LD	A,(TERMINAL_Y)
PRINTNULLLOOP:
	
	DEC	A
	LD	(TERMINAL_X),A
	RET	Z
	PUSH	AF
	XOR	A
	RST	8*03		; RST OutChar	
	POP	AF
	JP	PRINTNULLLOOP
	INC	HL
PRINTSTRING:
	
	LD	A,(HL)
	OR	A
	RET	Z
	INC	HL
	CP	'"'
	RET	Z
	RST	8*03		; RST OutChar	
	CP	0X0D
	CALL	Z,NEWLINE
	JP	PRINTSTRING
TONEXTTABBREAK:
	
	LD	A,(TERMINAL_X)
	CP	0X38
	CALL	NC,NEWLINE
	JP	NC,EXITTAB
CALCSPACECOUNT:
	
	SUB	0EH
	JP	NC,CALCSPACECOUNT
	CPL
	JP	PRINTSPACES
TAB:	
	CALL	GETSUBSCRIPT
	RST	8*01		; SyntaxCheck	
	DEFB	29H		; ')'	
	DEC	HL
	PUSH	HL
	LD	A,(TERMINAL_X)
	CPL
	ADD	A,E
	JP	NC,EXITTAB
PRINTSPACES:
	
	INC	A
	LD	B,A
	LD	A,' '
PRINTSPACELOOP:
	
	RST	8*03		; RST OutChar	
	DEC	B
	JP	NZ,PRINTSPACELOOP
EXITTAB:
	POP	HL
	RST	8*02		; RST NextChar	
	JP	PRINT+3
INPUT:	
	PUSH	HL
	LD	HL,(CURRENT_LINE)
	LD	E,16H
	INC	HL
	LD	A,L
	OR	H
	JP	Z,ERROR
	CALL	INPUTLINEWITH
	JP	L05FA+1
READ:	
	PUSH	HL
	LD	HL,(DATA_PROG_PTR)
L05FA:	
	OR	0XAF
				; XRA A	
	LD	(INPUT_OR_READ),A
	EX	(SP),HL
	DEFB	01		; LXI B,....	
READNEXT:
	
	RST	8*01		; SyntaxCheck	
	DEFB	2CH		; ','	
	CALL	GETVAR
	EX	(SP),HL
	PUSH	DE
	LD	A,(HL)
	CP	','
	JP	Z,GOTDATAITEM
	OR	A
	JP	NZ,SYNTAXERROR
	LD	A,(INPUT_OR_READ)
	OR	A
	INC	HL
	JP	NZ,NEXTDATALINE+1
	LD	A,'?'
	RST	8*03		; RST OutChar	
	CALL	INPUTLINEWITH
GOTDATAITEM:
	
	POP	DE
	INC	HL
	CALL	ASSIGNVAR
	EX	(SP),HL
	DEC	HL
	RST	8*02		; RST NextChar	
	JP	NZ,READNEXT
	POP	DE
	LD	A,(INPUT_OR_READ)
	OR	A
	RET	Z
	EX	DE,HL
	JP	NZ,L046E
NEXTDATALINE:
	
	POP	HL
	RST	8*6
	LD	A,C
	OR	B
	LD	E,06H
	JP	Z,ERROR
	INC	HL
	RST	8*02		; RST NextChar	
	CP	0X83		; KWID_DATA	 
	JP	NZ,NEXTDATALINE
	POP	BC
	JP	GOTDATAITEM
NEXT:	
	CALL	GETVAR
	LD	(PROG_PTR_TEMP),HL
	CALL	GETFLOWPTR
	LD	SP,HL
	PUSH	DE
	LD	A,(HL)
	INC	HL
	PUSH	AF
	PUSH	DE
	LD	E,00H
	JP	NZ,ERROR
	CALL	FLOADFROMMEM
	EX	(SP),HL
	PUSH	HL
	CALL	FADDMEM
	POP	HL
	CALL	FCOPYTOMEM
	POP	HL
	CALL	FLOADBCDEFROMMEM
	PUSH	HL
	CALL	FCOMPARE
	POP	HL
	POP	BC
	SUB	B
	CALL	FLOADBCDEFROMMEM
	JP	Z,FORLOOPISCOMPLETE
	EX	DE,HL
	LD	(CURRENT_LINE),HL
	LD	L,C
	LD	H,B
	JP	ENDOFFORHANDLER
FORLOOPISCOMPLETE:
	
	LD	SP,HL
	LD	HL,(PROG_PTR_TEMP)
	JP	EXECNEXT
EVALEXPRESSION:
	
	DEC	HL
	LD	D,00H
	PUSH	DE
	LD	C,01H
	CALL	CHECKENOUGHVARSPACE
	CALL	EVALTERM
	LD	(L015F),HL
ARITHPARSE:
	
	LD	HL,(L015F)
	POP	BC
	LD	A,(HL)
	LD	D,00H
	SUB	0X98		; KWID_PLUS	
	RET	C
	CP	0X04
	RET	NC
	LD	E,A
	RLCA
	ADD	A,E
	LD	E,A
	LD	HL,KW_ARITH_OP_FNS
	ADD	HL,DE
	LD	A,B
	LD	D,(HL)
	CP	D
	RET	NC
	INC	HL
	PUSH	BC
	LD	BC,ARITHPARSE
	PUSH	BC
	LD	C,D		; ???
	CALL	FPUSH
	LD	D,C
	RST	8*6
	LD	HL,(L015F)
	JP	EVALEXPRESSION+3
EVALTERM:
	
	RST	8*02		; RST NextChar	
	JP	C,FIN
	CALL	CHARISALPHA
	JP	NC,EVALVARTERM
	CP	0X98		; KWID_PLUS	
	JP	Z,EVALTERM
	CP	'.'
	JP	Z,FIN
	CP	0X99		; KWID_MINUS	
	JP	Z,EVALMINUSTERM
	SUB	9FH
	JP	NC,EVALINLINEFN
EVALBRACKETED:
	
	RST	8*01		; SyntaxCheck	
	DEFB	28H		; '('	
	CALL	EVALEXPRESSION
	RST	8*01		; SyntaxCheck	
	DEFB	29H		; ')'	
	RET
EVALMINUSTERM:
	
	CALL	EVALTERM
	PUSH	HL
	CALL	FNEGATE
	POP	HL
	RET
EVALVARTERM:
	
	CALL	GETVAR
	PUSH	HL
	EX	DE,HL
	CALL	FLOADFROMMEM
	POP	HL
	RET
EVALINLINEFN:
	
	LD	B,00H
	RLCA
	LD	C,A
	PUSH	BC
	RST	8*02		; RST NextChar	
	CALL	EVALBRACKETED
	EX	(SP),HL
	LD	DE,06F1H
	PUSH	DE
	LD	BC,KW_INLINE_FNS
	ADD	HL,BC
	RST	8*6
	RET
DIMCONTD:
	
	DEC	HL
	RST	8*02		; RST NextChar	
	RET	Z
	RST	8*01		; SyntaxCheck	
	DEFB	2CH		; ','	
DIM:	
	LD	BC,DIMCONTD
	PUSH	BC
	DEFB	0XF6
GETVAR:	
	XOR	A
	LD	(DIM_OR_EVAL),A
	LD	B,(HL)
	CALL	CHARISALPHA
	JP	C,SYNTAXERROR
	XOR	A
	LD	C,A
	RST	8*02		; RST NextChar	
	JP	NC,072EH
	LD	C,A
	RST	8*02		; RST NextChar	
	SUB	'('
	JP	Z,GETARRAYVAR
	PUSH	HL
	LD	HL,(VAR_ARRAY_BASE)
	EX	DE,HL
	LD	HL,(VAR_BASE)
FINDVARLOOP:
	
	RST	8*4
	JP	Z,ALLOCNEWVAR
	LD	A,C
	SUB	(HL)
	INC	HL
	JP	NZ,L0747
	LD	A,B
	SUB	(HL)
L0747:	
	INC	HL
	JP	Z,L0782
	INC	HL
	INC	HL
	INC	HL
	INC	HL
	JP	FINDVARLOOP
ALLOCNEWVAR:
	
	POP	HL		; HL=prog ptr
	EX	(SP),HL		; (SP)=prog ptr, HL=ret.addr.
	PUSH	DE		; 
	LD	DE,06F6H	; An address inside EvalTerm
	RST	8*4		; 
	POP	DE		; 
	JP	Z,ALREADYALLOCD	; 
	EX	(SP),HL		; (SP)=ret.addr, HL=prog ptr.
	PUSH	HL		; Prog ptr back on stack
	PUSH	BC		; Preserve var name on stack
	LD	BC,0006H
	LD	HL,(VAR_TOP)
	PUSH	HL
	ADD	HL,BC
	POP	BC
	PUSH	HL
	CALL	COPYMEMORYUP
	POP	HL
	LD	(VAR_TOP),HL
	LD	H,B
	LD	L,C
	LD	(VAR_ARRAY_BASE),HL
INITVARLOOP:
	
	DEC	HL
	LD	(HL),00H
	RST	8*4
	JP	NZ,INITVARLOOP
	POP	DE
	LD	(HL),E
	INC	HL
	LD	(HL),D
	INC	HL
L0782:	
	EX	DE,HL
	POP	HL
	RET
ALREADYALLOCD:
	
	LD	(FACCUM+3),A	; A was set to zero at 075A.
	POP	HL
	RET
GETARRAYVAR:
	
	PUSH	BC
	LD	A,(DIM_OR_EVAL)
	PUSH	AF
	CALL	GETSUBSCRIPT
	RST	8*01		; SyntaxCheck	
	DEFB	29H		; ')'	
	POP	AF
	LD	(DIM_OR_EVAL),A
	EX	(SP),HL
	EX	DE,HL
	ADD	HL,HL
	ADD	HL,HL
	PUSH	HL
	LD	HL,(VAR_ARRAY_BASE)
	DEFB	0X01		; LXI B,....	
FINDARRAY:
	
	POP	BC
	ADD	HL,BC
	EX	DE,HL
	PUSH	HL
	LD	HL,(VAR_TOP)
	RST	8*4
	EX	DE,HL
	POP	DE
	JP	Z,ALLOCARRAY
	RST	8*6
	EX	(SP),HL
	RST	8*4
	POP	HL
	RST	8*6
	JP	NZ,FINDARRAY
	LD	A,(DIM_OR_EVAL)
	OR	A
	LD	E,12H
	JP	NZ,ERROR
L07BF:	
	POP	DE
	DEC	DE
	EX	(SP),HL
	RST	8*4
	LD	E,10H
	JP	NC,ERROR
	POP	DE
	ADD	HL,DE
	POP	DE
	EX	DE,HL
	RET
ALLOCARRAY:
	
	LD	(HL),E
	INC	HL
	LD	(HL),D
	INC	HL
	LD	DE,002CH
	LD	A,(DIM_OR_EVAL)
	OR	A
	JP	Z,L07E1
	POP	DE
	PUSH	DE
	INC	DE
	INC	DE
	INC	DE
	INC	DE
L07E1:	
	PUSH	DE
	LD	(HL),E
	INC	HL
	LD	(HL),D
	INC	HL
	PUSH	HL
	ADD	HL,DE
	CALL	CHECKENOUGHMEM
	LD	(VAR_TOP),HL
	POP	DE
INITELEMENTS:
	
	DEC	HL
	LD	(HL),00H
	RST	8*4
	JP	NZ,INITELEMENTS
	JP	L07BF
FWORDTOFLOAT:
	
	LD	D,B
	LD	E,00H
	LD	B,90H		; Exponent=2^16
	JP	FCHARTOFLOAT+5	; 
FADDONEHALF:
	
	LD	HL,ONE_HALF	; Load BCDE with (float) 0.5.
FADDMEM:
	CALL	FLOADBCDEFROMMEM
	JP	FADD+2
FSUB:	
	POP	BC		; Get lhs in BCDE.
	POP	DE		; 
	CALL	FNEGATE		; Negate rhs and slimily
	DEFB	0X21		; LXI H,....	;LXI into FAdd + 2.
FADD:	
	POP	BC		; Get lhs in BCDE.
	POP	DE		; 
	LD	A,B		; If lhs==0 then we don't need
	OR	A		; To do anything and can just
	RET	Z		; Exit.
	LD	A,(FACCUM+3)	; If rhs==0 then exit via a copy
	OR	A		; Of lhs to FACCUM.
	JP	Z,FLOADFROMBCDE	; 
	SUB	B		; A=rhs.exponent-lhs.exponent.
	JP	NC,L082C	; If rhs' exponent >= lhs'exponent, jump ahead.
	CPL			; Two's complement the exponent
	INC	A		; Difference, so it's correct.
	EX	DE,HL		; 
	CALL	FPUSH		; Push old rhs
	EX	DE,HL		; 
	CALL	FLOADFROMBCDE	; Rhs = old lhs
	POP	BC		; Lhs = old rhs.
	POP	DE		; 
L082C:	
	PUSH	AF		; Preserve exponent diff
	CALL	FUNPACKMANTISSAS
	LD	H,A		; H=sign relationship
	POP	AF		; A=exponent diff.
	CALL	FMANTISSARTMULT	; Shift lhs mantissa right by (exponent diff) places.
	OR	H		; A=0 after last call, so this tests
	LD	HL,FACCUM	; The sign relationship.
	JP	P,FSUBMANTISSAS	; Jump ahead if we need to subtract.
	CALL	FADDMANTISSAS	; 
	JP	NC,FROUNDUP	; Jump ahead if that didn't overflow.
	INC	HL		; Flip the sign in FTEMP_SIGN.
	INC	(HL)		; 
	JP	Z,OVERFLOW	; Error out if exponent overflowed.
	CALL	FMANTISSARTONCE	; Shift mantissa one place right
	JP	FROUNDUP	; Jump ahead.
FSUBMANTISSAS:
	
	XOR	A		; B=0-B
	SUB	B		; 
	LD	B,A		; 
	LD	A,(HL)		; E=(FACCUM)-E
	SBC	A,E		; 
	LD	E,A		; 
	INC	HL		; 
	LD	A,(HL)		; D=(FACCUM+1)-D
	SBC	A,D
	LD	D,A
	INC	HL
	LD	A,(HL)		; C=(FACCUM+2)-C
	SBC	A,C		; 
	LD	C,A		; 
FNORMALISE:
	
	CALL	C,FNEGATEINT	; 
	LD	H,00H		; 
	LD	A,C		; Test most-significant bit of mantissa
	OR	A		; And jump ahead if it's 1.
	JP	M,FROUNDUP	; 
NORMLOOP:
	
	CP	0XE0		; If we've shifted 32 times,
	JP	Z,FZERO		; Then the number is 0.
	DEC	H		; 
	LD	A,B		; Left-shift extra mantissa byte
	ADD	A,A		; 
	LD	B,A		; 
	CALL	FMANTISSALEFT	; Left-shift mantissa.
	LD	A,H		; 
	JP	P,NORMLOOP	; Loop
	LD	HL,FACCUM+3	; 
	ADD	A,(HL)		; 
	LD	(HL),A		; Since A was a -ve number, that certainly should
	JP	NC,FZERO	; Have carried, hence the extra check for zero.
	RET	Z		; ?why?
FROUNDUP:
	
	LD	A,B		; A=extra mantissa byte
	LD	HL,FACCUM+3	; 
	OR	A		; If bit 7 of the extra mantissa byte
	CALL	M,FMANTISSAINC	; Is set, then round up the mantissa.
	LD	B,(HL)		; B=exponent
	INC	HL		; 
	LD	A,(HL)		; A=FTEMP_SIGN
	AND	0X80		; 
	XOR	C		; Bit 7 of C is always 1. Thi
	LD	C,A		; 
	JP	FLOADFROMBCDE	; Exit via copying BCDE to FACCUM.
FMANTISSALEFT:
	
	LD	A,E
	RLA
	LD	E,A
	LD	A,D
	RLA
	LD	D,A
	LD	A,C
	ADC	A,A
	LD	C,A
	RET
FMANTISSAINC:
	
	INC	E
	RET	NZ
	INC	D
	RET	NZ
	INC	C
	RET	NZ
	LD	C,80H		; Mantissa overflowed to zero, so set it
	INC	(HL)		; To 1 and increment the exponent.
	RET	NZ		; And if the exponent overflows...
OVERFLOW:
	
	LD	E,0AH
	JP	ERROR
FADDMANTISSAS:
	
	LD	A,(HL)
	ADD	A,E
	LD	E,A
	INC	HL
	LD	A,(HL)
	ADC	A,D
	LD	D,A
	INC	HL
	LD	A,(HL)
	ADC	A,C
	LD	C,A
	RET
FNEGATEINT:
	
	LD	HL,FTEMP
	LD	A,(HL)
	CPL
	LD	(HL),A
	XOR	A
	LD	L,A
	SUB	B
	LD	B,A
	LD	A,L
	SBC	A,E
	LD	E,A
	LD	A,L
	SBC	A,D
	LD	D,A
	LD	A,L
	SBC	A,C
	LD	C,A
	RET
FMANTISSARTMULT:
	
	LD	B,00H		; Initialise extra mantissa byte
	INC	A
	LD	L,A
RTMULTLOOP:
	
	XOR	A
	DEC	L
	RET	Z
	CALL	FMANTISSARTONCE
	JP	RTMULTLOOP
FMANTISSARTONCE:
	
	LD	A,C
	RRA
	LD	C,A
	LD	A,D
	RRA
	LD	D,A
	LD	A,E
	RRA
	LD	E,A
	LD	A,B		; NB: B is the extra
	RRA			; Mantissa byte.
	LD	B,A		; 
	RET			; 
FMUL:	
	POP	BC		; Get lhs in BCDE
	POP	DE		; 
	RST	8*05		; FTestSign	;If rhs==0 then exit
	RET	Z		; 
	LD	L,00H		; L=0 to signify exponent add
	CALL	FEXPONENTADD
	LD	A,C
	LD	(FMULINNERLOOP+13),A
	EX	DE,HL
	LD	(FMULINNERLOOP+8),HL
	LD	BC,0000H
	LD	D,B
	LD	E,B
	LD	HL,FNORMALISE+3
	PUSH	HL
	LD	HL,FMULOUTERLOOP
	PUSH	HL
	PUSH	HL
	LD	HL,FACCUM
FMULOUTERLOOP:
	
	LD	A,(HL)		; A=FACCUM mantissa byte
	INC	HL		; 
	PUSH	HL		; Preserve FACCUM ptr
	LD	L,08H		; 8 bits to do
FMULINNERLOOP:
	
	RRA			; Test lowest bit of mantissa byte
	LD	H,A		; Preserve mantissa byte
	LD	A,C		; A=result mantissa's high byte
	JP	NC,L0919	; If that bit of multiplicand was 0, then skip over adding mantissas.
	PUSH	HL		; 
	LD	HL,0000H	; 
	ADD	HL,DE		; 
	POP	DE		; 
	ADC	A,00		; A=result mantissa high byte. This gets back to C
	EX	DE,HL		; In the call to FMantissaRtOnce+1.
L0919:	
	CALL	FMANTISSARTONCE+1
	DEC	L
	LD	A,H		; Restore mantissa byte and
	JP	NZ,FMULINNERLOOP ; Jump back if L is not yet 0.
POPHLANDRETURN:
	
	POP	HL		; Restore FACCUM ptr
	RET			; Return to FMulOuterLoop, or if finished that then exit to FNormalise
FDIVBYTEN:
	
	CALL	FPUSH		; 
	LD	BC,8420H	; BCDE=(float)10;
	LD	DE,0000H
	CALL	FLOADFROMBCDE
FDIV:	
	POP	BC
	POP	DE
	RST	8*05		; FTestSign	 
	JP	Z,DIVIDEBYZERO
	LD	L,0XFF
	CALL	FEXPONENTADD
	INC	(HL)
	INC	(HL)
	DEC	HL
	LD	A,(HL)
	LD	(L095F+1),A
	DEC	HL
	LD	A,(HL)
	LD	(L095F-3),A
	DEC	HL
	LD	A,(HL)
	LD	(L095F-7),A
	LD	B,C
	EX	DE,HL
	XOR	A
	LD	C,A
	LD	D,A
	LD	E,A
	LD	(L095F+4),A
FDIVLOOP:
	
	PUSH	HL
	PUSH	BC
	LD	A,L
	SUB	00H
	LD	L,A
	LD	A,H
	SBC	A,00
	LD	H,A
	LD	A,B
L095F:	
	SBC	A,00
	LD	B,A
	LD	A,00H
	SBC	A,00
	CCF
	JP	NC,L0971
	LD	(L095F+4H),A
	POP	AF
	POP	AF
	SCF
	DEFB	0XD2		; JNC ....	
L0971:	
	POP	BC
	POP	HL
	LD	A,C
	INC	A
	DEC	A
	RRA
	JP	M,FROUNDUP+1
	RLA
	CALL	FMANTISSALEFT
	ADD	HL,HL
	LD	A,B
	RLA
	LD	B,A
	LD	A,(L095F+4H)
	RLA
	LD	(L095F+4H),A
	LD	A,C
	OR	D
	OR	E
	JP	NZ,FDIVLOOP
	PUSH	HL
	LD	HL,FACCUM+3
	DEC	(HL)
	POP	HL
	JP	NZ,FDIVLOOP
	JP	OVERFLOW
FEXPONENTADD:
	
	LD	A,B
	OR	A
	JP	Z,FEXPONENTADD+31
	LD	A,L		; A=0 for add, FF for subtract.
	LD	HL,FACCUM+3	; 
	XOR	(HL)		; XOR with FAccum's exponent.
	ADD	A,B		; Add exponents
	LD	B,A		; 
	RRA			; Carry (after the add) into bit 7.
	XOR	B		; XOR with old bit 7.
	LD	A,B		; 
	JP	P,FEXPONENTADD+30 ; If
	ADD	A,0X80
	LD	(HL),A
	JP	Z,POPHLANDRETURN
	CALL	FUNPACKMANTISSAS
	LD	(HL),A
	DEC	HL
	RET
	OR	A
	POP	HL		; Ignore return address so we'll end
	JP	M,OVERFLOW
FZERO:	
	XOR	A
	LD	(FACCUM+3),A
	RET
FMULBYTEN:
	
	CALL	FCOPYTOBCDE
	LD	A,B
	OR	A
	RET	Z
	ADD	A,02
	JP	C,OVERFLOW
	LD	B,A
	CALL	FADD+2
	LD	HL,FACCUM+3
	INC	(HL)
	RET	NZ
	JP	OVERFLOW
FTESTSIGN_TAIL:
	LD	A,(FACCUM+2)
	DEFB	0XFE
INVSIGNTOINT:
	
	CPL
SIGNTOINT:
	RLA
	SBC	A,A
	RET	NZ
	INC	A
	RET
SGN:	
	RST	8*05		; FTestSign	
FCHARTOFLOAT:
	LD	B,88H		; Ie 2^8
	LD	DE,0000H
	LD	HL,FACCUM+3
	LD	C,A
	LD	(HL),B
	LD	B,00H
	INC	HL
	LD	(HL),80H
	RLA
	JP	FNORMALISE
_ABS:	
	RST	8*05		; FTestSign	
	RET	P
FNEGATE:
	LD	HL,FACCUM+2
	LD	A,(HL)
	XOR	0X80
	LD	(HL),A
	RET
FPUSH:	
	EX	DE,HL
	LD	HL,(FACCUM)
	EX	(SP),HL
	PUSH	HL
	LD	HL,(FACCUM+2)
	EX	(SP),HL
	PUSH	HL
	EX	DE,HL
	RET
FLOADFROMMEM:
	
	CALL	FLOADBCDEFROMMEM
FLOADFROMBCDE:
	EX	DE,HL
	LD	(FACCUM),HL
	LD	H,B
	LD	L,C
	LD	(FACCUM+2),HL
	EX	DE,HL
	RET
FCOPYTOBCDE:
	
	LD	HL,FACCUM
FLOADBCDEFROMMEM:
	LD	E,(HL)
	INC	HL
	LD	D,(HL)
	INC	HL
	LD	C,(HL)
	INC	HL
	LD	B,(HL)
INCHLRETURN:
	
	INC	HL
	RET
FCOPYTOMEM:
	
	LD	DE,FACCUM
	LD	B,04H
FCOPYLOOP:
	
	LD	A,(DE)
	LD	(HL),A
	INC	DE
	INC	HL
	DEC	B
	JP	NZ,FCOPYLOOP
	RET
FUNPACKMANTISSAS:
	
	LD	HL,FACCUM+2
	LD	A,(HL)		; 
	RLCA			; Move FACCUM's sign to bit 0.
	SCF			; Set MSB of FACCUM mantissa,
	RRA			; FACCUM's sign is now in carry.
	LD	(HL),A		; 
	CCF			; Negate FACCUM's sign.
	RRA			; Bit 7 of A is now FACCUM's sign.
	INC	HL		; Store negated FACCUM sign at FTEMP_SIGN.
	INC	HL		; 
	LD	(HL),A		; 
	LD	A,C		; 
	RLCA			; Set MSB of BCDE mantissa,
	SCF			; BCDE's sign is now in carry.
	RRA			; 
	LD	C,A		; 
	RRA			; Bit 7 of A is now BCDE's sign
	XOR	(HL)		; XORed with FTEMP_SIGN.
	RET			; 
FCOMPARE:
	
	LD	A,B
	OR	A
	JP	Z,FTESTSIGN
	LD	HL,INVSIGNTOINT
	PUSH	HL
	RST	8*05		; FTestSign	
	LD	A,C
	RET	Z
	LD	HL,FACCUM+2
	XOR	(HL)
	LD	A,C
	RET	M
	CALL	FISEQUAL
	RRA
	XOR	C
	RET
FISEQUAL:
	
	INC	HL
	LD	A,B
	CP	(HL)
	RET	NZ
	DEC	HL
	LD	A,C
	CP	(HL)
	RET	NZ
	DEC	HL
	LD	A,D
	CP	(HL)
	RET	NZ
	DEC	HL
	LD	A,E
	SUB	(HL)
	RET	NZ		; 
	POP	HL		; Lose 0A5E
	POP	HL		; Lose 09DE
	RET			; Return to caller
FASINTEGER:
	
	LD	B,A		; 
	LD	C,A
	LD	D,A
	LD	E,A
	OR	A
	RET	Z
	PUSH	HL
	CALL	FCOPYTOBCDE
	CALL	FUNPACKMANTISSAS
	XOR	(HL)		; Get sign back
	LD	H,A
	CALL	M,FMANTISSADEC
	LD	A,98H
	SUB	B		; By (24-exponent) places?
	CALL	FMANTISSARTMULT	; WHY?
	LD	A,H
	RLA
	CALL	C,FMANTISSAINC
	LD	B,00H		; Needed for FNegateInt.
	CALL	C,FNEGATEINT
	POP	HL
	RET
FMANTISSADEC:
	
	DEC	DE		; DE--
	LD	A,D		; If DE!=0xFFFF...
	AND	E		; 
	INC	A		; 
	RET	NZ		; ... then return
	DEC	C		; C--
	RET			; 
INT:	
	LD	HL,FACCUM+3	; 
	LD	A,(HL)		; 
	CP	0X98		; 
	RET	NC		; 
	CALL	FASINTEGER	; 
	LD	(HL),98H	; 
	LD	A,C		; 
	RLA			; 
	JP	FNORMALISE	; 
FIN:	
	DEC	HL		; 
	CALL	FZERO		; 
	LD	B,A		; B=count of fractional digits
	LD	D,A		; D=exponent sign
	LD	E,A		; E=exponent
	CPL			; C=decimal_point_done (0xFF for no, 0x00 for yes)
	LD	C,A		; 
FINLOOP:
	RST	8*02		; RST NextChar	
	JP	C,PROCESSDIGIT
	CP	'.'
	JP	Z,L0AE4
	CP	'E'
	JP	NZ,SCALERESULT
GETEXPONENT:
	
	RST	8*02		; RST NextChar	
	DEC	D
	CP	0X99		; KWID_MINUS	
	JP	Z,NEXTEXPONENTDIGIT
	INC	D
	CP	0X98		; KWID_PLUS	
	JP	Z,NEXTEXPONENTDIGIT
	DEC	HL
NEXTEXPONENTDIGIT:
	
	RST	8*02		; RST NextChar	
	JP	C,DOEXPONENTDIGIT
	INC	D
	JP	NZ,SCALERESULT
	XOR	A
	SUB	E
	LD	E,A
	INC	C		; C was 0xFF, so here it
L0AE4:	
	INC	C		; Becomes 0x01.
	JP	Z,FINLOOP	; If C is now zero
SCALERESULT:
	
	PUSH	HL
	LD	A,E
	SUB	B
DECIMALLOOP:
	
	CALL	P,DECIMALSHIFTUP
	JP	P,DECIMALLOOPEND
	PUSH	AF
	CALL	FDIVBYTEN
	POP	AF
	INC	A
DECIMALLOOPEND:
	
	JP	NZ,DECIMALLOOP
	POP	HL
	RET
DECIMALSHIFTUP:
	
	RET	Z
	PUSH	AF
	CALL	FMULBYTEN
	POP	AF
	DEC	A
	RET
PROCESSDIGIT:
	
	PUSH	DE
	LD	D,A
	LD	A,B
	ADC	A,C
	LD	B,A
	PUSH	BC
	PUSH	HL
	PUSH	DE
	CALL	FMULBYTEN
	POP	AF
	SUB	'0'
	CALL	FPUSH
	CALL	FCHARTOFLOAT
	POP	BC
	POP	DE
	CALL	FADD+2
	POP	HL
	POP	BC
	POP	DE
	JP	FINLOOP
DOEXPONENTDIGIT:
	
	LD	A,E
	RLCA
	RLCA
	ADD	A,E
	RLCA
	ADD	A,(HL)
	SUB	'0'
	LD	E,A
	JP	NEXTEXPONENTDIGIT
PRINTIN:
	PUSH	HL
	LD	HL,SZIN
	CALL	PRINTSTRING
	POP	HL
PRINTINT:
	
	EX	DE,HL		; DE=integer
	XOR	A		; A=0 (ends up in C)
	LD	B,98H		; B (ie exponent) = 24
	CALL	FCHARTOFLOAT+5
	LD	HL,PRINTSTRING-1
	PUSH	HL
FOUT:	
	LD	HL,FBUFFER
	PUSH	HL
	RST	8*05		; FTestSign	
	LD	(HL),' '
	JP	P,DOZERO
	LD	(HL),'-'
DOZERO:	
	INC	HL
	LD	(HL),'0'
	JP	Z,NULLTERM-3
	PUSH	HL
	CALL	M,FNEGATE
	XOR	A
	PUSH	AF
	CALL	TOUNDER1000000
TOOVER100000:
	
	LD	BC,9143H	; BCDE=(float)100,000.
	LD	DE,4FF8H	; 
	CALL	FCOMPARE	; If FACCUM >= 100,000
	JP	PO,PREPARETOPRINT ; Then jump to PrepareToPrint.
	POP	AF		; A=DecExpAdj
	CALL	DECIMALSHIFTUP+1 ; FACCUM*=10; DecExpAdj--;
	PUSH	AF		; 
	JP	TOOVER100000
L0B71:	
	CALL	FDIVBYTEN
	POP	AF
	INC	A		; DecExpAdj++;
	PUSH	AF
	CALL	TOUNDER1000000
PREPARETOPRINT:
	
	CALL	FADDONEHALF
	INC	A
	CALL	FASINTEGER
	CALL	FLOADFROMBCDE
	LD	BC,0206H
	POP	AF		; A=DecExpAdj+6.
	ADD	A,C		; 
	JP	M,L0B95		; If A<1 or A>6 Then goto fixme.
	CP	0X07		; 
	JP	NC,L0B95	; 
	INC	A		; 
	LD	B,A		; 
	LD	A,01H		; A=1, indicating scientific notation.
L0B95:	
	DEC	A		; 
	POP	HL		; HL=output buffer
	PUSH	AF		; Preserve decimal exponent adjustment (and preserve zero flag used to
	LD	DE,DECIMAL_POWERS
NEXTDIGIT:
	
	DEC	B
	LD	(HL),'.'
	CALL	Z,INCHLRETURN	; 0A27 just happens to inc HL and RET.
	PUSH	BC		; 
	PUSH	HL		; 
	PUSH	DE		; DE=>decimal power
	CALL	FCOPYTOBCDE	; Store BCDE to FACCUM.
	POP	HL		; HL=>decimal power.
	LD	B,'0'-1		; 
DIGITLOOP:
	
	INC	B		; 
	LD	A,E		; 
	SUB	(HL)		; 
	LD	E,A		; 
	INC	HL		; 
	LD	A,D		; 
	SBC	A,(HL)		; 
	LD	D,A		; 
	INC	HL		; 
	LD	A,C		; 
	SBC	A,(HL)		; 
	LD	C,A		; 
	DEC	HL		; 
	DEC	HL		; 
	JP	NC,DIGITLOOP	; 
	CALL	FADDMANTISSAS	; 
	INC	HL		; ???
	CALL	FLOADFROMBCDE	; 
	EX	DE,HL		; 
	POP	HL		; HL=output buffer
	LD	(HL),B		; 
	INC	HL		; 
	POP	BC		; B=decimal point place
	DEC	C		; C=digits remaining, minus one.
	JP	NZ,NEXTDIGIT	; 
	DEC	B		; 
	JP	Z,L0BDB		; 
L0BCF:	
	DEC	HL		; 
	LD	A,(HL)		; 
	CP	'0'		; 
	JP	Z,L0BCF		; 
	CP	'.'		; 
	CALL	NZ,INCHLRETURN	; 
L0BDB:	
	POP	AF		; 
	JP	Z,NULLTERM	; 
	LD	(HL),'E'	; Write 'E'
	INC	HL		; 
	LD	(HL),'+'	; Write '+' or '-'
	JP	P,L0BEB		; 
	LD	(HL),'-'	; Write '-' if it's negative, also
	CPL			; Two's complement the decimal exponent
	INC	A		; So printing it will work.
L0BEB:	
	LD	B,'0'-1		; 
EXPDIGITLOOP:
	INC	B		; 
	SUB	0AH		; 
	JP	NC,EXPDIGITLOOP	; 
	ADD	A,3AH		; Adding '0'+10 gives us the 2nd digit
	INC	HL		; Of the exponent.
	LD	(HL),B		; Write first digit.
	INC	HL		; 
	LD	(HL),A		; Write second digit of exponent.
	INC	HL		; 
NULLTERM:
	
	LD	(HL),C		; Null byte terminator.
	POP	HL		; 
	RET			; 
TOUNDER1000000:
	
	LD	BC,9474H	; 
	LD	DE,23F7H	; 
	CALL	FCOMPARE	; 
	POP	HL		; 
	JP	PO,L0B71	; 
	JP	(HL)		; 
ONE_HALF:
	DEFB	0X00,0X00,0X00,0X80 ; DD 0.5	 
DECIMAL_POWERS:
	DEFB	0XA0,0X86,0X01	; DT 100000	 
	DEFB	0X10,0X27,0X00	; DT 10000	 
	DEFB	0XE8,0X03,0X00	; DT 1000	 
	DEFB	0X64,0X00,0X00	; DT 100	 
	DEFB	0X0A,0X00,0X00	; DT 10	 
	DEFB	0X01,0X00,0X00	; DT 1	 
SQR:	
	RST	8*05		; FTestSign	;
	JP	M,FUNCTIONCALLERROR ; 
	RET	Z		; 
	LD	HL,FACCUM+3	; 
	LD	A,(HL)		; 
	RRA			; 
	PUSH	AF		; 
	PUSH	HL		; 
	LD	A,40H		; 
	RLA			; 
	LD	(HL),A		; 
	LD	HL,FBUFFER	; 
	CALL	FCOPYTOMEM	; 
	LD	A,04H		; 
SQRLOOP:
	PUSH	AF		; 
	CALL	FPUSH		; 
	LD	HL,FBUFFER	; 
	CALL	FLOADBCDEFROMMEM
	CALL	FDIV+2
	POP	BC
	POP	DE
	CALL	FADD+2
	LD	BC,8000H
	LD	D,C
	LD	E,C
	CALL	FMUL+2
	POP	AF
	DEC	A
	JP	NZ,SQRLOOP
	POP	HL
	POP	AF
	ADD	A,0XC0
	ADD	A,(HL)
	LD	(HL),A
	RET
RND:	
	RST	8*05		; FTestSign	
	JP	M,L0C7C
	LD	HL,RND_SEED
	CALL	FLOADFROMMEM
	RET	Z
	LD	BC,9835H
	LD	DE,447AH
	CALL	FMUL+2
	LD	BC,0X6828
	LD	DE,0XB146
	CALL	FADD+2
L0C7C:	
	CALL	FCOPYTOBCDE
	LD	A,E
	LD	E,C
	LD	C,A
	LD	(HL),80H
	DEC	HL
	LD	B,(HL)
	LD	(HL),80H
	CALL	FNORMALISE+3
	LD	HL,RND_SEED
	JP	FCOPYTOMEM
RND_SEED:
	DEFB	52H, 0C7H, 4FH, 80H
SIN:	
	CALL	FPUSH		; Ush x
	LD	BC,8349H	; CDE=2p
	LD	DE,0FDBH	; 
	CALL	FLOADFROMBCDE	; Hs = 2p
	POP	BC		; Hs = x
	POP	DE		; 
	CALL	FDIV+2		; =x/2p
	CALL	FPUSH		; 
	CALL	INT		; Hs = INT(u)
	POP	BC		; Hs = u
	POP	DE		; 
	CALL	FSUB+2		; =u-INT(u)
	LD	BC,7F00H	; CDE=0.25
	LD	D,C		; 
	LD	E,C		; 
	CALL	FSUB+2		; 
	RST	8*05		; FTestSign	;
	SCF			; Set carry (ie no later negate)
	JP	P,NEGATEIFPOSITIVE ; 
	CALL	FADDONEHALF	; 
	RST	8*05		; 
	OR	A		; Resets carry (ie later negate)
NEGATEIFPOSITIVE:
	
	PUSH	AF		; 
	CALL	P,FNEGATE	; 
	LD	BC,7F00H	; CDE=0.25
	LD	D,C		; 
	LD	E,C		; 
	CALL	FADD+2		; 
	POP	AF		; 
	CALL	NC,FNEGATE	; 
	CALL	FPUSH		; 
	CALL	FCOPYTOBCDE	; 
	CALL	FMUL+2		; = x*x
	CALL	FPUSH		; Ush x*x
	LD	HL,TAYLOR_SERIES ; 
	CALL	FLOADFROMMEM	; 
	POP	BC		; 
	POP	DE		; 
	LD	A,04H		; 
TAYLORLOOP:
	
	PUSH	AF		; Push #terms remaining
	PUSH	DE		; Push BCDE
	PUSH	BC		; 
	PUSH	HL		; 
	CALL	FMUL+2		; 
	POP	HL		; 
	CALL	FLOADBCDEFROMMEM ; 
	PUSH	HL		; 
	CALL	FADD+2		; 
	POP	HL		; 
	POP	BC		; 
	POP	DE		; 
	POP	AF		; Pop #terms remaining into A.
	DEC	A		; Decrement #terms and loop back if not
	JP	NZ,TAYLORLOOP	; One all 4 of them.
	JP	FMUL		; 
TAYLOR_SERIES:
	
	DEFB	0XBA,0XD7,0X1E,0X86 ; DD 39.710670	 
	DEFB	0X64,0X26,0X99,0X87 ; DD -76.574982	 
	DEFB	0X58,0X34,0X23,0X87 ; DD 81.602234	 
	DEFB	0XE0,0X5D,0XA5,0X86 ; DD -41.341675	 
	DEFB	0XDA,0X0F,0X49,0X83 ; DD 6.283185	 
L0D17:	
	DEFB	0X00,0X00,0X00,0X00,0X00,0X00,0X00,0X00,0X00,0X00 ;   DD 6.283185
INIT:	
	; <piotr>	initialise variables
	LD B, VAREND - 8000h
	LD HL, 8000h
	XOR A
.LOOP:
	LD (HL), A
	INC HL
	DEC B
	JR NZ, .LOOP
	
	LD	HL, 0FFFFh	; *** STACK_TOP RELOCATE
	; </piotr>
	LD	SP,HL		; 
	LD	(STACK_TOP),HL	; 
	IN	A,(01)		; 
	LD	C,0XFF		; 
	LD	DE,CONFIGIOCODE	; 
	PUSH	DE		; 
	LD	A,(0FFFH)	; *** RELOCATE
	LD	B,A		; 
	IN	A,(0XFF)	; 
	RRA			; 
	JP	C,L0D42-1	; 
	AND	0CH		; 
	JP	Z,L0D42		; 
	LD	B,10H		; 
	LD	A,B		; 
L0D42:	
	LD	(L0D8D-1),A	; 
	IN	A,(0XFF)	; 
	RLA			; 
	RLA			; 
	LD	B,20H		; 
L0D4B:	
	LD	DE,0XCA02	; 
	RET	C		; 
	RLA			; 
	LD	B,E		; 
	DEC	E		; 
	RET	C		; 
	RLA			; 
	JP	C,L0D6F		; 
	LD	B,E		; 
	LD	DE,0XC280	; 
	RLA			; 
	RET	NC		; 
	RLA			; 
	LD	A,03H		; 
	CALL	L0D8B		; 
	DEC	A		; 
	ADC	A,A		; 
	ADD	A,A		; 
	ADD	A,A		; 
	INC	A		; 
	CALL	L0D8B		; 
	SCF			; 
	JP	L0D4B		; 
L0D6F:	
	XOR	A		; 
	CALL	L0D8B		; 
	CALL	L0D87		; 
	CALL	L0D87		; 
	LD	C,E		; 
	CPL			; 
	CALL	L0D87		; 
	LD	A,04H		; 
	DEC	(HL)		; 
	CALL	L0D8B		; 
	DEC	(HL)		; 
	DEC	(HL)		; 
	DEC	(HL)		; 
L0D87:	
	LD	HL,L0D8D-1	; 
	INC	(HL)		; 
L0D8B:	
	OUT	(00),A		; 
L0D8D:	
	RET			; 
CONFIGIOCODE:
	
	LD	H,D		; 
	LD	L,B		; 
	LD	(INPUTCHAR+3),HL ; 
	LD	A,H		; 
	AND	0XC8		; 
	LD	H,A		; 
	LD	(TESTBREAKKEY+3),HL ; 
	EX	DE,HL		; 
	LD	(WAITTERMREADY+3),HL ; 
	LD	A,(L0D8D-1)	; 
	LD	(INPUTCHAR+1),A	; 
	LD	(TESTBREAKKEY+1),A ; 
	INC	A		; 
	LD	(INPUTCHAR+8),A	; 
	ADD	A,C		; 
	LD	(WAITTERMREADY+1),A ; 
	INC	A		; 
	LD	(INPUTCHAR-2),A	; 
	LD	HL,0XFFFF	; 
	LD	(CURRENT_LINE),HL ; 
	CALL	NEWLINE		; 
	LD	HL,SZMEMORYSIZE	; 
	CALL	PRINTSTRING
	CALL	INPUTLINEWITH
	RST	8*02		; RST NextChar	
	OR	A
	JP	NZ,L0DDE
	LD	HL,UNUSEDMEMORY
FINDMEMTOPLOOP:
	
	INC	HL
	LD	A,37H
	LD	(HL),A
	CP	(HL)
	JP	NZ,DONEMEMSIZE
	DEC	A
	LD	(HL),A
	CP	(HL)
	JP	Z,FINDMEMTOPLOOP
	JP	DONEMEMSIZE
L0DDE:	
	LD	HL,LINE_BUFFER
	CALL	LINENUMBERFROMSTR
	OR	A
	JP	NZ,SYNTAXERROR
	EX	DE,HL
	DEC	HL
DONEMEMSIZE:
	
	DEC	HL
	PUSH	HL
GETTERMINALWIDTH:
	
	LD	HL,SZTERMINALWIDTH
	CALL	PRINTSTRING
	CALL	INPUTLINEWITH
	RST	8*02		; RST NextChar	
	OR	A
	JP	Z,DOOPTIONALFNS
	LD	HL,LINE_BUFFER
	CALL	LINENUMBERFROMSTR
	LD	A,D
	OR	A
	JP	NZ,GETTERMINALWIDTH
	LD	A,E
	CP	0X10
	JP	C,GETTERMINALWIDTH
	LD	(OUTCHAR_TAIL+1),A
CALCTABBRKSIZE:
	
	SUB	0EH
	JP	NC,CALCTABBRKSIZE
	ADD	A,1CH
	CPL
	INC	A
	ADD	A,E
	LD	(TONEXTTABBREAK+4),A
DOOPTIONALFNS:
	
	LD	HL,OPT_FN_DESCS
OPTIONALFNSLOOP:
	
	RST	8*6
	LD	DE,SZWANTSIN
	RST	8*4
	JP	Z,L0E32
	RST	8*6
	EX	(SP),HL
	CALL	PRINTSTRING
	CALL	INPUTLINEWITH
	RST	8*02		; RST NextChar	
	POP	HL
	CP	'Y'
L0E32:	
	POP	DE
	JP	Z,INITPROGRAMBASE
	CP	'N'
	JP	NZ,DOOPTIONALFNS
	RST	8*6
	EX	(SP),HL
	LD	DE,FUNCTIONCALLERROR
	LD	(HL),E
	INC	HL
	LD	(HL),D
	POP	HL
	JP	OPTIONALFNSLOOP
INITPROGRAMBASE:
	
	EX	DE,HL
	LD	(HL),00H
	INC	HL
	LD	(PROGRAM_BASE),HL
	EX	(SP),HL
	LD	DE,0F1AH	; *** RELOCATE STACK_TOP	
	RST	8*4
	JP	C,OUTOFMEMORY
	POP	DE
	LD	SP,HL
	LD	(STACK_TOP),HL
	EX	DE,HL
	CALL	CHECKENOUGHMEM
	LD	A,E
	SUB	L
	LD	L,A
	LD	A,D
	SBC	A,H
	LD	H,A
	LD	BC,0XFFF0
	ADD	HL,BC
	CALL	NEWLINE
	CALL	PRINTINT
	LD	HL,SZVERSIONINFO
	CALL	PRINTSTRING
	LD	HL,PRINTSTRING
	LD	(MAIN+4),HL
	CALL	NEW+1
	LD	HL,MAIN
	LD	(START+2),HL
	JP	(HL)

OPT_FN_DESCS:
	DEFW	L0D17
	DEFW	SZWANTSIN
	DEFW	KW_INLINE_FNS+12
	DEFW	SIN
	DEFW	SZWANTRND
	DEFW	KW_INLINE_FNS+10
	DEFW	RND
	DEFW	SZWANTSQR
	DEFW	KW_INLINE_FNS+8

	DEFW	SQR

SZWANTSIN:
	
	DEFB	57H, 41H, 4EH, 54H, 20H, 53H, 49H, 0CEH, 00H ; DS "WANT SIN\0"
SZWANTRND:
	DEFB	57H, 41H, 4EH, 54H, 20H, 52H, 4EH, 0C4H, 00H ; DS "WANT RND\0"
SZWANTSQR:
	
	DEFB	57H, 41H, 4EH, 54H, 20H, 53H, 51H, 0D2H, 00H ; DS "WANT SQR\0"


SZTERMINALWIDTH:
	
	DEFB	54H, 45H, 52H, 4DH, 49H, 4EH, 41H, 4CH, 20H, 57H, 49H, 44H, 54H, 0C8H, 00H ; 

SZVERSIONINFO:
	
	DEFB	0X20,0X42,0X59,0X54,0X45,0X53,0X20,0X46,0X52,0X45,0XC5,0X0D,0X0D ; DS " BYT
	DEFB	0X42,0X41,0X53,0X49,0X43,0X20,0X56,0X45,0X52,0X53,0X49,0X4F,0X4E,0X20,0X33
	DEFB	0XB2,0X0D,0X5B,0X34,0X4B,0X20,0X56,0X45,0X52,0X53,0X49,0X4F,0X4E,0XDD,0X0D
SZMEMORYSIZE:
	
	DEFB	0X4D,0X45,0X4D,0X4F,0X52,0X59,0X20,0X53,0X49,0X5A,0XC5,0X00 ; DS "MEMORY SI



UNUSEDMEMORY DB 0