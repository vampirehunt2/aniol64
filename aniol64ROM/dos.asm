;----------------------------------------------------
; Project: aniol64.zdsp
; File: dos.asm
; Date: 9/16/2021 10:00:02
;
; Created with zDevStudio - Z80 Development Studio.
;
;----------------------------------------------------

; dos supports the following:
; - 16kB files
; - maximum of 64 directories per logical drive, 32MB each
; - maximum of 256 logical drives per physical disk
; - maximum of 63 * 32 = 2016 files per logical drive
; - up to 8 characters for a directory name
; - file names following the 8+3 convention
; - single level directory structure. 

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
Bytes			defb " bytes", 0

; status messages
DosOk:				defb "I/O success", 0
ErrInvalidSector: 	defb "Invalid sector", 0
ErrInvDirName:		defb "Invalid directory name", 0
ErrInvFileName:		defb "Invalid file name", 0
ErrDirExists:		defb "Directory already exists", 0
ErrFileExists:		defb "File already exists", 0
ErrFileNotFound:	defb "File not found", 0
ErrTooManyDirs:		defb "Too many directories", 0
ErrNoSuchDir:		defb "No such directory", 0
ErrDiskFull:		defb "Disk full", 0
ErrNoDisk:			defb "No disk", 0
ErrUnknown:			defb "Unknown error", 0

; status codes
DOS_OK				equ 00h
INVALID_SECTOR: 	equ 01h
INVALID_DIRNAME:	equ 02h
INVALID_FILENAME:	equ 03h	
DIR_EXISTS:			equ 04h
FILE_EXISTS:		equ 05h
FILE_NOT_FOUND:		equ 06h
TOO_MANY_DIRS:		equ 07h
NO_SUCH_DIR:		equ 08h
DISK_FULL:			equ 09h
NO_DISK:			equ 0Ah

; dos strings:
FsInfo:			defb "AFS 1.0", 0
RootFolder: 	defb "/", 0
ParentFolder: 	defb "..", 0
 
; dos variables:
SectorBuffer 	equ 08400h
FileBuffer		equ 0C000h
CurrentPath 	equ DOS_AREA + 00h	; 9 bytes: 8 for the folder name and 1 for the terminating zero
CurrentDir 		equ	DOS_AREA + 09h	; index of the current directory in the directory table
TempDirname 	equ DOS_AREA + 0Ah	; 9 bytes: 8 for the folder name and 1 for the terminating zero
CurrentFileName	equ DOS_AREA + 13h	; (8059h) 13 bytes: 12 for the file name and 1 for the terminating zero
CurrentFileSize	equ DOS_AREA + 20h	; (8066h) 2 bytes
FilePtr			equ DOS_AREA + 22h	; (8068h) 2 bytes
DosErr			equ DOS_AREA + 24h	; status of the last disk I/O operation, 
DiskPresent		equ DOS_AREA + 25h
 
; filesystem constants:
MAX_DIRNAME_LEN 		equ 8
MAX_FILENAME_LEN		equ 12
FS_INFO_LEN 			equ 8
MAX_DIRS 				equ 63 
MAX_FILES 				equ 4087	; 4096 -8 for the file table and -1 for the directory table
FILE_RECORDS_PER_SECTOR equ 32
FILE_RECORD_SIZE		equ 16
FILE_TABLE_SECTORS 		equ 63
SECTOR_SIZE				equ 512

; file record structure:
Filename 	equ 00h	; null-terminated string, 
		; 12 (8+3) characters with a dot, plus the terminating zero
		; contains a zero-length string if the file record is empty
FileExists  equ 00h	; first charatcter of the file name is 0 if the file record is empty
FileDir 	equ 0Dh	; 1 byte directory index
FileLen 	equ 0Eh	; 2 byte actual file length

dos_setUpCf:
	CALL cf_exists
	CP FALSE
	JR Z, .noDisk
	LD IX, DiskFound1
	CALL writeStr
	CALL cf_init
	LD IX, DiskFound2
	CALL writeLn
	CALL dos_cdRoot
	LD A, TRUE
	LD (DiskPresent), A
	RET
