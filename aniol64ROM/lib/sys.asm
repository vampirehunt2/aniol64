; Keyboard  ###############################

ReadKey:    JP readKey
ReadLn:     JP readLine

; Display   ###############################

Goto:       JP gotoXY
PutChar:    JP putChar
GetChar:    JP getChar
Write:      JP wriStr
WriteLn:    JP writeLn
Clr:        JP ClrScr

; Utils     ###############################

Beep:       JP bzr_beep
Click:      JP bzr_click
Rnd:        JP rnd
Parse:
Format:
Get:
Put:

; Strings   ###############################

Len:        JP str_len
Copy:       JP str_copy
Cmp:        JP str_cmp
Cat:        JP str_cat
Tok:        JP str_tok
Shift:      JP str_shift
LTrim:      JP str_ltrim
RTrim:      JP str_rtrim
CharAt:     JP str_charAt
Starts:
Ends:
Contains:
Index: 

; Lists     ###############################

Clear:
Create:
Full:
Count:
Expand:
Append:
Insert:
Trunc:
Push:
Pull:
Empty:
Remove:
Item:

; DOS       ###############################

Load:       JP dos_load
Save:       JP dos_save
FLen:       
Rm:         JP dos_rm
RmDir:      JP dos_rmDir
Cd:         JP dos_cd
FRead:
FWrite:
Seek:
Exists:
