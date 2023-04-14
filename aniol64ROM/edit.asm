; editor

FileLine		equ PROGRAM_DATA + 00h	; 2 bytes
ScreenLine		equ PROGRAM_DATA + 02h
StartLine		equ PROGRAM_DATA + 03h	; 2 bytes, line of the file from which the screen starts
CursorLine  	equ PROGRAM_DATA + 05h 	; in which line of the screen the cursor is
CursorFileLine 	equ PROGRAM_DATA + 06h	; 2 bytes
TotalLines 		equ PROGRAM_DATA + 08h  ; 2 bytes; total number of lines in the file
CurrentAddr		equ PROGRAM_DATA + 0Ah	; 2 bytes
CursorAddr		equ PROGRAM_DATA + 0Ch	; 2 bytes address in memory into the file area where the cursor is
LineLen			equ PROGRAM_DATA + 0Eh	; length of the currently processed line, including the CR char
EofAddr			equ PROGRAM_DATA + 0Fh	; 2 bytes address of the end of the file
NewEofAddr		equ PROGRAM_DATA + 11h	; 2 bytes address of the end of the file after a new line is inserted
NewBlockAddr	equ PROGRAM_DATA + 13h
EdLineBuff		equ PROGRAM_DATA + 100h	; 256 bytes for line read from a file

PressAnyKey:	defb ". Press any key", 0


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
	CALL ed_computeTotalLines
	JR .loop
.newFile:
	CALL ed_newFile
	JR .loop
.loop:
	CALL ed_showPage
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
	CALL ed_processLine
	JR .loop
.error:
	CALL dos_getStatusMsg
	CALL writeLn
	RET

; initialises the editor
ed_init:
	PUSH HL
	LD A, 0
	LD (FileLine), A
	LD (FileLine + 1), A
	LD (ScreenLine), A
	LD (StartLine), A
	LD (StartLine + 1), A
	LD (CursorLine), A
	LD HL, FileBuffer
	LD (CursorAddr), HL
	CALL clrScr
	POP HL
	RET

; checks if the currently entered line is a command
; if it is, executes the command
; returns a boolean value in A 
; indicating if a command was executed
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
	CP 'k'
	CALL Z, ed_upMulti
	CP '8'
	CALL Z, ed_upMulti
	CP 'n'
	CALL Z, ed_downMulti
	CP '2'
	CALL Z, ed_downMulti
	CP 'd'
	CALL Z, ed_eraseMulti
	CP 'h'
	CALL Z, ed_home
	CP 'e'
	CALL Z, ed_end
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
	LD BC, (StartLine)
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
	LD B, 0				; counting screen lines in B
.showLoop:
	LD A, (CursorLine)
	CP B				; if current line matches the cursor line...
	JR Z, .cursor		; ...draw cursor
	LD A, '~'			; otherwise draw beginning of line marker
	JR .cont
.cursor:
	LD A, '*'
.cont:
	CALL putChar
	CALL dos_eof
	CP TRUE
	JR Z, .end
	CALL dos_fReadLn		
	CALL writeLn
	INC B				; count lines
	LD A, (ScreenLine)
	CP MAX_Y - 1
	JR Z, .end
	INC A
	LD (ScreenLine), A
	JR .showLoop
.end:
	RET

ed_computeTotalLines:
	LD HL, 0x0000
	LD (TotalLines), HL
	LD HL, FileBuffer
	LD (CurrentAddr), HL
	LD BC, (CurrentFileSize)
.loop:
	LD HL, (CurrentAddr)
	LD A, CR
	CPIR
	LD (CurrentAddr), HL
	LD HL, 0x0000
	CALL u16_cmp
	CP 0
	JR Z, .end
	LD HL, (TotalLines)
	INC HL
	LD (TotalLines), HL
	JR .loop
.end:
	RET

ed_downMulti:
	INC IX
	INC IX
	CALL str_len
	CP 0
	JR NZ, .multi
	LD B, 1
	JR .loop
.multi
	CALL u16_parseDec
	CP OK
	RET NZ 				; return if there is a parse error
	LD B, L
.loop:
	CALL ed_down
	DJNZ .loop
	RET

; moves the cursor down the screen
ed_down:
	CALL ed_isAppend
	CP TRUE
	RET Z 				; if yes, do nothing
	LD A, (CursorLine)
	CP MAX_Y - 1		; check if the cursor is in the last line of the screen
	JR Z, .scroll		; if yes, scroll the screen
	INC A				; otherwise move the cursor
	LD (CursorLine), A
	RET
