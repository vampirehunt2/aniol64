; system calls for APL

ParseError:     defb "Parse error", 0

; #################### Console functions ########################


; Writes a decimal number to screen
; procedure
; syntax: Write <Expression>
sys_write:
    CALL run_evaluate
    CP 0
    JP NZ, run_syntaxError
    LD HL, (Expression + 1)
    LD IX, LineBuff 
    CALL i16_formatDec
    CALL trimDec
    CALL writeStr
    RET


sys_writeh:
    CALL run_evaluate
    CP 0
    JP NZ, run_syntaxError
    LD HL, (Expression + 1)
    LD IX, LineBuff 
    CALL u16_formatHex
    CALL writeStr
    RET

sys_writeb:
    CALL run_evaluate
    CP 0
    JP NZ, run_syntaxError
    LD A, (Expression + 1)
    CP 0
    JR NZ, .true
    LD A, (Expression + 2)
    CP 0
    JR NZ, .true
    LD IX, FALSE_STR
    JR .cont
.true:
    LD IX, TRUE_STR
.cont:
    CALL writeStr
    RET

; reads a line of text from the keyboard into a variable
; procedure
; syntax: ReadS <Variable>
sys_readString:
    CALL cursorOn
    CALL readLine
    LD IX, LineBuff
    CALL nextLine
    CALL _apl_getVar    ; get variable to which to read the string 
    LD C, (HL)          ; put the value of the variable...
    INC HL              ; ... (i.e. address of the string)...            
    LD B, (HL)          ; ...in BC  
    PUSH BC             ; copy BC...
    POP IY              ; ... to IY
    CALL str_copy       ; copy the string that was read in to the memory area pointed to by IY (and therefore HL)
    RET

; reads a 16-bit number from the keyboard into a variable
; procedure
; syntax: Read <Variable>
sys_read:
    CALL cursorOn
    PUSH HL             ; store the pointer into the statement bytecode on the stack
    CALL readLine
    CALL nextLine
    LD IX, LineBuff
    LD A, (IX)
    CP '$'              ; check if user entered a hex value
    JR Z, .hex
    CALL i16_parseDec
    CP 0                ; check for parse errors
    JR NZ, .parseErr
    JR .cont
.hex:
    CALL u16_parseHex
    CP 0                ; check for parse errors
    JR NZ, .parseErr
.cont:
    LD D, H             ; store the read value in DE for safekeeping
    LD E, L
    POP HL              ; restore the pointer into the statement bytecode from the stack
    CALL _apl_getVar
    LD (HL), DE
    RET
.parseErr:
    POP HL
    LD IX, ParseError
    CALL writeLn
    JR sys_read

; Makes a beep sound on the system speaker
; procedure
; syntax: Beep
sys_beep:
    CALL bzr_beep
    RET

; Makes a click sound on the system speaker
; procedure
; syntax: Click
sys_click:
    CALL bzr_click
    RET

; Moves the cursor to the beggining of next line on the screen
; procedure
; syntax: NewLn
sys_nextLn:
    CALL nextLine
    RET

; Returns the maximum horizontal position of a character on screen (Screen width minus 1)
; function
; syntax: MaxX()
sys_maxX:
    LD L, MAX_X
    LD H, 0
    RET

; Returns the maximum vertical position of a character on screen (Screen height minus 1)
; function
; syntax: MaxY()
sys_maxY:
    LD L, MAX_Y
    LD H, 0
    RET

; moves the cursor to the given screen coordinates
; procedure
; syntax: GotoXY <Expression>, <Expression>
; argument1: Column (8bit)
; argument2: Row (8bit)
sys_gotoxy:
    CALL run_evaluate           ; evaluate the X coefficient
    CP 0                        ; check if a valid expression
    JP NZ, run_syntaxError      ; if not, report error
    LD A, (Expression + 1)      ; load the X coefficient to B...
    LD B, A                     ; ...ignoring the higher byte
    CALL run_evaluate           ; evaluate the Y coefficient
    CP 0                        ; check if a valid expression
    JP NZ, run_syntaxError      ; if not, report error
    LD A, (Expression + 1)      ; load the Y coefficient to C...
    LD C, A                     ; ...ignoring the higher byte
    call gotoXY
    RET

