; editor

FileLine	equ PROGRAM_DATA + 00h	; 2 bytes
ScreenLine	equ PROGRAM_DATA + 02h
StartLine	equ PROGRAM_DATA + 03h	; 2 bytes

PROC
ed_main:
	CALL ed_init
_loop:
	LD B, 0
	LD C, MAX_Y
	CALL gotoXY
	LD IX, Blank
	CALL writeStr
	CALL gotoXY
	CALL readLine
	LD IX, LineBuff
	CALL ed_processCmds
	CP TRUE
	JR Z, _loop
	LD B, 0
	LD A, (ScreenLine)
	LD C, A
	CALL gotoXY
_loop2:
	LD A, (IX)
	CP 0
	JR Z, _endLoop2
	CALL putChar
	CALL dos_fWrite
	INC IX
	JR _loop2
_endLoop2:
	LD A, CR
	CALL dos_fWrite
	CALL nextLine
	LD A, (ScreenLine)
	INC A
	LD (ScreenLine), A
	JR _loop
	RET
ENDP

ed_init:
	CALL str_shift
	LD IY, CurrentFileName
	CALL str_copy
	LD A, 0
	LD (FileLine), A
	LD (FileLine + 1), A
	LD (ScreenLine), A
	LD (StartLine), A
	LD (StartLine + 1), A
	LD (CurrentFileSize), A
	LD (CurrentFileSize + 1), A
	LD HL, 0
	CALL dos_seek
	CALL clrScr
	RET

PROC
ed_processCmds:
	LD A, (IX)
	CP ':'
	JR NZ, _noCmd
	LD A, (IX + 1)
	CP ':'
	JR Z, _esc
	CP 'q'
	JR Z, _exit
	CP 'w'
	CALL Z, dos_saveFile
	LD A, TRUE
	RET
_noCmd:
	LD A, FALSE
	RET
_esc:
	LD A, False
	INC IX
	RET
_exit:
	POP IX	; jumping one routne level up
	CALL nextLine
	RET
ENDP
	
ed_showPage:
	LD A, 0
	;
	RET
	