.noDisk:
	LD A, FALSE
	LD (DiskPresent), A
	LD IX, DiskNotFound
	CALL writeLn
	RET


dos_cfDiskInfo:
	LD HL, SectorBuffer
	CALL cf_di
	LD IX, SerialNum		; serial
	CALL writeStr
	LD IX, SectorBuffer + 20
	LD B, 20
	CALL dos_printRecord
	CALL nextLine
	LD IX, Model		; model
	CALL writeStr
	LD IX, SectorBuffer + 54
	LD B, 30
	CALL dos_printRecord
	CALL nextLine
	LD IX, FirmwareRev		; firmware
	CALL writeStr
	LD IX, SectorBuffer + 46
	LD B, 8
	CALL dos_printRecord
	CALL nextLine
	LD IX, LbaSectors		; LBA sectors
	CALL writeStr
	LD A, (SectorBuffer + 0Eh)
	CALL mon_printByteA
	LD A, (SectorBuffer + 11h)
	CALL mon_printByteA
	LD A, (SectorBuffer + 10h)
	CALL mon_printByteA
	RET 
	
; prints B bytes from address IX
dos_printRecord:
	LD A, (IX)
	CALL putChar
	INC IX
	DJNZ dos_printRecord
	RET


dos_checkNvram:
	CALL memTest
	CP 0
	JR Z, .memTestOk
	LD IX, NvRamNok
	JP .printMemTest
.memTestOk:
	LD IX, NvRamOk
	JP .printMemTest
.printMemTest:
	CALL writeLn
	RET



dos_load:
	CALL str_shift
	CALL str_tok
	PUSH HL		; push address of the rest of the string
	CALL parseDByte	; address of buffer to save now in HL
	CP OK
	JR NZ, .invalidAddress
	POP IX		; address of the rest of the string now in IX
	PUSH HL		; push buffer address
	CALL parseDByte	; sector number now in HL
	CP OK
	JR NZ, .invalidSector
	LD A, L		
	LD B, H
	LD C, 0		; sector number now in ABC, in the future, the logical drive number will go in C
	POP HL		; buffer address now in HL
	CALL cf_setSector
	CALL cf_readSector
	RET
.invalidAddress:
	LD IX, InvAddr
	CALL writeLn
	RET
.invalidSector:
	LD IX, ErrInvalidSector
	CALL writeLn
	RET

	

dos_save:
	CALL str_shift
	CALL str_tok
	PUSH HL		; push address of the rest of the string
	CALL parseDByte	; address of buffer to save now in HL
	CP OK
	JR NZ, .invalidAddress
	POP IX		; address of the rest of the string now in IX
	PUSH HL		; push buffer address
	CALL parseDByte	; sector number now in HL
	CP OK
	JR NZ, .invalidSector
	LD A, L		
	LD B, H
	LD C, 0		; sector number now in ABC
	POP HL		; buffer address now in HL
	CALL cf_setSector
	CALL cf_writeSector
	RET
.invalidAddress:
	LD IX, InvAddr
	CALL writeLn
	RET
.invalidSector:
	LD IX, ErrInvalidSector
	CALL writeLn
	RET



; formats a compact flash disk to AFS 1.0
; destroys A, HL, BC, DE, IX, IY
dos_format:
	XOR A		   ; LD A, 0
	LD HL, SectorBuffer
	LD DE, SectorBuffer + 1
	LD (HL), A   	; initialise the first byte of SectorBuffer to 0
	LD BC, 512   	; set loop counter to the full size of SectorBuffer
	LDIR		 	; repeatedly copy previous byte to the current byte
	LD B, A			; set B to 0	
	LD C, A			; set C to 0
	LD A, FILE_TABLE_SECTORS