; puts a character on the screen
; procedure
; syntax: PutChar <Expression>
; argument1: character to print (8bit)
sys_putChar:
    CALL run_evaluate           ; evaluate the character
    CP 0                        ; check if a valid expression
    JP NZ, run_syntaxError      ; if not, report error
    LD A, (Expression + 1)      ; load the character ASCII code to A
    call putChar
    RET

sys_getChar:
    ; ignores the parameter
    CALL getChar
    LD L, A
    LD H, 0
    RET

sys_readKey:
    ; ignores the parameter
    CALL readKey
    LD L, A
    LD H, 0
    RET

; clear the screen
; procedure
; syntax: ClrScr
sys_clrScr:
    CALL clrScr
    CALL home
    RET

; show the cursor
; procedure
; syntax: ShowCursor
sys_showCursor:
    CALL cursorOn
    RET

; hide the cursor
; procedure
; syntax: HideCursor
sys_hideCursor:
    CALL cursorOff
    RET

sys_keyPressed:
    CALL keyPressed
    JR Z, .no
    LD H, TRUE
    LD L, TRUE
    RET
.no:
    LD H, FALSE
    LD L, FALSE
    RET


; #################### Math functions ########################

; Returns absolute value of an expression
; function
; syntax: Abs(<Expression>)
sys_abs:
    CALL i16_abs
    RET

; Returns a random 8-bit number from 0 to (argument - 1)
; function
; syntax: Rnd(<Expression>)
sys_rnd:
    LD C, L
    CALL rndMod
    LD H, 0
    LD L, A
    RET


; #################### Miscallenous functions ########################

; Stops the program execution for approximately (argument * 10ms)
; procedue
; syntax: Delay <Expression>
sys_delay:
    CALL run_evaluate
    CP 0
    JP NZ, run_syntaxError
    LD A, (Expression + 1)  ; only use the lower bit of the argument
    CALL delay
    RET


; switches the memory bank in the top 16k of memory
; procedure
; syntax: Bank <Expression>
; argument1: number of the bank to switch in
sys_switchBank:
    CALL run_evaluate
    CP 0
    JP NZ, run_syntaxError
    LD A, L
    CALL mem_switchBank
    RET

; Calls a machine code procedure
; function
; syntax: Call(<Expression>)
; argument1: the address of the procedure
; returns whatever value the machine code procedure left in the HL register.
sys_call:
    CALL _sys_jumpTo
    RET

; 8-bit peek of a memory location pointed to by the argument
; function
; syntax: Peek(<Expression>)
; argument1: Address (16bit)
sys_peek:
    PUSH IX
    PUSH HL
    POP IX
    LD H, 0
    LD L, (IX)
    POP IX
    RET

; 8-bit poke
; procedure
; syntax: Poke <Expression>, <Expression>
; argument1: Address (16bit)
; argument2: Value  (8bit)
sys_poke:
    CALL run_evaluate
    CP 0
    JP NZ, run_syntaxError
    LD IY, (Expression + 1)
    CALL run_evaluate
    CP 0
    JP NZ, run_syntaxError
    LD A, (Expression + 1)      ; load lower byte of the expression, ignore the higher byte
    LD (IY), A
    RET

; one-byte get
; port number is one byte, passed in L
; function
; syntax Get(<Expression>)
; argument1: port number
; returns: a byte read from the port
sys_get:
    LD C, L
    IN A, (C)
    LD L, A
    LD H, 0
    RET

; Writes a byte to a port
; procedure
; syntax: Put <Expression>, <Expression>
; argument1: port number (8bit)
; argument2: value to write (8bit)
sys_put:
    CALL run_evaluate
    CP 0
    JP NZ, run_syntaxError
    LD A, (Expression + 1)      ; load lower byte of the expression, ignore the higher byte
    LD C, A
    CALL run_evaluate
    CP 0
    JP NZ, run_syntaxError
    LD A, (Expression + 1)      ; load lower byte of the expression, ignore the higher byte
    OUT (C), A
    RET


; #################### String functions ########################

; TODO incomplete
sys_startsWith:
    CALL run_evaluate
    CP 0
    JP NZ, run_syntaxError
    LD IY, (Expression + 1)      
    CALL run_evaluate
    CP 0
    JP NZ, run_syntaxError
    LD IX, (Expression + 1)      
    CALL str_startsWith
    PUSH AF
    CALL _apl_getVar
    POP AF
    LD (HL), A
    INC HL
    LD (HL), A
    RET
    
