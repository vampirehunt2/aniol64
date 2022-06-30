;----------------------------------------------------
; Project: aniol64.zdsp
; File: dos.asm
; Date: 9/16/2021 10:00:02
;
; Created with zDevStudio - Z80 Development Studio.
;
;----------------------------------------------------

DiskFound1 		defb "Disk ", 0
DiskFound2 		defb "found", 0
DiskNotFound 	defb "Disk not found", 0
NvRamOk: 		defb   "NVRAM found", 0
NvRamNok: 		defb  "NVRAM not found", 0
SerialNum: 		defb "Serial: ", 0
Model: 			defb "Model: ", 0
FirmwareRev: 	defb "Firmware Rev: ", 0
LbaSectors: 	defb "LBA Sectors: ", 0
InvalidSector: 	defb "Invalid sector", 0
ErrInvDirName:	defb "Invalid directory name", 0
ErrDirExists:	defb "Directory already exists", 0
ErrTooManyDirs:	defb "Too many directories", 0
ErrNoSuchDir:	defb "No such directory", 0

RootFolder: 	defb "/", 0
ParentFolder: 	defb "..", 0
 
SectorBuffer equ 08400h
CurrentPath equ DOS_AREA + 00h	; 9 bytes: 8 for the folder name and 1 for the terminating zero
CurrentDir equ	DOS_AREA + 09h	; index of the current directory in the directory table
TempDirname equ DOS_AREA + 0Ah	; 9 bytes: 8 for the folder name and 1 for the terminating zero

MAX_DIRNAME_LEN equ 8
FS_INFO_LEN equ 8
MAX_DIRS equ 63
 
PROC
dos_setUpCf:
		CALL cf_exists
		CP FALSE
		JR Z, _noDisk
		LD IX, DiskFound1
		CALL vga_wriStr
		CALL cf_init
		LD IX, DiskFound2
		CALL vga_writeLn
		CALL dos_cdRoot
		RET
_noDisk:
		LD IX, DiskNotFound
		CALL vga_writeLn
		RET
ENDP

dos_cfDiskInfo:
		LD HL, SectorBuffer
		CALL cf_di
		LD IX, SerialNum			; serial
		CALL vga_wriStr
		LD IX, SectorBuffer + 20
		LD B, 20
		CALL dos_printRecord
		CALL vga_nextLine
		LD IX, Model				; model
		CALL vga_wriStr
		LD IX, SectorBuffer + 54
		LD B, 30
		CALL dos_printRecord
		CALL vga_nextLine
		LD IX, FirmwareRev			; firmware
		CALL vga_wriStr
		LD IX, SectorBuffer + 46
		LD B, 8
		CALL dos_printRecord
		CALL vga_nextLine
		LD IX, LbaSectors			; LBA sectors
		CALL vga_wriStr
	 	LD A, (SectorBuffer + 120)
		CALL mon_printByteA
		LD A, (SectorBuffer + 121)
		CALL mon_printByteA
		LD A, (SectorBuffer + 122)
		CALL mon_printByteA
		LD A, (SectorBuffer + 123)
		CALL mon_printByteA
		RET 
	
; prints B bytes from address IX
dos_printRecord:
		LD A, (IX)
		CALL vga_putChar
		INC IX
		DJNZ dos_printRecord
		RET

PROC
dos_checkNvram:
		CALL memTest
        CP 0
        JR Z, _memTestOk
        LD IX, NvRamNok
        JP _printMemTest
_memTestOk:
        LD IX, NvRamOk
        JP _printMemTest
_printMemTest:
        CALL vga_writeLn
		RET
ENDP

PROC
dos_load:
		CALL str_shift
		CALL str_tok
		PUSH HL				; push address of the rest of the string
		CALL parseDByte		; address of buffer to save now in HL
		CP OK
		JR NZ, _invalidAddress
		POP IX				; address of the rest of the string now in IX
		PUSH HL				; push buffer address
		CALL parseDByte		; sector number now in HL
		CP OK
		JR NZ, _invalidSector
		LD A, L				
		LD B, H
		LD C, 0				; sector number now in ABC
		POP HL				; buffer address now in HL
		CALL cf_setSector
		CALL cf_readSector
		RET
_invalidAddress:
		LD IX, InvAddr
		CALL vga_writeLn
		RET
_invalidSector:
		LD IX, InvalidSector
		CALL vga_writeLn
		RET
ENDP
	
PROC
dos_save:
        CALL str_shift
		CALL str_tok
		PUSH HL				; push address of the rest of the string
		CALL parseDByte		; address of buffer to save now in HL
		CP OK
		JR NZ, _invalidAddress
		POP IX				; address of the rest of the string now in IX
		PUSH HL				; push buffer address
		CALL parseDByte		; sector number now in HL
		CP OK
		JR NZ, _invalidSector
		LD A, L				
		LD B, H
		LD C, 0				; sector number now in ABC
		POP HL				; buffer address now in HL
		CALL cf_setSector
		CALL cf_writeSector
		RET
_invalidAddress:
		LD IX, InvAddr
		CALL vga_writeLn
		RET
_invalidSector:
		LD IX, InvalidSector
		CALL vga_writeLn
		RET
_
ENDP

; loads the directory table into memory at address SectorBuffer
; destroys A
dos_loadDirs:
		PUSH BC
		PUSH DE
		PUSH HL
		LD A, 0
		LD B, 0
		LD C, 0
		CALL cf_setSector	; set sector zero, where the directory table is
		LD HL, SectorBuffer
		CALL cf_readSector	; read the directory table - 64 8-byte directory names
		POP HL
		POP DE
		POP BC
		RET