.loop:	
	PUSH AF
	LD HL, SectorBuffer
	CALL cf_setSector
	CALL cf_writeSector
	POP AF
	DEC A
	CP 0			; skipping the directory table sector
	JR NZ, .loop
	LD IX, FsInfo	; save the directory table
	LD IY, SectorBuffer
	CALL str_copy
	XOR A		   	; LD A, 0
	LD B, A			; set B to 0	
	LD C, A			; set C to 0
	LD HL, SectorBuffer
	CALL cf_setSector
	CALL cf_writeSector
	RET


; gets the success/error message associated with an error code
; error code passed in DosErr
; result in IX
dos_getStatusMsg:
	PUSH AF
	LD A, (DosErr)
	CP DOS_OK
	JR Z, .ok
	CP INVALID_SECTOR
	JR Z, .invSector
	CP INVALID_DIRNAME
	JR Z, .invDirname
	CP INVALID_FILENAME
	JR Z, .invFilename
	CP DIR_EXISTS
	JR Z, .dirExists
	CP FILE_EXISTS
	JR Z, .fileExists
	CP FILE_NOT_FOUND
	JR Z, .fileNotFound
	CP TOO_MANY_DIRS
	JR Z, .tooManyDirs
	CP NO_SUCH_DIR
	JR Z, .noSuchDir
	CP DISK_FULL
	JR Z, .diskFull
	CP NO_DISK
	JR Z, .noDisk
	LD IX, ErrUnknown
	JR .end
.ok:
	LD IX, DosOk
	JR .end
.invSector:
	LD IX, ErrInvalidSector
	JR .end
.invDirname
	LD IX, ErrInvDirName
	JR .end
.invFilename:
	LD IX, ErrInvFileName
	JR .end
.dirExists
	LD IX, ErrDirExists
	JR .end
.fileExists:
	LD IX, ErrFileExists
	JR .end
.fileNotFound:
	LD IX, ErrFileNotFound
	JR .end
.tooManyDirs:
	LD IX, ErrTooManyDirs
	JR .end
.noSuchDir:
	LD IX, ErrNoSuchDir
	JR .end
.diskFull:
	LD IX, ErrDiskFull
	JR .end
.noDisk:
	LD IX, ErrNoDisk
	JR .end
.end:
	POP AF
	RET


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
	LD C, 0		; in the future, the logical drive number will go in C
	CALL cf_setSector
	LD HL, SectorBuffer
	CALL cf_writeSector
	POP HL
	POP DE
	POP BC
	RET

; lists on the screen all the directories in the root directory

dos_listDirs:
	PUSH BC		; save register state
	PUSH DE
	PUSH IX
	LD E, MAX_DIRS
	CALL dos_loadDirs
	LD IX, SectorBuffer + FS_INFO_LEN
.checkDir:
	PUSH IX
	LD A, (IX)
	CP 0		; check if a directory entry is present
	JR Z, .nextDir
	LD B, MAX_DIRNAME_LEN
	LD IY, LineBuff
	CALL str_2str
	CALL writeLn
.nextDir:
	POP IX
	CALL dos_nextDir
	DEC E				; decrement directory record counter
	JP NZ, .checkDir	; if haven't reached the end of the directory sector, fetch the next directory
.end:
	POP IX
	POP DE		; restore register state	
	POP BC
	RET


; lists on the screen all the files in the current directory

dos_listFiles:
	LD A, 01h		; the first sector of the file table. Counting sectors in A
.loop:
	PUSH AF
	CALL dos_loadFileTabSector
	CALL dos_listFilesInSector
	POP AF
	INC A
	CP FILE_TABLE_SECTORS
	JR NZ, .loop
	RET



dos_listFilesInSector:
	PUSH IY
	PUSH BC
	LD IY, SectorBuffer
	LD B, FILE_RECORDS_PER_SECTOR