.scroll:
	LD HL, (StartLine)
	INC HL				; otherwise increase the start line	
	LD (StartLine), HL
	
	
ed_upMulti:
	INC IX
	INC IX
	CALL str_len
	CP 0
	JR NZ, .multi
	LD B, 1
	JR .loop
.multi
	CALL u16_parseDec
	CP OK
	RET NZ 				; return if there is a parse error
	LD B, L
.loop:
	CALL ed_up
	DJNZ .loop
	RET

; moves the cursor up the screen
ed_up:
	LD A, (CursorLine)
	CP 0				; check if the cursor is in the first line of the screen
	JR Z, .scroll		; if yes, try scrolling the screen
	DEC A				; otherwise move the cursor
	LD (CursorLine), A
	RET
.scroll:
	LD HL, (StartLine)
	LD B, 0
	LD C, 0
	CALL u16_cmp		; check if the file is displayed from the first line already
	CP 0				; if yes, there's nowhere to go, we're already at the top
	RET Z				; so do nothing
	DEC HL				; otherwise decrease the start line	
	LD (StartLine), HL
	RET

; reads a line from a file into EdLineBuff
ed_fReadLn:
	LD IX, EdLineBuff
	CALL dos_fReadLn
	RET

; saves the file buffer to disk
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
	LD B, 0
	LD C, MAX_Y
	CALL gotoXY
	CALL writeStr
	LD IX, PressAnyKey
	CALL writeLn
	CALL readKey
	RET

ed_processLine:
	CALL ed_isAppend
	PUSH AF
	POP AF
	CP TRUE
	JR Z, .append
	CALL ed_insertLine
	RET
.append:
	CALL ed_appendLine
	RET
	
; checks if cursor is beyond the last line of the file
; result in A	
ed_isAppend:	
	PUSH BC
	LD HL, (StartLine)
	LD B, 0
	LD A, (CursorLine)
	LD C, A
	ADD HL, BC	
	LD (CursorFileLine), HL	; computed in which line of the file the cursor is
	LD BC, (TotalLines)
	CALL u16_cmp			; check if we're beyind the last line of the file
	CP 0
	JR Z, .append
	LD A, FALSE
	JR .end
.append:
	LD A, TRUE
.end:
	POP BC
	RET

; computes the address to which the cursor points
; result in CursorAddr
ed_computeCursorAddress:
	CALL ed_isAppend
	CP TRUE					; if yes, just find the address of the end of the file
	JR NZ, .cont			; if not, compute the actual address
	LD HL, FileBuffer
	LD BC, (CurrentFileSize)
	ADD HL, BC				; add file size to the address of the beggining of the file buffer...
	LD (CursorAddr), HL		; ... to find the address one beyond the end of the file
	RET			
.cont:
	LD A, 0
	LD (FileLine), A
	LD (FileLine + 1), A
	LD HL, FileBuffer		; start scanning at the beginning of the file buffer
.loop:
	LD (CurrentAddr), HL
	LD HL, (FileLine)
	LD BC, (CursorFileLine)
	CALL u16_cmp
	CP 0					; check if FileLine equals CurFileLine
	JR Z, .end
	INC HL					; increment the FileLine
	LD (FileLine), HL
	LD HL, (CurrentAddr)
	LD BC, 0xFFFF			; we don't want any limit to how far we search
	LD A, CR
	CPIR
	JR .loop
.end
	LD HL, (CurrentAddr)
	LD (CursorAddr), HL
	RET

; computes the length of a line within the file buffer
; beginning of line passed in HL
; result in A
ed_lineLen:
	PUSH HL
	LD B, 0
.loop:
	LD A, (HL)
	CP 0
	JR Z, .end
	CP CR
	JR Z, .end
	INC B
	INC HL
	JR .loop
.end:
	INC B
	LD A, B
	POP HL
	RET

ed_computeLineLen:
	LD IX, LineBuff
	CALL str_len
	INC A					; add one byte for the CR character
	LD (LineLen), A			; store the length of the line
	RET

ed_appendLine:
	CALL ed_computeLineLen
	CALL ed_computeCursorAddress
	CALL ed_addLine
	RET