; Writes a string to the screen
; procedure
; syntax: WriteS <Expression>
; argument1: string to write, either pointer or string constant
sys_writeString:
    CALL run_evaluate
    CP 0
    JP NZ, run_syntaxError
    LD IX, (Expression + 1)
    CALL writeStr
    RET

sys_upper:
    CALL run_evaluate
    CP 0
    JP NZ, run_syntaxError
    LD IX, (Expression + 1)
    CALL str_toUpper
    RET

sys_lower:
    CALL run_evaluate
    CP 0
    JP NZ, run_syntaxError
    LD IX, (Expression + 1)
    CALL str_toLower
    RET

; returns the length of a string
; function
; syntax Len(<Expression>)
; argument1: the string
; returns the length of the string, not including the terminating zero
sys_len:
    PUSH IX
    PUSH HL
    POP IX
    CALL str_len
    LD L, A
    LD H, 0
    POP IX
    RET

; removes trailing spaces from a string
; does not change the string address
; procedure
; syntax: Trim <Expression>
; argument1: string to trim
sys_trim:
    CALL run_evaluate
    CP 0
    JP NZ, run_syntaxError
    LD IX, (Expression + 1)
    CALL str_rtrim
    RET


; tokenizes a string
; modifies the input string to end at the end of the first token 
; function
; syntax: Tok(<Expression>)
; argument1: string to tokenise
; returns: a pointer to the beginning of the second token of the input string
sys_tok:
    PUSH HL
    POP IX
    CALL str_tok
    RET

; produces a substring from a string.
; note that the input string gets modified.
; procedure
; syntax: SubStr <Expression>, <Expression>, <Expression>, <Variable>
; argument1: input string
; argument2: starting index. If larger than the length of the input string, an empty string is returned
; argument3: maximum length of the substring. If starting index + maximum length 
;            are larger than the length of the input string
;            the output string is truncated at the end of the input string
; argument4: output variable 
sys_subStr:
    CALL run_evaluate
    CP 0
    JP NZ, run_syntaxError
    LD IX, (Expression + 1)
    PUSH IX
    CALL run_evaluate
    CP 0
    JP NZ, run_syntaxError
    LD A, (Expression + 1)
    LD B, A
    CALL run_evaluate
    CP 0
    JP NZ, run_syntaxError
    LD A, (Expression + 1)
    LD C, A
    POP IX
    CALL str_sub
    PUSH IX
    CALL _apl_getVar
    POP BC
    LD (HL), C          
    INC HL                      
    LD (HL), B          
    RET

; compares two strings
; procedure
; syntax: Cmp <Expression>, <Expression>, <Variable>
; argument1: first string to compare
; argument2: second string to compare
; argument3: a variable in which the result is stored
; the result is a boolean value
sys_cmp:
    CALL run_evaluate
    CP 0
    JP NZ, run_syntaxError
    LD IY, (Expression + 1)      
    CALL run_evaluate
    CP 0
    JP NZ, run_syntaxError
    LD IX, (Expression + 1)
    CALL str_cmp
    PUSH AF
    CALL _apl_getVar
    POP AF
    CP 0
    JR Z, .equal
    LD (HL), FALSE
    INC HL
    LD (HL), FALSE
    RET
.equal:
    LD (HL), TRUE
    INC HL
    LD (HL), TRUE
.end:
    RET

    
; copies a string to a buffer
; procedure
; syntax: Copy <Expression>, <Expression>
; argument1: target buffer address
; argument2: source string
sys_copy:
    CALL run_evaluate
    CP 0
    JP NZ, run_syntaxError
    LD IY, (Expression + 1)      
    CALL run_evaluate
    CP 0
    JP NZ, run_syntaxError
    LD IX, (Expression + 1)
    CALL str_copy
    RET



; #################### DOS functions ########################

; Open a file from disk and load it to the file buffer
; function
; syntax: Open(<Expression>)
; argument1: filename
; returns True if the operation is successful and False when there's an error.
; in the latter case, it sets DosErr
sys_open:  
    PUSH HL                     
    POP IX                      ; transfer file name pointer to IX
	CALL dos_loadFile           ; load the file
	JP _sys_return

    