.loop:
	LD A, (IY + FileExists)
	CP FALSE
	JR Z, .continue
	LD A, (IY + FileDir)	; read directory index of the file
	LD C, A					; store directory index of the file in C
	LD A, (CurrentDir)		; load the current directory into A
	CP C					; check if directory index of the file record equals the current directory
	JR NZ, .continue
	PUSH IY
	POP IX
	CALL writeStr
	CALL dos_tabFileName
	LD A, (IY + FileLen)
	LD L, A
	LD A, (IY + FileLen + 1)
	LD H, A
	CALL u16_formatDec
	CALL writeStr
	LD IX, Bytes
	CALL writeLn
.continue:
	CALL dos_nextFileRecord
	DJNZ .loop
	POP BC
	POP IY
	RET



dos_tabFileName:
	PUSH AF
	PUSH BC
	CALL str_len
	LD B, A
	LD A, MAX_FILENAME_LEN
	SUB B
	INC A
	LD B, A
	LD A, ' '
.loop:
	CALL putChar
	DJNZ .loop
	POP BC
	POP AF
	RET




dos_rm:
	CALL str_shift
	CALL dos_fileExists
	CP 0
	JR Z, .notFound
	PUSH AF
	LD A, FALSE
	LD (IY + FileExists), A
	POP AF
	CALL dos_saveFileTabSector
	RET
.notFound:
	LD IX, ErrFileNotFound
	CALL writeLn
	RET



dos_rmDir:
	CALL str_shift
	CALL dos_loadDirs
	LD E, MAX_DIRS
	PUSH IX
	POP IY
	LD IX, SectorBuffer + FS_INFO_LEN
.loop:
	LD B, MAX_DIRNAME_LEN
	CALL str_cmpMem
	JR Z, .rm
	CALL dos_nextDir
	DEC E
	JR NZ, .loop
	LD A, 0
	LD IX, ErrNoSuchDir
	CALL writeLn
	JR .end
.rm:
	LD A, 0
	LD (IX), A
	CALL dos_saveDirs
.end:
	RET




dos_mkDir:
	PUSH BC		; save register state
	PUSH DE
	; check if dir name is valid
	CALL str_shift
	CALL dos_validateDirname
	CP TRUE
	JP NZ, .invName
	CALL dos_dirExists
	CP 0
	JR NZ, .exists
	; if valid, proceed
	LD E, MAX_DIRS
	LD IX, SectorBuffer + FS_INFO_LEN
.checkDir:
	LD A, (IX)
	CP 0		; check if a directory entry is present
	JR Z, .makeDir
	CALL dos_nextDir
	DEC E		; decrement directory record counter
	JP NZ, .checkDir; if haven't reached the end of the directory sector, fetch the next directory
	JP .tooMany	; maximum number of directories on the disk has been reached
.makeDir:
	PUSH IX
	POP IY		; transfer buffer address from IX to IY
	PUSH HL
	POP IX		; transfer name of directory from HL to IX
	CALL str_2mem
	CALL dos_saveDirs
	JP .end
.invName:
	LD IX, ErrInvDirName
	CALL writeLn
	JR .end
.exists:
	LD IX, ErrDirExists
	CALL writeLn
	JR .end
.tooMany:
	LD IX, ErrTooManyDirs
	CALL writeLn
	JR .end
.end:
	POP DE		; restore register state	
	POP BC
	RET


; checks if the string at IX represents a valid directory name

dos_validateDirname:
	PUSH IX
	CALL str_len
	CP 0
	JR Z, .false
	CP MAX_DIRNAME_LEN		
	JR NC, .false
.loop:
	LD A, (IX)
	CP 0
	JR Z, .true
	CALL isAlphanumeric
	CP FALSE
	JR Z, .false
	INC IX
	JR .loop
.true:
	LD A, TRUE
	JR .end
.false:
	LD A, FALSE
	JR .end
.end:
	POP IX
	RET	


; checks if the string at IX represents a valid file name
; result in A

dos_validateFilename:
	PUSH IX
	CALL str_len
	CP 0
	JR Z, .false
	CP MAX_FILENAME_LEN	
	JR Z, .loop	
	JR NC, .false