ed_insertLine:
	CALL bzr_click
	CALL ed_computeLineLen
	LD HL, FileBuffer
	LD BC, (CurrentFileSize)
	DEC HL					; I think
	ADD HL, BC
	LD (EofAddr), HL		; store the address of the last chracter in the file 
	LD B, 0
	LD C, A					; A still contains the line length
	ADD HL, BC
	LD (NewEofAddr), HL		; store address of the end of the file after the line is inserted
	CALL ed_computeCursorAddress
	LD HL, (EofAddr)
	LD BC, (CursorAddr)
	SUB HL, BC				; compute the size of the file from the cursor position to the eond of file...
	INC HL
	PUSH HL					; ... i.e. the size of the block to move
	POP BC					; transfer the block size to BC to use as the counter
	LD DE, (NewEofAddr)
	LD HL, (EofAddr)
	LDDR					; copy the block over by the length of the line
	CALL ed_addLine
	RET

ed_addLine:
	LD HL, (CursorAddr)
	LD IX, LineBuff
	LD A, (LineLen)
	LD B, A					; use as loop counter; includes all characters of the line, including the null terminator
.loop:						; copy the newly entered line from the line buffer to the file buffer
	LD A, (IX)
	LD (HL), A
	INC IX
	INC HL
	DJNZ .loop				; end of loop
	LD A, CR				; line is terminated by a null-character
	DEC HL					; go back over the null terminator char
	LD (HL), A				; and put there a CR instead
	LD HL, (TotalLines)
	INC HL
	LD (TotalLines), HL		; increase total number of lines by 1
	LD HL, (CurrentFileSize)
	LD B, 0
	LD A, (LineLen)
	LD C, A
	ADD HL, BC
	LD (CurrentFileSize), HL	; increase the file size by the length of the inserted line
	CALL ed_down				; move to the next line
	RET

ed_eraseMulti:
	INC IX
	INC IX
	CALL str_len
	CP 0
	JR NZ, .multi
	LD B, 1
	JR .loop
.multi
	CALL u16_parseDec
	CP OK
	RET NZ 				; return if there is a parse error
	LD B, L
.loop:
	CALL ed_eraseLine
	DJNZ .loop
	RET

ed_eraseLine:
	PUSH BC
	CALL ed_computeCursorAddress
	LD HL, (CursorAddr)
	CALL ed_lineLen
	LD (LineLen), A
	LD B, 0
	LD C, A
	ADD HL, BC
	LD (NewBlockAddr), HL
	LD HL, (CurrentFileSize)
	LD BC, FileBuffer
	ADD HL, BC
	LD BC, (CursorAddr)
	SUB HL, BC
	LD B, 0
	LD A, (LineLen)
	LD C, A
	SUB HL, BC
	PUSH HL
	POP BC
	LD HL, (NewBlockAddr) 
	LD DE, (CursorAddr)
	LDIR
	LD HL, (CurrentFileSize)
	LD B, 0
	LD A, (LineLen)
	LD C, A
	SUB HL, BC
	LD (CurrentFileSize), HL
	LD HL, (TotalLines)
	DEC HL
	LD (TotalLines), HL
	POP BC
	RET

ed_home:
	LD A, 0
	LD (CursorLine), A
	LD HL, 0000h
	LD (StartLine), HL
	RET

ed_newFile:					; TODO, perhaps this should be part of DOS
	LD A, 0
	LD (TotalLines), A
	LD HL, 0000h
	LD (CurrentFileSize), HL
	LD (StartLine), HL
	RET

; puts the cursor one line beyond the last line of the file
; i.e. puts the editor in append mode (ed_isAppend will return TRUE after a call to this routine)
; the routine does one of two things:
; 	-	if the entire file fits on the screen, it will set up the display
;	so that the file is displayed from the top of the screen and the cursor
; 	is displayed after the last line of the file
; 	- if the file has more lines than the usable screen area (screen minus the command line),
; 	it will set up the display so that the last lines of the file fill all but one line of the 
; 	usable screen area, and the cursor is in the very last line before the command line
ed_end:
	LD HL, (TotalLines)
	LD B, 0
	LD C, MAX_Y - 1
	SUB HL, BC
	LD A, H
	AND 10000000b		; isolate the negative sign
	CP 0				; check if result is negative
	LD A, MAX_Y - 1		; preload A with the height of the screen, for the cursor to go in the last line above the command line
	JR Z, .skip			; checking the result of the comparison 2 lines above
	LD HL, 0000h		; if it is negative, use zero instead
	LD A, (TotalLines)	; if this occurs, TotalLines will fit into one byte
.skip:
	LD (StartLine), HL
	LD (CursorLine), A
	RET
