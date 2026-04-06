; Jump table for assembler system calls

; Keyboard  ###############################

jmp_ReadKey:    JP readKey
jmp_ReadLn:     JP readLine

; Display   ###############################

jmp_Goto:       JP gotoXY
jmp_PutChar:    JP putChar
jmp_GetChar:    JP getChar
jmp_Write:      JP writeStr
jmp_WriteLn:    JP writeLn
jmp_Clr:        JP clrScr

; Utils     ###############################

jmp_Beep:       JP bzr_beep
jmp_Click:      JP bzr_click
jmp_Rnd:        JP rnd
jmp_Parse:
jmp_Format:
jmp_Get:
jmp_Put:

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
jmp_Starts:
jmp_Ends:
jmp_Contains:
jmp_Index: 

; Lists     ###############################

jmp_Clear:
jmp_Create:
jmp_Full:
jmp_Count:
jmp_Expand:
jmp_Append:
jmp_Insert:
jmp_Trunc:
jmp_Push:
jmp_Pull:
jmp_Empty:
jmp_Remove:
jmp_Item:

; DOS       ###############################

jmp_Load:       JP dos_loadFile
jmp_Save:       JP dos_saveFile
jmp_FLen:       
jmp_Rm:         JP dos_rm
jmp_RmDir:      JP dos_rmDir
jmp_FRead:
FWrite:
jmp_Seek:
jmp_Exists:
