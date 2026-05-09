
cmd_bat:
    CALL str_shift
    CALL bat_main
    RET

; bat filename in IX
bat_main:
    CALL dos_loadFile
    CP OK
    JR NZ, .err
.loop:
    CALL dos_eof
    CP TRUE
    RET Z
    LD IX, PrevLineBuff
    CALL dos_fReadLn
    CALL str_len
    CP 0
    JR Z, .loop     ; ignore empty lines
    LD A, (IX)
    CP ';'          ; check for comments
    JR Z, .loop     ; ignore lines with comments
    CALL cmd_exec   ; execute the command
    JR .loop
.err:
    CALL dos_printError
    RET
    