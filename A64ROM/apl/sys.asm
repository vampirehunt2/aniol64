; system calls for APL

ParseError:     defb "Parse error", 0


; Writes a decimal number to screen
; procedure
; syntax: Write <Expression>
sys_write:
    CALL run_evaluate
    CP 0
    JR NZ, .syntaxErr
    LD HL, (Expression + 1)
    LD IX, LineBuff 
    CALL i16_formatDec
    CALL trimDec
    CALL writeStr
    RET
.syntaxErr:
    ; TODO
    RET

; TODO: add a second argument for max string length
; reads a line of text from the keyboard into a variable
; procedure
; syntax: ReadS <Variable>
sys_readString:
    CALL cursorOn
    CALL readLine
    LD IX, LineBuff
    CALL nextLine
    INC HL              ; move to the variable bytecode
    CALL run_getVar     ; get variable to which to read the string 
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
    INC HL              ; move to the variable 
    CALL run_getVar
    LD (HL), DE
    RET
.parseErr:
    POP HL
    LD IX, ParseError
    CALL writeLn
    JR sys_read

; gets the variable address from variable bytecode
; HL points to the bytecode of the variable
; returns the address of the variable in memory in HL
run_getVar:
    LD A, (HL)          ; load the variable bytecode
    AND 01111111b       ; get the variable index
    SLA A               ; multiply it by 2, as numeric variables are 2 bytes long
    LD C, A
    LD B, 0
    LD HL, Vars         
    ADD HL, BC          ; get the variable address
    RET

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

; Stops the program execution for approximately (argument * 10ms)
; procedue
; syntax: Delay <Expression>
sys_delay:
    CALL run_evaluate
    CP 0
    JR NZ, .syntaxErr
    LD A, (Expression + 1)  ; only use the lower bit of the argument
    CALL delay
    RET
.syntaxErr:
    ; TODO
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
    JR NZ, .syntaxErr
    LD IY, (Expression + 1)
    CALL run_evaluate
    CP 0
    JR NZ, .syntaxErr
    LD A, (Expression + 1)      ; load lower byte of the expression, ignore the higher byte
    LD (IY), A
    RET
.syntaxErr:
    ; TODO
    RET

; moves the cursor to the given screen coordinates
; procedure
; syntax: GotoXY <Expression>, <Expression>
; argument1: Column (8bit)
; argument2: Row (8bit)
sys_gotoxy:
    CALL run_evaluate           ; evaluate the X coefficient
    CP 0                        ; check if a valid expression
    JR NZ, .syntaxErr           ; if not, report error
    LD A, (Expression + 1)      ; load the X coefficient to B...
    LD B, A                     ; ...ignoring the higher byte
    CALL run_evaluate           ; evaluate the Y coefficient
    CP 0                        ; check if a valid expression
    JR NZ, .syntaxErr           ; if not, report error
    LD A, (Expression + 1)      ; load the Y coefficient to C...
    LD C, A                     ; ...ignoring the higher byte
    call gotoXY
    RET
.syntaxErr:
    ; TODO
    RET

; puts a character on the screen
; procedure
; syntax: PutChar <Expression>
; argument1: character to print (8bit)
sys_putChar:
    CALL run_evaluate           ; evaluate the character
    CP 0                        ; check if a valid expression
    JR NZ, .syntaxErr           ; if not, report error
    LD A, (Expression + 1)      ; load the character ASCII code to A
    call putChar
    RET
.syntaxErr:
    ; TODO
    RET

; Writes a byte to a port
; procedure
; syntax: Put <Expression>, <Expression>
; argument1: port number (8bit)
; argument2: value to write (8bit)
sys_put:
    CALL run_evaluate
    CP 0
    JR NZ, .syntaxErr
    LD A, (Expression + 1)      ; load lower byte of the expression, ignore the higher byte
    LD C, A
    CALL run_evaluate
    CP 0
    JR NZ, .syntaxErr
    LD A, (Expression + 1)      ; load lower byte of the expression, ignore the higher byte
    OUT (C), A
    RET
