; editor

FileLine	equ PROGRAM_DATA + 00h	; 2 bytes
ScreenLine	equ PROGRAM_DATA + 02h
StartLine	equ PROGRAM_DATA + 03h	; 2 bytes
CursorLine  equ PROGRAM_DATA + 05h

EdLineBuff	equ PROGRAM_DATA + 06h	; 256 bytes for line read from a file


ed_main:
	CALL ed_init
	CALL str_shift
	CALL str_len
	CP 0
	JR Z, .newFile
.loadFile:
	CALL dos_loadFile
	LD A, (DosErr)
	CP DOS_OK
	JR NZ, .error
	LD A, 0
	LD (StartLine), A
	LD (StartLine + 1), A
	CALL ed_showPage
	JR .loop
.newFile:
	; TODO
	JR .loop
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
.error:
	CALL dos_getStatusMsg
	CALL writeLn
	RET

ed_init:
	LD A, 0
	LD (FileLine), A
	LD (FileLine + 1), A
	LD (ScreenLine), A
	LD (StartLine), A
	LD (StartLine + 1), A
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
	CP 'u'
	CALL Z, ed_up
	CP 'd'
	CALL Z, ed_down
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

; displays the file starting from a specified line
; starting line number passed in StartLine
ed_showPage:
	CALL clrScr				; clear the screen first
	LD A, (StartLine)
	LD C, A
	LD A, (StartLine + 1)
	LD B, A
	LD A, 0
	LD (FileLine), A		; initialise the FileLine to 0
	LD (FileLine + 1), A
	CALL dos_reset
	LD IX, EdLineBuff
.lineLoop:					; skipping the first BC lines
	LD HL, (FileLine)
	CALL u16_cmp			; check if current line matches the specified starting line
	CP 0
	JR Z, .show				; if yes, start displaying the file starting from this line
	INC HL					; otherwise move to the next line
	LD (FileLine), HL	
	CALL dos_fReadLn
	JR .lineLoop			
.show:
	LD A, 0
	LD (ScreenLine), A
	LD IX, EdLineBuff
.showLoop:
	CALL dos_fReadLn		
	CALL writeLn
	LD A, (ScreenLine)
	CP MAX_Y - 1
	JR Z, .end
	INC A
	LD (ScreenLine), A
	CALL dos_eof
	CP TRUE
	JR Z, .end
	JR .showLoop
.end:
	RET

ed_down:
	LD HL, (StartLine)
	INC HL
	LD (StartLine), HL
	CALL ed_showPage
	RET

ed_up:
	LD HL, (StartLine)
	LD B, 0
	LD C, 0
	CALL u16_cmp
	CP 0
	JR Z, .end
	DEC HL
	LD (StartLine), HL
	CALL ed_showPage
.end:
	RET

ed_fReadLn:
	LD IX, EdLineBuff
	CALL dos_fReadLn
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

	