; saves the directory table from memory at address SectorBuffer
; destroys A		
dos_saveDirs:
		PUSH BC
		PUSH DE
		PUSH HL
		LD A, 0
		LD B, 0
		LD C, 0
		CALL cf_setSector
		LD HL, SectorBuffer
		CALL cf_writeSector
		POP HL
		POP DE
		POP BC
		RET

PROC
dos_listDirs:
		PUSH BC			; save register state
		PUSH DE
		PUSH IX
		LD E, MAX_DIRS
		CALL dos_loadDirs
		LD IX, SectorBuffer + FS_INFO_LEN
_checkDir:
		PUSH IX
		LD A, (IX)
		CP 0			; check if a directory entry is present
		JR Z, _nextDir
		LD B, MAX_DIRNAME_LEN
		LD IY, LineBuff
		CALL str_2str
		CALL vga_writeLn
_nextDir:
		POP IX
		CALL dos_nextDir
		DEC E			; decrement directory record counter
		JP NZ, _checkDir; if haven't reached the end of the directory sector, fetch the next directory
_end:
		POP IX
		POP DE			; restore register state	
		POP BC
		RET
ENDP

PROC
dos_rmDir:
		CALL str_shift
		CALL dos_loadDirs
		LD E, MAX_DIRS
		PUSH IX
		POP IY
		LD IX, SectorBuffer + FS_INFO_LEN
_loop:
		LD B, MAX_DIRNAME_LEN
		CALL str_cmpMem
		JR Z, _rm
		CALL dos_nextDir
		DEC E
		JR NZ, _loop
		LD A, 0
		LD IX, ErrNoSuchDir
		CALL vga_writeLn
		JR _end
_rm:
		LD A, 0
		LD (IX), A
		CALL dos_saveDirs
_end:
		RET

ENDP

PROC
dos_mkDir:
		PUSH BC			; save register state
		PUSH DE
		; check if dir name is valid
		CALL str_shift
		CALL dos_validateDirname
		CP TRUE
		JP NZ, _invName
		CALL dos_dirExists
		CP 0
		JR NZ, _exists
		; if valid, proceed
		LD E, MAX_DIRS
		LD IX, SectorBuffer + FS_INFO_LEN
_checkDir:
		LD A, (IX)
		CP 0			; check if a directory entry is present
		JR Z, _makeDir
		CALL dos_nextDir
		DEC E			; decrement directory record counter
		JP NZ, _checkDir; if haven't reached the end of the directory sector, fetch the next directory
		JP _tooMany		; maximum number of directories on the disk has been reached
_makeDir:
		PUSH IX
		POP IY			; transfer buffer address from IX to IY
		PUSH HL
		POP IX			; transfer name of directory from HL to IX
		CALL str_2mem
		CALL dos_saveDirs
		JP _end
_invName:
		LD IX, ErrInvDirName
		CALL vga_writeLn
		JR _end
_exists:
		LD IX, ErrDirExists
		CALL vga_writeLn
		JR _end
_tooMany:
		LD IX, ErrTooManyDirs
		CALL vga_writeLn
		JR _end
_end:
		POP DE			; restore register state	
		POP BC
		RET
ENDP

; checks if the string at IX represents a valid directory name
; TODO: check if the name consists of alphanumeric characters only
PROC
dos_validateDirname:
		PUSH IX
		CALL str_len
		CP 0
		JR Z, _false
		CP MAX_DIRNAME_LEN			
		JR NC, _false
_loop:
		LD A, (IX)
		CP 0
		JR Z, _true
		CALL isAlphanumeric
		CP FALSE
		JR Z, _false
		INC IX
		JR _loop
_true:
		LD A, TRUE
		JR _end
_false:
		LD A, FALSE
		JR _end
_end:
		POP IX
		RET		
ENDP

; checks if a directory with a given name exists
; IX - directory name
; result in A:
; - 0 if the directory doesn't exist
; - directory index if it exists
; destroys IY, DE
PROC
defb "dos_dirExists"
dos_dirExists:
		CALL dos_loadDirs
		LD D, 1
		LD E, MAX_DIRS
		PUSH IX
		POP IY
		LD IX, SectorBuffer + FS_INFO_LEN
_loop:
		LD B, MAX_DIRNAME_LEN
		CALL str_cmpMem
		JR Z, _yes
		CALL dos_nextDir
		INC D
		DEC E
		JR NZ, _loop
		LD A, 0
		RET
_yes:
		LD A, D
		RET
ENDP

; moves IX over by the number of bytes corresponding to the length of a directory entry
PROC
dos_nextDir:
		PUSH BC
		LD B, MAX_DIRNAME_LEN			; length of directory entry
_loop:
		INC IX
		DJNZ _loop
		POP BC
		RET
ENDP

dos_pwd:
		LD IX, CurrentPath
		CALL vga_writeLn
		RET
		
dos_cdRoot:
		LD IX, RootFolder
		LD IY, CurrentPath
		CALL str_copy
		LD A, 0
		LD (CurrentDir), A
		RET
		
PROC
dos_cd:
		CALL str_shift		; transfer folder name from HL to IX
		; check if user wants to go to the root folder
		LD IY, RootFolder
		CALL str_cmp
		CP 0
		JR Z, _root
		LD IY, ParentFolder
		CALL str_cmp
		CP 0
		JR Z, _root
		JR _end
_root:
		CALL dos_cdRoot
_end:
		RET
ENDP

dos_ls:
		CALL dos_listDirs
		RET
		



		
		