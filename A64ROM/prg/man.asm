; Project: aniol64
; tape archiver program
; 26/03/2026

; This program displays manual pages for a given command
; Requires a disk


manExt: db ".man", 0

man_main:   
    CALL man_saveDir
    CALL dos_cd             ; dirty trick. Before calling str_shift, 
                            ; IX points to the command, which in this case is 'man'.
                            ; Therefore, calling dos_cd will change directory to /man
    CALL man_addExt
    CALL dos_cat
    CALL man_restoreDir
    RET

man_addExt:
    PUSH HL         ; save the begining of the file name
.loop:
    INC HL
    LD A, (HL)
    CP 0
    JR NZ, .loop    ; loop until th end of file name
    PUSH HL         ; transfer the end of file name pointer to IY
    POP IY
    LD IX, manExt   
    CALL str_copy   ; add extension to the file name
    POP HL          ; restore the beginning of the file name to HL
    RET

; saves the previously used directory
man_saveDir:
    PUSH IX
    PUSH IY
    LD IX, CurrentPath
    LD IY, TempDirname
    CALL str_copy
    POP IY
    POP IX
    RET

; goes back to the original current directory
man_restoreDir:
    LD IX, TempDirname
    CALL dos_cd
    RET