.loop:
	LD A, (IX)
	CP 0
	JR Z, .true
	CP '.'
	JR Z, .next		; dots are allowed
	CALL isAlphanumeric
	CP TRUE
	JR Z, .next		; as are alphanumeric characters
	JR .false		; any other character is disallowed
.next:
	INC IX
	JR .loop
.true:
	LD A, TRUE
	JR .end
.false:
	LD A, FALSE
	JR .end
.end:
	POP IX
	RET	


; checks if a directory with a given name exists
; IX - directory name
; result in A:
; - 0 if the directory doesn't exist
; - directory index if it exists
; destroys IY, DE

dos_dirExists:
	CALL dos_loadDirs
	LD D, 1
	LD E, MAX_DIRS
	PUSH IX
	POP IY
	LD IX, SectorBuffer + FS_INFO_LEN
.loop:
	LD B, MAX_DIRNAME_LEN
	CALL str_cmpMem
	JR Z, .yes
	CALL dos_nextDir
	INC D
	DEC E
	JR NZ, .loop
	LD A, 0
	RET
.yes:
	LD A, D
	RET


; moves IX over by the number of bytes corresponding to the length of a directory entry

dos_nextDir:
	PUSH BC
	LD B, MAX_DIRNAME_LEN		; length of directory entry
.loop:
	INC IX
	DJNZ .loop
	POP BC
	RET


dos_pwd:
	LD IX, CurrentPath
	CALL writeLn
	RET
	
; changes the current dir to be the root dir	
dos_cdRoot:
	LD IX, RootFolder
	LD IY, CurrentPath
	CALL str_copy
	LD A, 0
	LD (CurrentDir), A
	RET
	

dos_cd:
	CALL str_shift	; transfer folder name from HL to IX
	; check if user wants to go to the root folder
	LD IY, RootFolder
	CALL str_cmp
	JR Z, .root
	LD IY, ParentFolder
	CALL str_cmp
	JR Z, .root
	; if user isn't going to the root folder, find the appropriate folder
	CALL dos_dirExists
	JR Z, .noDir
	LD (CurrentDir), A
	LD IY, CurrentPath
	CALL str_copy
	JR .end
.noDir:
	LD IX, ErrNoSuchDir
	CALL writeLn
	JR .end
.root:
	CALL dos_cdRoot
.end:
	RET



dos_ls:
	LD A, (CurrentDir)
	CP 0
	JR NZ, .listFiles
	CALL dos_listDirs
.listFiles:
	CALL dos_listFiles
	RET


; creates an empty file
; IX: file name

dos_touch:
	CALL str_shift
	CALL dos_validateFilename	; first, check if the given file name is valid...
	CP FALSE			; ...as this doesn't require reding any data from disk 
	JR Z, .invName
	CALL dos_fileExists		; check if file already exists in the current directory
	CP FALSE
	JR NZ, .fileExists
	CALL dos_findFreeFileSlot
	CP FALSE			; check if a free slot exists
	JR Z, .diskFull
	PUSH AF			; save file table sector number on stack
	CALL str_copy		; copy the file name from the command line to the file record
	LD A, (CurrentDir)
	LD (IY + FileDir), A	; copy the current directory to the file record
	LD A, 0
	LD (IY + FileLen), A	; set the file to zero length
	LD (IY + FileLen + 1), A
	POP AF			; restore file table sector number from stack
	CALL dos_saveFileTabSector
	JR .end
.diskFull:	
	LD IX, ErrDiskFull
	CALL writeLn
	JR .end
.fileExists:
	LD IX, ErrFileExists
	CALL writeLn
	JR .end
.invName:
	LD IX, ErrInvFileName
	CALL writeLn
	JR .end
.end:
	RET



; finds a free file slot
; A - FALSE if a free slot does not exist
;	- sector number otherwise
; IY - address of the file record in sector buffer in memory
; C -  the index of the file record within the file table sector
; destroys HL
dos_findFreeFileSlot:
	LD A, 01h		; the first sector of the file table. Counting sectors in A