.syntaxErr:
    ; TODO
    RET

; TODO incomplete
sys_startsWith:
    CALL run_evaluate
    CP 0
    JR NZ, .syntaxErr
    LD IX, (Expression + 1)      
    CALL run_evaluate
    CP 0
    JR NZ, .syntaxErr
    LD IY, (Expression + 1)      
    CALL str_startsWith
    CP TRUE
    JR .true
.true:
    ; TODO
    RET
.syntaxErr:
    ; TODO
    RET
    
; Writes a string to the screen
; procedure
; syntax: WriteS <Expression>
; argument1: string to write, either pointer or string constant
sys_writeString:
    CALL run_evaluate
    CP 0
    JR NZ, .syntaxErr
    LD IX, (Expression + 1)
    CALL writeStr
    RET
.syntaxErr:
    ; TODO
    RET

sys_upper:
    CALL run_evaluate
    CP 0
    JR NZ, .syntaxErr
    LD IX, (Expression + 1)
    CALL str_toUpper
    RET
.syntaxErr:
    ; TODO
    RET

sys_lower:
    CALL run_evaluate
    CP 0
    JR NZ, .syntaxErr
    LD IX, (Expression + 1)
    CALL str_toLower
    RET
.syntaxErr:
    ; TODO
    RET

; returns the length of a string
sys_len:
    PUSH IX
    PUSH HL
    POP IX
    CALL str_len
    LD L, A
    LD H, 0
    POP IX
    RET

sys_cmp:
    RET

sys_copy:
    CALL run_evaluate
    CP 0
    JR NZ, .syntaxErr
    LD IY, (Expression + 1)      
    CALL run_evaluate
    CP 0
    JR NZ, .syntaxErr
    LD IX, (Expression + 1)
    CALL str_copy
    RET
.syntaxErr:
    ; TODO
    RET

sys_getChar:
    ; ignores the parameter
    CALL getChar
    LD L, A
    LD H, 0
    RET

// TODO: idea - make the parameter specify if this call is supposed to bt sycnhronous
sys_readKey:
    ; ignores the parameter
    CALL readKey
    LD L, A
    LD H, 0
    RET

; one-byte get
; port number is one byte, passed in L
sys_get:
    LD C, L
    IN A, (C)
    LD L, A
    LD H, 0
    RET

; clear the screen
; syntax: ClrScr
sys_clrScr:
    CALL clrScr
    CALL home
    RET

; #################### DOS functions ########################

; Open a file from disk and load it to the file buffer
; function
; syntax: Open(<Expression>)
; argument1: filename
; returns: 0000h in case of error, FFFFh in case of success
sys_open:  
    PUSH HL                     
    POP IX                      ; transfer file name pointer to IX
	CALL dos_loadFile           ; load the file
	LD A, (DosErr)             ; check if loading was successful
    CP 0
    JR NZ, .err
    LD H, TRUE
    LD L, TRUE
    RET
.err:
    LD H, FALSE
    LD L, FALSE
    RET

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
    LD A, (DosErr)              ; check if loading was successful
	CP DOS_OK
	RET Z
.ioErr:
    ; TODO I/O error handling
    RET                         ; otherwise drop through to the IO error handling
.syntaxErr:
    ; TODO
    RET

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
    JR NZ, .syntaxErr 
    CALL dos_seek
    RET
.syntaxErr:
    ; TODO  
    RET

; Reads a byte from file
; and advances the file pointer
; procedure
; syntax: FRead <Variable>
; argument1: the variable to read into
; L will contain the value read
; H is 0
sys_fread:
    INC HL              ; move to the variable bytecode
    CALL run_getVar     ; get the address of the variable in memory
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
    JR NZ, .syntaxErr 
    LD A, L
    CALL dos_fWrite
    RET
.syntaxErr:
    ; TODO  
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



sys_chdir:  // TODO incomplete
    CALL dos_cd
    RET

sys_mkdir:
    RET

