
; POWER-ON/RESET
; http://cpuville.com/Code/CPM-on-a-new-computer.html
bios_boot:
    ; CALL dspInit
    ; CALL keyInit
    ; CALL cf_init
    // fall through to wboot

; WARM BOOT
bios_wboot:
    LD HL, 0000h
    LD (HL), 0C3h       ; JP instruction
    INC HL              ; HL = 1
    LD (HL), 03h        ; bios_wboot lower address byte
    INC HL              ; HL = 2
    LD (HL), 0F2h       ; bios_wboot higher address byte
    INC HL              ; HL = 3
    LD (HL), 00000001b  ; IOBYTE, as per http://www.gaby.de/cpm/manuals/archive/cpm22htm/ch6.htm#Section_6.6
                        ; Console assigned to CRT
    INC HL              ; HL = 4
    LD (HL), 00h        ; user = 0, disk = 0
    INC HL              ; HL = 5
    LD (HL), 0C3h       ; JP instruction
    INC HL              ; HL = 6
    LD (HL), 06h        ; bdos entry point lower address byte
    INC HL              ; HL = 7
    LD (HL), 0E4h       ; bdos entry point higher address byte
    LD C, 0             ; pass current disk number to CCP in C
    JP COMMAND

;CONSOLE STATUS, RETURN 0FFH IF CHARACTER READY, 00H IF NOT
bios_const:
    LD A, (lastChar)        ; checking what the previous character read was
    CP 13                   ; if it was a CR, another character, an LF, is available
    JR Z, .yes
    CALL keyPressed
    JR Z, .no
.yes:
    LD A, 0FFh
    RET
.no:
    LD A, 0
    RET

;CONSOLE CHARACTER INTO REGISTER A
lastChar: db 0
bios_conin:
    LD A, (lastChar)        ; checking what the previous character read was
    CP 13                   ; if it was a CR, just return an LF
    JR NZ, .cont
    LD A, 10                ; load LF into A
    LD (lastChar), A
    RET
.cont:
    CALL readKey
    LD (lastChar), A        ; saving the character read, in case it's a CR
    RET

;CONSOLE CHARACTER OUTPUT FROM REGISTER C
bios_conout:
    LD A, C
    CP 10       ; ignore line feeds, the terminal adds them automatically
    RET Z
    CALL putChar
    RET

; 12: Printer output
bios_list	
    // no printer support yet
    RET

;15: Paper tape punch output
bios_punch:
    // no tape punch support
    RET 
    
;18: Paper tape reader input
bios_reader:
// no tape punch support
    RET
	
;21: Move disc head to track 0
bios_home:	
    LD A, 0
    LD (Sector), A
    LD (Track), A
    RET

;24: Select disc drive
bios_seldsk:
    LD 	HL, 0000h 	;error return code
	LD 	A, C
	CP 	0 	; only have one disk for now
	RET NZ 	
    ; disk number is OK from here on down
	LD 	HL, DiskParams  ; return the disk params table. It's the same for all disks
    RET

;27: Set track number
bios_settrk:  
    LD A, C
    LD (Track), A
    RET

;30: Set sector number
bios_setsec:
    LD (Sector), A
    RET

;33: Set DMA address
bios_setdma:
    LD (DmaAddr), BC
    RET

;36: Read a sector
bios_read:
    CALL cf_setSector
    CALL cf_readSector
    LD A, 00h   ; success
    RET

;39: Write a sector
bios_write:
    CALL cf_setSector
    CALL cf_writeSector
    LD A, 00h   ; success
    RET

;42: Status of list device
bios_listst:
    // no printer support yet
    RET

;45: Sector translation for skewing
; no translation in this case
bios_sectran:
    LD H, B
    LD L, C
    RET

; device drivers
 include "dev/ps2.asm"
 include "dev/tm.asm"
 ; include "dev/bzr.asm"
 include "dev/cf.asm"

; bios variables
Disk: db 0
Track: db 0
Sector: db 0
DmaAddr: dw 00

; disk parameter table (same for all disks)
DiskParams: 	
    defw 0000h                  ; no skew table 
    defw 0000h, 0000h,0000h     ; CP/M scratch area 
	defw DirBuffer              ; directory buffer (we have to provide it) address
    defw DiskParamBlock         ; disk parameter block address
	defw 0000h                  ; check for removed floppy. We can ignore it, as hotswapping CF cards is not supported. Set it to 0
    defw ALV                    ; allocation vector

DSM equ 4087                    ; DSM: max allocation block number (minus the blocks reserved for the OS)

DiskParamBlock:
    defw 0100h                  ; SPT: 256 sectors per track
    defb 4                      ; BSH: these three values correspond to a 2k allocation block size
    defb 15                     ; BLM
    defb 0                      ; EXM 
    defw DSM                    ; DSM: max allocation block number (minus the blocks reserved for the OS)
    defw 511                    ; DRM: Directory entries minus 1
    defw 0FF00h                 ; AL0, AL1: 16 2k allocation block dedicated to directory entries
    defw 0                      ; CKS: no directory checksum (because of fixed disk)
    defw 1                      ; OFFset: number of tracks reserved for the OS

ALV: ds (DSM / 8) + 1
    
DirBuffer: ds 128

 defb "EndOfBios"