.loop:
	PUSH AF
	CALL dos_loadFileTabSector
	CALL dos_findFreeFileSlotInSector
	CP FALSE
	JR NZ, .found
	POP AF
	INC A
	CP FILE_TABLE_SECTORS
	JR NZ, .loop
	LD A, FALSE
	RET
.found:
	POP AF
	RET


; finds a free file slot (empty file record) in the SectorBuffer
; result in A
; if A is true, IY points to the beginning of the file record
; and C is the index of the file record within the file table sector

dos_findFreeFileSlotInSector:
	LD IY, SectorBuffer
	LD B, FILE_RECORDS_PER_SECTOR
	LD C, 0
.loop:
	LD A, (IY + FileExists)
	CP 0
	JR Z, .found
	CALL dos_nextFileRecord
	INC C
	DJNZ .loop
	LD A, FALSE
	RET
.found:
	LD A, TRUE
	RET



; checks whether a file with a given name exists in the current directory
; IX: file name
; result: 
; - 0 in A if file not found
; - if file found, then
; -- file table sector number in A
; -- index of file record within sector in C
; -- file record address in memory in IY
dos_fileExists:
	LD A, 01h		; the first sector of the file table
.loop:
	PUSH AF
	CALL dos_loadFileTabSector
	CALL dos_fileExistsInSector
	CP TRUE
	JR Z, .found
	POP AF
	INC A
	CP FILE_TABLE_SECTORS
	JR NZ, .loop
	LD A, FALSE
	RET
.found:
	POP AF
	RET



; checks whether a file with a given name exists 
; in the current file table sector
; IX: file name
; result: 
; - FALSE in A if file not found
; - if file found, then
; -- TRUE in A
; -- index of file record withing sector in C
; -- file record address in memory in IY
dos_fileExistsInSector:
	PUSH DE
	LD IY, SectorBuffer
	LD B, FILE_RECORDS_PER_SECTOR
	LD C, 0
.loop:
	LD A, (IY + FileDir)	; read directory index of the file
	LD D, A					; store directory index of the file in D
	LD A, (CurrentDir)		; load the current directory into A
	CP D					; check if directory index of the file record equals the current directory
	JR NZ, .continue	 	; if not, skip the current file record
	CALL str_cmp			; check if file has the same name		
	JR NZ, .continue		; if not, skip the current file record
	LD A, TRUE
	JR .end
.continue:
	CALL dos_nextFileRecord
	INC C
	DJNZ .loop
	LD A, FALSE
.end:
	POP DE
	RET


; loads one sector of the file table into memory at address SectorBuffer
; number of sector in A
dos_loadFileTabSector:
	PUSH AF
	PUSH BC
	LD B, 0
	LD C, 0		; in the future, the logical drive number will go in C
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
	LD C, 0		; in the future, the logical drive number will go in C
	CALL cf_setSector	; set sector to A:0:0, LSB to MSB
	LD HL, SectorBuffer
	CALL cf_writeSector	; write a sector of the file table
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


; computes the number of sectors required to store a file of a given size
; file size in DE
; result in E
dos_requiredSectors:
	PUSH AF
	PUSH BC
	LD A, 0
	LD B, 9
.div:			; divides the number of bytes by sector size
	SRL E
	RR D
	JR NC, .cont
	LD A, 1		; a non-zero bit was shifted out, meaning there is one extra, incomplete sector needed.
.cont:
	DJNZ .div
	CP 0
	JR Z, .end
	INC E
.end:
	POP BC
	POP AF
	RET

; file table sector number in A
; file record position in file table sector in C
; returns first file sector number of a file within a logical drive in AB, LSB to MSB
dos_computeSector:
	PUSH DE
	DEC A 		; decreasing A by one to account for the directory table sector
	LD B, 5
	LD D, 0
.mul:			; multiply AD by 32, as in 32 file records per sector
	AND A 		; clear carry
	RLA			; multiply A by 2
	RL D		; multiply D by 2
	DJNZ .mul
	AND A 		; clear carry
	ADC A, C   	; add the number of the file record in the file table sector
	JR NC, .skip
	INC D