; Returns the DOS error status
; Error code or 0 for no error
; function
; syntax: DosErr(<Expression>)
; argument1: boolean value indicating whether the error should be cleared
sys_dosError:
    LD A, L         ; load the clear argument to A
    LD HL, (DosErr) ; load dos error code to L (next byte is loaded to H...
    LD H, 0         ; ...but that is ignored
    CP TRUE         ; check if clear argument is true
    RET NZ          ; if not, just return without clearing dos error
    LD A, DOS_OK    ; otherwise, clear the dos error
    LD (DosErr), A
    RET

; Save a file to disk
; procedure
; syntax: Save
sys_save:
    LD IX, Filename             ; transfer file name pointer to IX
    CALL dos_saveFile
    JP _sys_return

sys_move:
    CALL run_evaluate           ; evaluate the file name
    CP 0
    JP NZ, run_syntaxError
    LD IY, (Expression + 1)      
    CALL run_evaluate           ; evaluate the directory name
    CP 0
    JP NZ, run_syntaxError
    LD IX, (Expression + 1)
    CALL dos_mv
    JP _sys_return

; Restart reading/writing the file from the first byte
; procedure
; syntax: Reset
sys_reset:
    CALL dos_reset
    RET

; Put the file Read/Write pointer at the specified offset within the file buffer.
; procedure
; syntax Seek <Expression>
; argument1: number representing the offset within the file
sys_seek:
    CALL run_evaluate       ; evaluate the new file pointer
    CP 0
    JP NZ, run_syntaxError    
    LD HL, (Expression + 1)   
    CALL dos_seek
    RET


; Reads a byte from file
; and advances the file pointer
; procedure
; syntax: FRead <Variable>
; argument1: the variable to read into
; L will contain the value read
; H is 0
sys_fread:
    CALL _apl_getVar     ; get the address of the variable in memory
    CALL dos_fRead      ; read from the file
    LD (HL), A          ; transfer the result of the read into the lower byte of the variable
    INC HL
    LD (HL), 0          ; zero-out the higher byte of the variable
    RET

; Writes a byte to a file
; and advances the file pointer
; procedure
; syntax: FWrite <Expression>
; argument1: the value to write to the file (8bit)
; only the lower byte is written
; higher byte is ignored.
sys_fwrite:
    CALL run_evaluate       ; evaluate the expression to be written
    CP 0
    JP NZ, run_syntaxError 
    LD A, L
    CALL dos_fWrite
    RET


; Indicates whether a file exists
; function
; syntax: Exists(<Expression>)
; argument1: file name
; returns a boolean value
sys_exists:
    PUSH HL
    POP IX              ; transfer file name pointer to IX
    CALL dos_fileExists
    CP 0
    JR Z, .no
    LD H, TRUE
    LD L, TRUE
    RET
.no:
    LD H, FALSE
    LD L, FALSE
    RET

; returns the size of the currently opened file
; function
; syntax: Size()
sys_size:
    ; ignore the parameter
    LD HL, (CurrentFileSize)
    RET

; creates a new directory
; function
; syntax: MkDir(<Expression>)
; argument1: directory name
; returns True if the operation is successful and False when there's an error.
; in the latter case, it sets DosErr
sys_mkdir:
    PUSH HL
    POP IX
    CALL dos_mkDir
    JP _sys_return

; deletes a directory
; function
; syntax: RmDir(<Expression>)
; argument1: directory name
; returns True if the operation is successful and False when there's an error.
; in the latter case, it sets DosErr
sys_rmdir:
    PUSH HL
    POP IX
    CALL dos_rmDir
    JP _sys_return

; deletes a file
; function
; syntax: Delete(<Expression>)
; argument1: file name
; returns True if the operation is successful and False when there's an error.
; in the latter case, it sets DosErr
sys_rm:
    PUSH HL
    POP IX              ; transfer file name pointer to IX
    CALL dos_rm
    JP _sys_return

; creates an empty file
; function
; syntax: Touch(<Expression>)
; argument1: file name
; returns True if the operation is successful and False when there's an error.
; in the latter case, it sets DosErr
sys_touch:
    PUSH HL
    POP IX              ; transfer file name pointer to IX
    CALL dos_touch
    JP _sys_return

; changes the current directory
; function
; syntax: ChDir(<Expression>)
; argument1: directory name
; returns True if the operation is successful and False when there's an error.
; in the latter case, it sets DosErr
sys_chdir:
    PUSH HL
    POP IX
    CALL dos_cd
    JP _sys_return

; returns the current directory
; note, the value is only valid until the next I/O operation
; if it's supposed to be persisted, it needs to be copied over to a safe buffer
; function
; syntax: Pwd()
sys_pwd:
    ; ignore the parameter
    LD HL, CurrentPath
    RET

; indicates whether end of file has been reached
; function
; syntax: Eof()
; returns a boolean value
sys_eof:
    ; ignore the parameter
    LD HL, (CurrentFileSize)
    DEC HL
    LD BC, (FilePtr)
    CALL i16_cmp
    CP -1
    JR Z, .yes
    LD H, FALSE
    LD L, FALSE
    RET
.yes:
    LD H, TRUE
    LD L, TRUE
    RET

; resets the file listig process
; procedure
; syntax: List
sys_listFiles:
    LD A, 00h
    LD (FileIndex), A
    LD A, 01h		    ; the first sector of the file table. Counting sectors in A
    LD (FileSector), A
    CALL dos_loadFileTabSector
    LD HL, SectorBuffer
    LD (FileSecPtr), HL
    RET

; resets the directory listig process
; procedure
; syntax: ListDirs
sys_listDirs:
    LD A, 00h
    LD (FileIndex), A
    LD HL, SectorBuffer
    LD (FileSecPtr), HL
    CALL dos_loadDirs
    RET

; returns the name of the next file from the filesystem
; if the last available file has been reached, returns a null string
; note, the value is only valid until the next I/O operation
; if it's supposed to be persisted, it needs to be copied over to a safe buffer
; function
; syntax NextFile()
sys_nextFile:
    ; ignore the parameter
	LD A, (FileIndex)           ; load the current index into the file table sector
    INC A
    LD (FileIndex), A
    CP FILE_RECORDS_PER_SECTOR  ; check if this is the last file record in the sector
    JR NZ, .cont                ; if not, move on...
    ;                           ... if yes, try load the next sector of the file table
    LD A, (FileSector)          ; load the current file table sector number
    INC A                       ; increment the file table sector number
    LD (FileSector), A
    CP FILE_TABLE_SECTORS       ; check if last file table sector reached
    JR NZ, .load                ; if not,load the next sector
    LD HL, 0                    ; if yes, return an null string to indicate end of file table
    RET
.load:   
    CALL dos_loadFileTabSector
    LD A, 0
    LD (FileIndex), A
    LD HL, SectorBuffer
    LD (FileSecPtr), HL
.cont:
    LD HL, (FileSecPtr)
    PUSH HL
    LD B, 0
    LD C, FILE_RECORD_SIZE
    ADD HL, BC
    LD (FileSecPtr), HL
    POP HL
    LD A, (HL)                  ; check if there is a non-empty file name 
    CP 0                        ; at the beginning of the file record
    RET NZ                      ; if there is, return it in HL
    JR sys_nextFile             ; if not, try with the next file record
	RET

; returns the name of the next directory from the filesystem
; if the last available directory has been reached, returns a null string
; note, the value is only valid until the next I/O operation
; if it's supposed to be persisted, it needs to be copied over to a safe buffer
; function
; syntax NextDir()
sys_nextDir:
    LD A, (FileIndex)
    INC A
    CP MAX_DIRS
    JR Z, .end
    LD (FileIndex), A
    LD HL, (FileSecPtr)
    LD C, MAX_DIRNAME_LEN
    LD B, 0
    ADD HL, BC
    LD (FileSecPtr), HL
    LD A, (HL)
    CP 0
    JR Z, sys_nextDir
    RET
.end:
    LD HL, 0
    RET


; ####################### Private routines #####################################

; return the status of the last I/O operation in HL
; true if the operation was successful
; false is the operation was not successful
; input: DOS error code in A
_sys_return:
    CP DOS_OK
    JR NZ, .err
    LD H, TRUE
    LD L, TRUE
    RET
.err:
    LD H, FALSE
    LD L, FALSE
    RET

_sys_jumpTo:
    JP (HL)