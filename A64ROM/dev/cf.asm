; compact flah driver

; F0h CF card is activated by A3, with A0:A2 free
CF_BASE 		equ 11110000b	

; F0h Data (R/W)
CF_DAT 			equ	CF_BASE + 00h

; F1h Error register (R)
CF_ERR 			equ CF_BASE + 01h

; F1h Features (W)
CF_FEAT 		equ CF_BASE + 01h	

; F2h Sector count (R/W)
CF_SECT_COUNT 	equ CF_BASE + 02h	

; F3h LBA bits 0-7 (R/W, LBA mode)
CF_LBA0			equ CF_BASE + 03h	

; F4h LBA bits 8-15 (R/W, LBA mode)
CF_LBA1			equ CF_BASE + 04h

; F5h LBA bits 16-23 (R/W, LBA mode)
CF_LBA2			equ CF_BASE + 05h	

; F6h LBA bits 24-27 (R/W, LBA mode)
CF_LBA3			equ CF_BASE + 06h	

; F7h Status (R)	
CF_STATUS		equ CF_BASE + 07h		

; F7h Command (W)
CF_CMD 			equ CF_BASE + 07h			

; 01h enable 8-bit mode
CF_8BIT_MODE	equ 01h

; E0h enable LBA mode
CF_LBA_MODE		equ 0E0h

; 02h enable cache feature
CF_CACHE_ENABLE	equ 02h

; 82h disable cache feature
CF_CACHE_DISABLE equ 82h

; EFh Set Feature command
CF_SET_FEAT		equ 0EFh

; 20h Read Sector command
CF_READ			equ 20h

; 30h Write Sector command
CF_WRITE		equ 30h

; E8h write to CF onboard cache
CF_WRITE_BUFFER equ 0E8h

; E7 flush CF onboard cache
CF_FLUSH_CACHE	equ 0E7h

; 90h Disk Diagnosis command
CF_DIAG			equ 90h

; ECh Disk ID command
CF_ID			equ 0ECh

; 00h Disk Status OK
CF_OK			equ 00h


; checks if a cf drive is present in the system
; result in A
cf_exists:
	IN A, (CF_STATUS)
	CP 0
	JR NZ, .true
	CALL delay10ms
	IN A, (CF_STATUS)
	CP 0
	JR NZ, .true
	CALL delay10ms
	IN A, (CF_STATUS)
	CP 0
	JR NZ, .true
	RET				; return FALSE, ie. zero that we already have in the A register
.true:
	LD A, TRUE
	RET

	

; waits until the cf card is ready
; the READY pin on the card is optional as per the CF spec
; some cards may not implement it

cf_wait:
	PUSH AF
.loop:
	IN A, (CF_STATUS)	; read the cf status word
	BIT 7, A			; test busy bit
	JR NZ, .loop		; loop until the busy bit (D7) is clear
	POP AF
	RET

	

cf_waitCmd:
	PUSH AF
.loop:
	IN A, (CF_STATUS)	; read the cf status word
	BIT 7, A
	JR NZ, .loop		; busy bit (D7) should be 0
	BIT	6, A
	JR Z, .loop			; drvrdy (D6) should be 1 
	POP AF
	RET


cf_waitDat:
	PUSH AF
.loop:
	IN A, (CF_STATUS)	; read the cf status word
	BIT 7, A
	JR NZ, .loop		; busy bit (D7) should be 0
	BIT 3, A
	JR Z, .loop			; drq bit (D3) should be 1
	POP AF
	RET

	
; inits the cf card to 8 bit mode
cf_init:
	CALL cf_wait
	LD A, CF_8BIT_MODE	; set the 8 bit mode
	OUT	(CF_FEAT), A
	CALL cf_waitCmd
	LD A, CF_SET_FEAT	; issue the set mode command 
	OUT (CF_CMD), A
	RET
	
; returns error status of the last CR operation
; result in A
; 0 - OK
; 1 - ERROR 
cf_error:
	IN A,(CF_STATUS)					;Read status
	AND 00000001b
	RET
	

cf_di: 
	CALL cf_wait
	LD A, 1
	OUT (CF_SECT_COUNT), A	; we want to only read or write one sector at a time
	CALL cf_wait
	LD A, 1
	OUT (CF_SECT_COUNT), A	; we want to only read or write one sector at a time
	CALL cf_waitCmd			; wait until the cf is ready to accept commands 
	LD A, CF_ID			
	OUT (CF_CMD), A			; send the ID command
	LD B, 0					; read 256 double bytes
.loop:
	CALL cf_wait			; wait until busy bit (D7) is cleared
	IN A, (CF_DAT)			; read in a byte from the cf
	LD (HL), A				; store it in memory
	INC HL					; increment the memory pointer
	CALL cf_wait			; wait until busy bit (D7) is cleared
	IN A, (CF_DAT)			; read in a byte from the cf
	LD (HL), A				; store it in memory
	INC HL	
	DJNZ .loop
	RET



; reads a sector from a cf card
; buffer address in HL
cf_readSector:
	PUSH AF
	PUSH BC
	CALL cf_waitCmd			; wait till the cf card is ready for command
	LD A, CF_READ			; prepare read command
	OUT	(CF_CMD), A			; send read command
	CALL cf_wait
	LD B, 0					; read 256 bytes
.loop:
	IN A, (CF_DAT)			; get a byte of data	
	LD (HL),A
	INC HL
	DJNZ .loop
	LD B, 0
.loop2:						; read - and ignore - 256 more bytes of any value - workaround for the card issue where 2 last bytes of a sector are not written properly 
	IN A, (CF_DAT)			; get a byte of data	
	DJNZ .loop2
	POP BC
	POP AF
	RET
	


; writes a sector from a cf card
; moves HL to the next sector in memory
; buffer address in HL
cf_writeSector:
	PUSH AF
	PUSH BC
	CALL cf_waitCmd			; wait till the cf card is ready for command
	LD A, CF_WRITE			; prepare the write command
	OUT	(CF_CMD), A			; send the write command
	CALL cf_wait
	LD B, 0					; write 256 bytes
.loop:
	LD A, (HL)
	OUT (CF_DAT), A			; write a byte of data	
	INC HL
	DJNZ .loop
	LD B, 0
.loop2:						; write 256 more bytes of any value - workaround for the card issue where 2 last bytes of a sector are not written properly 
	OUT (CF_DAT), A			; write a byte of data	
	DJNZ .loop2
	POP BC
	POP AF
	RET


cf_diag:
	CALL cf_waitCmd
	LD A, CF_DIAG
	OUT (CF_CMD), A
	CALL cf_wait
	LD A, (CF_ERR)
	RET


; sets the sector number for the next IO operation
; supports up to 2^24 = 16M sectors		
; sector number in ABC, LSB to MSB
cf_setSector:
	PUSH AF
	PUSH AF
	CALL cf_wait
	LD A, 1
	OUT (CF_SECT_COUNT), A	; we want to only read or write one sector at a time
	POP AF
	CALL cf_wait
	OUT	(CF_LBA0), A		;LBA 0:7
	CALL cf_wait
	LD A, B
	OUT	(CF_LBA1), A		;LBA 8:15
	CALL cf_wait 
	LD A, C
	OUT (CF_LBA2), A		;LBA 16:23
	CALL cf_wait
	LD A, CF_LBA_MODE		;Selects CF as master
	OUT (CF_LBA3), A		;LBA 24:27 + DRV 0 selected + bits 5:7=111
	POP AF
	RET
	