.skip:
	LD B, 5
.mul2:			; multiply AD by 32, as in 32 sectors per file
	AND A 		; clear carry
	RLA			; multiply A by 2
	RL D		; multiply D by 2
	DJNZ .mul2
	AND A		; clear carry
	ADC A, FILE_TABLE_SECTORS + 1
	JR NC, .skip2
	INC D
.skip2:
	LD B, D
	POP DE
	RET

; moves AB to the next sector number within the current logical disk
dos_nextSector:
	INC A
	RET NZ
	INC B
	RET

; saves a file with the name given in IX
cmd_saveFileAs:
	CALL str_shift
	LD IY, CurrentFileName
	CALL str_copy
	CALL cmd_saveFile
	RET

; saves a file with the name given in CurrentFileName
cmd_saveFile:
	CALL dos_saveFile
	LD A, (DosErr)
	CP DOS_OK
	RET Z
	CALL dos_getStatusMsg
	CALL writeLn
	RET

; Saves a file to disk
; file metadata passed in memory
; file name in CurrentFilename
dos_saveFile:
	LD A, (DiskPresent)
	CP TRUE
	JR NZ, .noDisk
	LD IX, CurrentFileName
	CALL dos_validateFilename	; first, check if the given file name is valid...
	CP FALSE					; ...as this doesn't require reding any data from disk 
	JR Z, .invName
	CALL dos_fileExists			; check if file already exists in the current directory
	CP FALSE					; if yes, overwrite the existing file
	JR NZ, .cont
	CALL dos_findFreeFileSlot	; otherwise find a new free spot
	CP FALSE					; check if a free slot exists
	JR Z, .diskFull
.cont:
	PUSH AF						; save file table sector number on stack
	CALL str_copy				; copy the file name from the command line to the file record
	LD A, (CurrentDir)
	LD (IY + FileDir), A		; copy the current directory to the file record
	LD A, (CurrentFileSize)
	LD (IY + FileLen), A		; set the file length
	LD A, (CurrentFileSize + 1)
	LD (IY + FileLen + 1), A	; set the file length
	POP AF						; restore file table sector number from stack
	CALL dos_saveFileTabSector
	LD DE, (CurrentFileSize)
	CALL dos_requiredSectors	; number of required sectors now in E
	CALL dos_computeSector		; sector number in AB
	LD HL, FileBuffer
	LD C, 0						; TODO: logical drive number goes here
.loop:
	CALL cf_setSector
	CALL cf_writeSector
	CALL dos_nextSector
	DEC E
	JR NZ, .loop
	LD A, DOS_OK
	LD (DosErr), A
	RET
.diskFull:	
	LD A, DISK_FULL
	LD (DosErr), A
	RET
.invName:
	LD A, INVALID_FILENAME
	LD (DosErr), A
	RET
.noDisk:
	LD A, NO_DISK
	LD (DosErr), A
	RET
	
cmd_loadFile:
	CALL str_shift
	CALL dos_loadFile
	LD A, (DosErr)
	CP DOS_OK
	RET Z
	CALL dos_getStatusMsg
	CALL writeLn
	RET

dos_loadFile:
	LD A, (DiskPresent)
	CP TRUE
	JP NZ, .noDisk
	CALL dos_fileExists			; check if file already exists in the current directory... 
	CP 0						; ...sets IY to the file record address
	JP Z, .notFound
	PUSH AF						; save file table sector number on stack
	; copy file attributes
	LD A, (IY + FileLen)
	LD (CurrentFileSize), A		; set the file length, lower byte
	LD E, A
	LD A, (IY + FileLen + 1)
	LD (CurrentFileSize + 1), A	; set the file length, upper byte
	LD D, A						; file size now in DE
	; store filename
	LD IX, CurrentFileName
