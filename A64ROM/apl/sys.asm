; system calls for APL

ParseError:     defb "Parse error", 0


; Write
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
sys_readString:
    CALL cursorOn
    CALL readLine
    LD IX, LineBuff
    CALL nextLine
    ; get variable to which to read the string 
    ; TODO: this is the same code as in sys_read, may be good to refactor it out to a subroutine
    INC HL              ; move to the variable 
    LD A, (HL)          ; load the variable bytecode
    AND 01111111b       ; get the variable index
    SLA A               ; multiply it by 2, as numeric variables are 2 bytes long
    LD C, A
    LD B, 0
    LD HL, Vars         
    ADD HL, BC          ; get the variable address
    ; 
    PUSH HL             ; copy HL...
    POP IY              ; ... to IY
    CALL str_copy       ; copy the string that was read in to the memory area pointed to by IY (and therefore HL)
    RET

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
    LD A, (HL)          ; load the variable bytecode
    AND 01111111b       ; get the variable index
    SLA A               ; multiply it by 2, as numeric variables are 2 bytes long
    LD C, A
    LD B, 0
    LD HL, Vars         
    ADD HL, BC          ; get the variable address
    LD (HL), DE
    RET
.parseErr:
    POP HL
    LD IX, ParseError
    CALL writeLn
    JR sys_read

sys_beep:
    CALL bzr_beep
    RET

sys_click:
    CALL bzr_click
    RET

sys_nextLn:
    CALL nextLine
    RET

sys_abs:
    CALL i16_abs
    RET

sys_rnd:
    CALL rndMod
    RET

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

; 8-bit peek
sys_peek:
    PUSH IX
    PUSH HL
    POP IX
    LD H, 0
    LD L, (IX)
    POP IX
    RET


; 8-bit poke
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

sys_get:
    LD C, L
    IN A, (C)
    LD L, A
    LD H, 0
    RET

sys_clrScr:
    CALL clrScr
    CALL home
    RET

; #################### DOS functions ########################

; Open a file from disk and load it to the file buffer
sys_open:
    CALL run_evaluate
    CP 0
    JR NZ, .syntaxErr 
    LD HL, (Expression + 1)     ; load the file name pointer to HL
    PUSH HL
    POP IX                      ; transfer file name pointer to IX
	CALL dos_loadFile           ; load the file
	LD A, (DosErr)              ; check if loading was successful
	CP DOS_OK
	RET Z                       ; return if yes
.ioErr:
    ; TODO I/O error handling
    RET                         ; otherwise drop through to the IO error handling
.syntaxErr:
    ; TODO
    RET

; Save a file to disk
sys_save:
    CALL run_evaluate
    CP 0
    JR NZ, .syntaxErr 
    LD HL, (Expression + 1)     ; load the file name pointer to HL
    PUSH HL
    POP IX                      ; transfer file name pointer to IX
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
sys_reset:
    CALL dos_reset
    RET

; Put the file Read/Write pointer at the specified offset within the file buffer.
sys_seek:
    CALL run_evaluate       ; evaluate the new file pointer
    CP 0
    JR NZ, .syntaxErr 
    CALL dos_seek
    RET
.syntaxErr:
    ; TODO  
    RET

sys_fread:
    RET
