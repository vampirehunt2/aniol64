; editor

FileLine	equ PROGRAM_DATA + 00h	; 2 bytes
ScreenLine	equ PROGRAM_DATA + 02h
StartLine	equ PROGRAM_DATA + 03h	; 2 bytes


ed_main:
	CALL ed_init
.loop:
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
	JR Z, .loop
	LD B, 0
	LD A, (ScreenLine)
	LD C, A
	CALL gotoXY
.loop2:
	LD A, (IX)
	CP 0
	JR Z, .endLoop2
	CALL putChar
	CALL dos_fWrite
	INC IX
	JR .loop2
.endLoop2:
	LD A, CR
	CALL dos_fWrite
	CALL nextLine
	LD A, (ScreenLine)
	CP MAX_Y - 1
	JR Z, .scroll
	INC A
	LD (ScreenLine), A
	JR .cont:
.scroll:
	CALL scroll
.cont:
	JR .loop
	RET


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


ed_processCmds:
	LD A, (IX)
	CP ':'
	JR NZ, .noCmd
	LD A, (IX + 1)
	CP ':'
	JR Z, .esc
	CP 'q'
	JR Z, .exit
	CP 'w'
	CALL Z, ed_save
	LD A, TRUE
	RET
.noCmd:
	LD A, FALSE
	RET
.esc:
	LD A, FALSE
	INC IX
	RET
.exit:
	POP IX	; jumping one routine level up (EVIL)
	CALL nextLine
	RET

	
ed_showPage:
	LD A, 0
	;
	RET

ed_save:
	CALL str_tok
	CALL str_shift
	CALL str_len	
	CP 0
	JR Z, .save
	LD IY, CurrentFileName
	CALL str_copy
.save:
	CALL dos_saveFile
; error checking:
	LD A, (DosErr)
	CP DOS_OK
	RET Z
	LD B, 0
	LD C, MAX_Y
	CALL gotoXY
	LD IX, Blank
	CALL writeStr
	CALL dos_getStatusMsg
	CALL writeStr
	RET

	