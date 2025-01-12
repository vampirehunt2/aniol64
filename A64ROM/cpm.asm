; CP/M loader

cpm_InvalidParam: db "Invalid parameter", 0
cpm_Version: db "CP/M v2.2", 0

CpmRomImage equ 5C00h
CpmBase equ 0DC00h
CpmSectorSize equ 128
CpmSectorCounter equ PROGRAM_DATA
CpmSize equ 9 * 1024
CpmWarmBoot equ 0F203h


cpm_main:
    CALL str_shift
    CALL str_len
    CP 2
    JR NZ, .error
    LD A, (IX + 1)  ; +1 because of skipping the '-' character
    CP 'b'
    JR Z, cpm_boot
    CP 'i'
    JR Z, cpm_install
    CP 'f'
    JR Z, cpm_format
    CP 'v'
    JR Z, cpm_version
    ; if none of the above, fall through to error
.error:
    LD IX, cpm_InvalidParam
    CALL writeLn
    RET


; boot CP/M from ROM
cpm_boot:
    LD HL, CpmRomImage  ; address of the CP/M image in the ROM
    LD DE, CpmBase      ; target address of CP/M in upper RAM
    LD BC, CpmSize      ; CP/M size
    LDIR                ; copy CP/M from the ROM image to the target address in upper RAM
    JP CpmWarmBoot      ; address of the WBOOT entry point.
                        ; no need to jump to BOOT, as the hardware is already initialised at this point


; install CP/M to a CF disk from ROM image
cpm_install:
    LD B, CpmSize / CpmSectorSize + 1   ; number of sectors: size of CP/M in KB divided by sector size
    LD HL, CpmRomImage                  ; point HL to the beginning of the CP/M image in the ROM
    LD A, 1                             ; skipping the bootloader sector, which we don't use
    LD (CpmSectorCounter), A
.loop:
    PUSH BC                             ; save the loop counter
    LD A, (CpmSectorCounter)            ; load the current value of sector counter to be used for LBA 0:7 
    LD B, 0                             ; zero out the LBA 8:15
    LD C, 0                             ; zero out the LBA 16:23
    CALL cf_setSector                   ; Select the CF sector.
    CALL cpm_writeSector 
    LD A, (CpmSectorCounter)        
    INC A                               ; increase the sector counter
    LD (CpmSectorCounter), A            ; store the increased counter
    POP BC                              ; restore the loop counter
    DJNZ .loop                      
    RET


; format a CP/M disk
; this essentially fills the entire directory area of the CF drive with E5h
; we assume the directory area fills track 1
; note that these are CP/M tracks, not CF tracks. 
; CF drive is in LBA mode, and CP/M tracks are emulated by mapping the track number to LBA 8:15
; the CF driver doesn't have a fill routine, so this procedure talks directly to the hardware.
cpm_format
    LD A, 0     ; sector number
.sectLoop:
    LD B, 1     ; track number
    LD C, 0     ; LBA 16:24
    CALL cf_setSector
    PUSH AF
    CALL cf_waitCmd			; wait till the cf card is ready for command
	LD A, CF_WRITE			; prepare the write command
	OUT	(CF_CMD), A			; send the write command
	CALL cf_waitDat			; wait until data is ready to be written 
	LD B, 0					; write 512 bytes, 2 bytes per loop iteration
.loop:
    LD A, 0E5h
	CALL cf_wait	
	OUT (CF_DAT), A			; write a byte of data	
	CALL cf_wait
	OUT (CF_DAT), A			; write a byte of data	
	DJNZ .loop
    POP AF
    INC A
    CP 255      ; loop over all 256 sectors of track 1
    JR NZ, .sectLoop
    RET


; display CP/M version from the ROM image
cpm_version:
    LD IX, cpm_Version
    CALL writeLn
    RET

; writes a CP/M sector to a cf card
; moves HL to the next CP/M sector (128 bytes) in memory
; only writes the first out of every 4 bytes of the CF sector
; CF sectors are 512 bytes, while CP/M sectors are 128 bytes
; so we only need to use every fourth byte
; this also circumvents the issue that the fourth out of every four bytes
; does not write successfully to some CF cards
; buffer address in HL
cpm_writeSector:
    CALL cf_waitCmd			; wait till the cf card is ready for command
	LD A, CF_WRITE			; prepare the write command
	OUT	(CF_CMD), A			; send the write command
	LD B, 128				; write 128 bytes
.loop:
	CALL cf_wait	
	LD A, (HL)
	OUT (CF_DAT), A			; write a byte of data	
	INC HL
	CALL cf_wait	
	OUT (CF_DAT), A			; write and ignore a byte of data	
	CALL cf_wait	
	OUT (CF_DAT), A			; write and ignore  a byte of data	
	CALL cf_wait	
	OUT (CF_DAT), A			; write and ignore  a byte of data	
	DJNZ .loop
	RET
