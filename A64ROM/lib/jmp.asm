; Jump table for assembler system calls

; Keyboard  ###############################

jmp_ReadKey:    JP readKey
jmp_ReadLn:     JP readLine
jmp_KeyPressed: JP keyPressed

; Display   ###############################

jmp_GotoXY:     JP gotoXY
jmp_PutChar:    JP putChar
jmp_GetChar:    JP getChar
jmp_Write:      JP writeStr
jmp_WriteLn:    JP writeLn
jmp_NewLn:      JP nextLine
jmp_Clr:        JP clrScr

; Utils     ###############################

jmp_Delay       JP delay
jmp_Beep:       JP bzr_beep
jmp_Click:      JP bzr_click
jmp_Rnd:        JP rnd
jmp_ParseByte:  JP parseByte
jmp_ParseDByte: JP parseDByte
jmp_ParseDec:   JP i16_parseDec
jmp_FormatDec:  JP i16_formatDec
jmp_FormatHex:  JP u16_formatHex
jmp_Nmi:        JP registerNmiHandler
jmp_NmiRes:     JP resetNmiHandler

; Strings   ###############################

jmp_Len:        JP str_len
jmp_Copy:       JP str_copy
jmp_Cmp:        JP str_cmp
jmp_Cat:        JP str_cat
jmp_Tok:        JP str_tok
jmp_Shift:      JP str_shift
jmp_LTrim:      JP str_ltrim
jmp_RTrim:      JP str_rtrim
jmp_CharAt:     JP str_charAt
jmp_Starts:     JP str_startsWith


; DOS       ###############################

jmp_Load:       JP dos_loadFile
jmp_Reset:      JP dos_reset
jmp_Save:       JP dos_saveFile
jmp_Rm:         JP dos_rm
jmp_MkDir:      JP dos_mkDir
jmp_RmDir:      JP dos_rmDir
jmp_Cd:         JP dos_cd
jmp_FRead:      JP dos_fRead
jmb_FReadLn:    JP dos_fReadLn
jmp_FWrite:     JP dos_fWrite
jmp_FWriteLn:   JP dos_fWriteLine
jmp_Seek:       JP dos_seek
jmp_Exists:     JP dos_fileExists
jmp_DirExists:  JP dos_dirExists
jmp_Touch:      JP dos_touch
jmp_Eof:        JP dos_eof

