; system calls for APL

; Read


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