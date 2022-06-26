;----------------------------------------------------
; Project: aniol64.zdsp
; File: dos.asm
; Date: 9/16/2021 10:00:02
;
; Created with zDevStudio - Z80 Development Studio.
;
;----------------------------------------------------

DiskFound1 defb "Disk ", 0
DiskFound2 defb "found", 0
DiskNotFound defb "Disk not found", 0
NvRamOk: defb   "NVRAM found", 0
NvRamNok: defb  "NVRAM not found", 0
SerialNum: defb "Serial: ", 0
Model: defb "Model: ", 0
FirmwareRev: defb "Firmware Rev: ", 0
LbaSectors: defb "LBA Sectors: ", 0
InvalidSector: defb "Invalid sector", 0
Saving:	defb "Saving", 0
RootFolder: defb "/", 0
ParentFolder: defb "..", 0
 
SectorBuffer equ 08400h
CurrentPath equ DOS_AREA + 00h	; 9 bytes: 8 for the folder name and 1 for the terminating zero
CurrentDir equ	DOS_AREA + 09h	; index of the current directory in the directory table
TempDirname equ DOS_AREA + 0Ah	; 9 bytes: 8 for the folder name and 1 for the terminating zero

MAX_DIRNAME_LEN equ 8
MAX_DIRS equ 64
 
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

PROC
dos_listDirs:
		PUSH BC			; save register state
		PUSH DE
		LD E, MAX_DIRS
		CALL dos_loadDirs
		LD IX, SectorBuffer
_checkDir:
		PUSH IX
		LD A, (IX)
		CP 0			; check if a directory entry is present
		JR Z, _nextDir
		LD B, MAX_DIRNAME_LEN
		LD IY, LineBuff
		CALL str_2str	
		PUSH IY
		POP IX			; transfer IY to IX
		CALL vga_writeLn
		POP IX
_nextDir:
		CALL dos_nextDir
		DEC E			; decrement directory record counter
		JP NZ, _checkDir; if haven't reached the end of the directory sector, fetch the next directory
		POP DE			; restore register state	
		POP BC
		RET
ENDP

PROC
dos_mkDir:
		PUSH BC			; save register state
		PUSH DE
		; check if dir name is valid
		CALL dos_validateDirname
		CP FALSE
		JP Z, _error
		; if valid, proceed
		LD E, MAX_DIRS
		CALL dos_loadDirs
		LD IX, SectorBuffer
_checkDir:
		PUSH IX
		LD A, (IX)
		CP 0			; check if a directory entry is present
		JR Z, _makeDir
		LD B, 8			; length of directory entry
		POP IX
		CALL dos_nextDir
		DEC E			; decrement directory record counter
		JP NZ, _checkDir; if haven't reached the end of the directory sector, fetch the next directory
		JP _error		; maximum number of directories on the disk has been reached
_makeDir:
		PUSH IX
		POP IY			; transfer buffer address from IX to IY
		PUSH HL
		POP IX			; transfer name of directory from HL to IX
		CALL str_2mem
		CALL dos_saveDirs
		JP _end
_error:
		; TODO write some error messages
_end:
		POP DE			; restore register state	
		POP BC
		RET
ENDP

; checks if the string at IX represents a valid directory name
; TODO: check if the name consists of alphanumeric characters only
PROC
dos_validateDirname:
		CALL str_len
		CP MAX_DIRNAME_LEN			
		JR C, _false
		LD A, TRUE
		RET
_false:
		LD A, FALSE
		RET		
ENDP

PROC
dos_dirExists:
		CALL dos_loadDirs
		LD IX, SectorBuffer
_loop:
		LD B, MAX_DIRNAME_LEN
		LD IY, TempDirname
		CALL str_2str
_yes:
		
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
		LD IX, CurrentPath
		LD IY, RootFolder
		CALL str_copy
		LD A, 0
		LD (CurrentDir), A
		RET
		
PROC
dos_cd:
		PUSH HL		; transfer folder name from HL to IX
		POP IX
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
		



		
		