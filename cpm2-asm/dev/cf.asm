; compact flah driver

CF_BASE 		equ 11110000b			; 78h CF card is activated by A3, with A0:A2 free
CF_DAT 			equ	CF_BASE + 00h		; 78h Data (R/W)
CF_ERR 			equ CF_BASE + 01h		; 79h Error register (R)
CF_FEAT 		equ CF_BASE + 01h		; 79h Features (W)
CF_SECT_COUNT 	equ CF_BASE + 02h		; 7Ah Sector count (R/W)
CF_LBA0			equ CF_BASE + 03h		; 7Bh LBA bits 0-7 (R/W, LBA mode)
CF_LBA1			equ CF_BASE + 04h		; 7Ch LBA bits 8-15 (R/W, LBA mode)
CF_LBA2			equ CF_BASE + 05h		; 7Dh LBA bits 16-23 (R/W, LBA mode)
CF_LBA3			equ CF_BASE + 06h		; 7Eh LBA bits 24-27 (R/W, LBA mode)
CF_STATUS		equ CF_BASE + 07h		; 7Fh Status (R)
CF_CMD 			equ CF_BASE + 07h		; 7Fh Command (W)	

CF_8BIT_MODE	equ 01h
CF_LBA_MODE		equ 0E0h
CF_SET_FEAT		equ 0EFh
CF_READ			equ 20h
CF_WRITE		equ 30h
CF_DIAG			equ 90h
CF_ID			equ 0ECh
CF_OK			equ 00h

	

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

; waits until the cf card is ready 
; to accept a command
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

; waits until the cf card is ready
; to exchange data
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

; reads a sector from a cf card
cf_readSector:
	CALL cf_waitCmd			; wait till the cf card is ready for command
	LD A, CF_READ			; prepare read command
	OUT	(CF_CMD), A			; send read command
	CALL cf_waitDat			; wait until data is ready to be read 
	LD HL, (DmaAddr)
	LD B, 128				
.loop:						; in this loop read a byte of data into the buffer, then read and discard the next 3 bytes
	CALL cf_wait	
	IN A, (CF_DAT)			; get a byte of data	
	LD (HL), A
	INC HL
	CALL cf_wait	
	IN A, (CF_DAT)			; get and ignore a byte of data	
	CALL cf_wait	
	IN A, (CF_DAT)			; get and ignore a byte of data
	CALL cf_wait	
	IN A, (CF_DAT)			; get and ignore a byte of data
	DJNZ .loop
	RET
	

; writes a sector to a cf card
; moves HL to the next sector in memory
; buffer address in HL
cf_writeSector:
	CALL cf_waitCmd			; wait till the cf card is ready for command
	LD A, CF_WRITE			; prepare the write command
	OUT	(CF_CMD), A			; send the write command
	CALL cf_waitDat			; wait until data is ready to be written 
	LD HL, (DmaAddr)
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

; sets the sector number for the next IO operation
cf_setSector:
	CALL cf_wait
	LD A, 1
	OUT (CF_SECT_COUNT), A	; we want to only read or write one sector at a time
	CALL cf_wait
	LD A, (Sector)
	OUT	(CF_LBA0), A		;LBA 0:7
	CALL cf_wait
	LD A, (Track)
	OUT	(CF_LBA1), A		;LBA 8:15
	CALL cf_wait 
	LD A, 0
	OUT (CF_LBA2), A		;LBA 16:23
	CALL cf_wait
	LD A, CF_LBA_MODE		;Selects CF as master
	OUT (CF_LBA3), A		;LBA 24:27 + DRV 0 selected + bits 5:7=111
	RET
	