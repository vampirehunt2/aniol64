;----------------------------------------------------
; Project: aniol64.zdsp
; File: dos.asm
; Date: 9/16/2021 10:00:02
;
; Created with zDevStudio - Z80 Development Studio.
;
;----------------------------------------------------

; dos messages:
DiskFound1 		defb "Disk ", 0
DiskFound2 		defb "found", 0
DiskNotFound 	defb "Disk not found", 0
NvRamOk: 		defb "NVRAM found", 0
NvRamNok: 		defb "NVRAM not found", 0
SerialNum: 		defb "Serial: ", 0
Model: 			defb "Model: ", 0
FirmwareRev: 	defb "Firmware Rev: ", 0
LbaSectors: 	defb "LBA Sectors: ", 0

; error messages
InvalidSector: 	defb "Invalid sector", 0
ErrInvDirName:	defb "Invalid directory name", 0
ErrInvFileName:	defb "Invalid file name", 0
ErrDirExists:	defb "Directory already exists", 0
ErrFileExists:	defb "File already exists", 0
ErrTooManyDirs:	defb "Too many directories", 0
ErrNoSuchDir:	defb "No such directory", 0
ErrDiskFull:	defb "Disk full", 0

FsInfo:			defb "AFS 1.0", 0

; dos strings:
RootFolder: 	defb "/", 0
ParentFolder: 	defb "..", 0
 
; dos variables:
SectorBuffer 	equ 08400h
CurrentPath 	equ DOS_AREA + 00h	; 9 bytes: 8 for the folder name and 1 for the terminating zero
CurrentDir 		equ	DOS_AREA + 09h	; index of the current directory in the directory table
TempDirname 	equ DOS_AREA + 0Ah	; 9 bytes: 8 for the folder name and 1 for the terminating zero
 
; filesystem constants:
MAX_DIRNAME_LEN 		equ 8
MAX_FILENAME_LEN		equ 12
FS_INFO_LEN 			equ 8
MAX_DIRS 				equ 63 
MAX_FILES 				equ 4087	; 4096 -8 for the file table and -1 for the directory table
FILE_RECORDS_PER_SECTOR equ 32
FILE_RECORD_SIZE		equ 16
FILE_TABLE_SECTORS 		equ 128

; file record structure:
Filename 	equ 00h		; null-terminated string, 
						; 12 (8+3) characters with a dot, plus the terminating zero
						; contains a zero-length string if the file record is empty
FileExists  equ 00h		; first charatcter of the file name is 0 if the file record is empty
FileDir 	equ 0Dh		; 1 byte directory index
FileLen 	equ 0Eh		; 2 byte actual file length
 
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

PROC
; formats a compact flash disk to AFS 1.0
; destroys A, HL, BC, DE, IX, IY
dos_format:
        XOR A           ; LD A, 0
        LD HL, SectorBuffer
        LD DE, SectorBuffer + 1
        LD (HL), A   	; initialise the first byte of SectorBuffer to 0
        LD BC, 512   	; set loop counter to the full size of SectorBuffer
        LDIR         	; repeatedly copy previous byte to the current byte
		LD B, A			; set B to 0	
		LD C, A			; set C to 0
		LD A, FILE_TABLE_SECTORS
_loop:	
		PUSH AF
		LD HL, SectorBuffer
		CALL cf_setSector
		CALL cf_writeSector
		POP AF
		DEC A
		CP 0			; skipping the directory table sector
		JR NZ, _loop
		LD IX, FsInfo		; save the directory table
		LD IY, SectorBuffer
		CALL str_copy
		XOR A           ; LD A, 0
		LD B, A			; set B to 0	
		LD C, A			; set C to 0
		LD HL, SectorBuffer
		CALL cf_setSector
		CALL cf_writeSector
        RET
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

; lists on the screen all the directories in the root directory
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

; lists on the screen all the files in the current directory
PROC
dos_listFiles:
		LD A, 01h				; the first sector of the file table. Counting sectors in A
_loop:
		PUSH AF
		CALL dos_loadFileTabSector
		CALL dos_listFilesInSector
		POP AF
		INC A
		CP FILE_TABLE_SECTORS
		JR NZ, _loop
		RET
ENDP

PROC
dos_listFilesInSector:
		PUSH IY
		PUSH BC
		LD IY, SectorBuffer
		LD B, FILE_RECORDS_PER_SECTOR
_loop:
		LD A, (IY + FileExists)
		CP FALSE
		JR Z, _continue
		LD A, (IY + FileDir)	; read directory index of the file
		LD C, A					; store directory index of the file in C
		LD A, (CurrentDir)		; load the current directory into A
		CP C					; check if directory index of the file record equals the current directory
		JR NZ, _continue
		PUSH IY
		POP IX
		CALL vga_writeLn
_continue:
		CALL dos_nextFileRecord
		DJNZ _loop
		POP BC
		POP IY
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

; checks if the string at IX represents a valid directory name
; result in A
PROC
dos_validateFilename:
		PUSH IX
		CALL str_len
		CP 0
		JR Z, _false
		CP MAX_FILENAME_LEN			
		JR NC, _false
_loop:
		LD A, (IX)
		CP 0
		JR Z, _true
		CP '.'
		JR Z, _next			; dots are allowed
		CALL isAlphanumeric
		CP TRUE
		JR Z, _next			; as are alphanumeric characters
		JR _false			; any other character is disallowed
_next:
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
	
