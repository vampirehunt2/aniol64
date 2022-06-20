;----------------------------------------------------
; Project: aniol64.zdsp
; File: dos.asm
; Date: 9/16/2021 10:00:02
;
; Created with zDevStudio - Z80 Development Studio.
;
;----------------------------------------------------

DiskFound1 defb "Disk...", 0
DiskFound2 defb "found", 0
DiskNotFound defb "Disk not found", 0
NvRamOk: defb   "NVRAM OK", 0
NvRamNok: defb  "NVRAM Error", 0
SerialNum: defb "Serial: ", 0
Model: defb "Model: ", 0
FirmwareRev: defb "Firmware Rev: ", 0
LbaSectors: defb "LBA Sectors: ", 0

SECTOR_BUFFER equ 08400h
 
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
		LD HL, SECTOR_BUFFER
		CALL cf_di
		LD IX, SerialNum			; serial
		CALL vga_wriStr
		LD IX, SECTOR_BUFFER + 20
		LD B, 20
		CALL dos_printRecord
		CALL vga_nextLine
		LD IX, Model				; model
		CALL vga_wriStr
		LD IX, SECTOR_BUFFER + 54
		LD B, 30					; truncated to the width of the display
		CALL dos_printRecord
		CALL vga_nextLine
		LD IX, FirmwareRev			; firmware
		CALL vga_wriStr
		LD IX, SECTOR_BUFFER + 46
		LD B, 8
		CALL dos_printRecord
		CALL vga_nextLine
		LD IX, LbaSectors			; LBA sectors
		CALL vga_wriStr
	 	LD A, (SECTOR_BUFFER + 120)
		CALL mon_printByteA
		LD A, (SECTOR_BUFFER + 121)
		CALL mon_printByteA
		LD A, (SECTOR_BUFFER + 122)
		CALL mon_printByteA
		LD A, (SECTOR_BUFFER + 123)
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

dos_loadDirs:
		
		RET
		
		