.nameCpyLoop:
	LD A, (IY + Filename)
	CP 0
	JR Z, .endNameCpy
	LD (IX), A
	INC IX
	INC IY
	JR .nameCpyLoop
.endNameCpy:
	LD (IX), A
	POP AF						; restore file table sector number from stack
	; load the file
	CALL dos_requiredSectors	; number of required sectors now in E
	CALL dos_computeSector		; sector number in AB
	PUSH AF
	LD A, E						; check for zero-length files
	CP 0
	POP AF
	JR Z, .end					; don't do anything if file is zero-length
	LD HL, FileBuffer
	LD C, 0
.loop:
	CALL cf_setSector
	CALL cf_readSector
	CALL dos_nextSector
	DEC E
	JR NZ, .loop
.end:
	call dos_reset
	LD A, DOS_OK
	LD (DosErr), A
	RET
.notFound:
	LD A, FILE_NOT_FOUND
	LD (DosErr), A
	RET
.noDisk:
	LD A, NO_DISK
	LD (DosErr), A
	RET

dos_cat:
	CALL str_shift
	CALL dos_loadFile
	LD A, (DosErr)
	CP DOS_OK
	JR NZ, .err
	LD HL, (CurrentFileSize)
	LD IX, FileBuffer
.loop:
	LD A, 0
	CP H
	JR NZ, .cont
	CP L
	JR NZ, .cont
	CALL nextLine
	RET
.cont:
	LD A, (IX)
	CALL putChar
	INC IX
	DEC HL
	JR .loop
.err:
	CALL dos_getStatusMsg
	CALL writeLn
	RET

dos_seek:
	LD (FilePtr), HL
	RET
	
dos_fRead:
	PUSH BC
	PUSH HL
	LD HL, (FilePtr)
	LD BC, FileBuffer
	ADD HL, BC
	LD A, (HL)
	LD HL, (FilePtr)
	INC HL
	LD (FilePtr), HL
	POP HL
	POP BC
	RET

; reads a line from file into a specified buffer
; buffer address passed in IX
; destroys A
dos_fReadLn:
	PUSH IX
.loop:
	CALL dos_eof
	CP TRUE
	JR Z, .end
	CALL dos_fRead
	CP CR
	JR Z, .end
	LD (IX), A
	INC IX
	JR .loop
.end:
	LD A, 0
	LD (IX), A
	POP IX
	RET

dos_fWriteLine:
	PUSH IX
.loop:
	LD A, (IX)
	CP 0
	JR Z, .end
	CP CR
	JR Z, .end
	CALL dos_fWrite
	JR .loop
.end:
	POP IX
	RET
	
dos_fPeek:
	PUSH BC
	PUSH HL
	LD HL, (FilePtr)
	LD BC, FileBuffer
	ADD HL, BC
	LD A, (HL)
	POP HL
	POP BC
	RET
	

dos_fWrite:
	PUSH BC
	PUSH HL
	LD B, A		; store the byte in B for safekeeping
	CALL dos_eof
	CP FALSE
	JR Z, .skip
	CALL dos_expand
.skip:
	LD A, B		; restore the byte to be written to A
	LD HL, (FilePtr)
	INC HL
	LD BC, FileBuffer
	ADD HL, BC
	LD (HL), A
	LD HL, (FilePtr)
	INC HL
	LD (FilePtr), HL
	POP HL
	POP BC
	RET

dos_eof:
	PUSH HL
	PUSH BC
	LD BC, (FilePtr)
	LD HL, (CurrentFileSize)
	AND A		; clear carry
	SBC HL, BC
	JR C, .true
	JR Z, .true
	LD A, FALSE
	JR .end
.true:
	LD A, TRUE
.end:
	POP BC
	POP HL
	RET

dos_expand:
	PUSH HL
	LD HL, (CurrentFileSize)
	INC HL
	LD (CurrentFileSize), HL
	POP HL
	RET
	
dos_reset:
	PUSH HL
	LD HL, 0
	LD (FilePtr), HL
	POP HL
	RET


	