; changes the current dir to be the root dir	
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
		; if user isn't going to the root folder, find the appropriate folder
		CALL dos_dirExists
		CP 0
		JR Z, _noDir
		LD (CurrentDir), A
		LD IY, CurrentPath
		CALL str_copy
		JR _end
_noDir:
		LD IX, ErrNoSuchDir
		CALL vga_writeLn
		JR _end
_root:
		CALL dos_cdRoot
_end:
		RET
ENDP

PROC
dos_ls:
		LD A, (CurrentDir)
		CP 0
		JR NZ, _listFiles
		CALL dos_listDirs
_listFiles:
		CALL dos_listFiles
		RET
ENDP

; creates an empty file
; IX: file name
PROC
defb "dos_touch"
dos_touch:
		CALL str_shift
		CALL dos_validateFilename	; first, check if the given file name is valid...
		CP FALSE					; ...as this doesn't require reding any data from disk 
		JR Z, _invName
		CALL dos_fileExists			; check if file already exists in the current directory
		CP TRUE
		JR Z, _fileExists
		CALL dos_findFreeFileSlot
		CP FALSE					; check if a free slot exists
		JR Z, _diskFull
		PUSH AF						; save file table sector number on stack
		CALL str_copy				; copy the file name from the command line to the file record
		LD A, (CurrentDir)
		LD (IY + FileDir), A		; copy the current directory to the file record
		LD A, 0
		LD (IY + FileLen), A		; set the file to zero length
		LD (IY + FileLen + 1), A
		POP AF						; restore file table sector number from stack
		CALL dos_saveFileTabSector
		JR _end
_diskFull:	
		LD IX, ErrDiskFull
		CALL vga_writeLn
		JR _end
_fileExists:
		LD IX, ErrFileExists
		CALL vga_writeLn
		JR _end
_invName:
		LD IX, ErrInvFileName
		CALL vga_writeLn
		JR _end
_end:
		RET
ENDP

; finds a free file slot
; A - FALSE if a free slot does not exist
;	- sector number otherwise
; IY - address of the file record in sector buffer in memory
; destroys C, HL
PROC
dos_findFreeFileSlot:
		LD A, 01h				; the first sector of the file table. Counting sectors in A
_loop:
		PUSH AF
		CALL dos_loadFileTabSector
		CALL dos_findFreeFileSlotInSector
		CP FALSE
		JR NZ, _found
		POP AF
		INC A
		CP FILE_TABLE_SECTORS
		JR NZ, _loop
		LD A, FALSE
		RET
_found:
		POP AF
		RET
ENDP

; finds a free file slot (empty file record) in the SectorBuffer
; result in A
; if A is true, IY points to the beginning of the file record
PROC
dos_findFreeFileSlotInSector:
		PUSH BC
		LD IY, SectorBuffer
		LD B, FILE_RECORDS_PER_SECTOR
_loop:
		LD A, (IY + FileExists)
		CP 0
		JR Z, _found
		CALL dos_nextFileRecord
		DJNZ _loop
		LD A, FALSE
		JR _end
_found:
		LD A, TRUE
_end:
		POP BC
		RET
ENDP

; checks whether a file with a given name exists in the current directory
; IX: file name
; result in A
PROC
dos_fileExists:
		LD A, 01h				; the first sector of the file table
		LD B, FILE_TABLE_SECTORS
_sectorLoop:
		CALL dos_loadFileTabSector
		PUSH BC					; store the sector loop counter
		LD B, FILE_RECORDS_PER_SECTOR
		LD IY, 0
_recordLoop:
		LD A, (IY + FileExists)	; check if file record represents an existing file
		CP FALSE
		JR Z, _endRecordLoop 	; if not, skip the rest of the current sector
		LD A, (IY + FileDir)	; read directory index of the file
		LD C, A					; store directory index of the file in C
		LD A, CurrentDir		; load the current directory into A
		CP C					; check if directory index of the file record equals the current directory
		JR NZ, _endRecordLoop 	; if not, skip the rest of the current sector
		; TODO check for filename
		CALL str_cmp
_endRecordLoop:
		CALL dos_nextFileRecord
		DJNZ _recordLoop
		POP BC			; restore the sector loop counter
		DJNZ _sectorLoop
		RET
ENDP

; loads one sector of the file table into memory at address SectorBuffer
; number of sector in A
dos_loadFileTabSector:
		PUSH AF
		PUSH BC
		LD B, 0
		LD C, 0
		CALL cf_setSector	; set sector to A:0:0, LSB to MSB
		LD HL, SectorBuffer
		CALL cf_readSector	; read a sector of the file table
		POP BC
		POP AF
		RET
	
; saves one sector of the file table from memory at address SectorBuffer
; number of sector in A	
dos_saveFileTabSector:
		PUSH AF
		PUSH BC
		LD B, 0
		LD C, 0
		CALL cf_setSector	; set sector to A:0:0, LSB to MSB
		LD HL, SectorBuffer
		CALL cf_writeSector	; read a sector of the file table
		POP BC
		POP AF
		RET
		
; moves to the next file record
; within a file table sector
; record address in IY
; result in IY
dos_nextFileRecord:
		PUSH HL
		PUSH BC
		PUSH IY
		POP HL
		LD B, 0 
		LD C, FILE_RECORD_SIZE
		ADD HL, BC
		PUSH HL
		POP IY
		POP BC
		POP HL
		RET
		



		
		