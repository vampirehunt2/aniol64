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
    CALL writeStr
    RET
.syntaxErr:
    ; TODO
    RET

sys_read:
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

; a 16-bit peek
sys_peek:
    PUSH IX
    PUSH HL
    POP IX
    LD H, (IX + 1)
    LD L, (IX + 0)
    POP IX
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

