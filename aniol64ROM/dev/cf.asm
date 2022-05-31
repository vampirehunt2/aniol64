; compact flah driver
 
CF_BASE 		equ 01111000b			; 78h CF card is on the expansion port, activated by A7, with A0:A2 free
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

PROC
; checks if a cf drive is present in the system
; result in A
cf_exists:
		IN A, (CF_STATUS)
		CP 0
		JR NZ, _true
		CALL delay10ms
		IN A, (CF_STATUS)
		CP 0
		JR NZ, _true
		CALL delay10ms
		IN A, (CF_STATUS)
		CP 0
		JR NZ, _true
		RET				; return FALSE, ie. zero that we already have in the A register
_true:
		LD A, TRUE
		RET
ENDP
		

; waits until the cf card is ready
; the READY pin on the card is optional as per the CF spec
; some cards may not implement it
cf_wait:
		IN A, (CF_STATUS)	; read the cf status word
		BIT 7, A			; test busy bit
		JR NZ, cf_wait		; loop until the busy bit (D7) is clear
		RET
	
cf_waitCmd:
		IN A, (CF_STATUS)	; read the cf status word
		BIT 7, A
		JR NZ, cf_waitCmd	; busy bit (D7) should be 0
		BIT	6, A
		JR Z, cf_waitCmd	; drvrdy (D6) should be 1 
		RET

cf_waitDat:
		IN A, (CF_STATUS)	; read the cf status word
		BIT 7, A
		JR NZ, cf_waitDat	; busy bit (D7) should be 0
		BIT 3, A
		JR Z, cf_waitDat	; drq bit (D3) should be 1
		RET
	
; inits the cf card to 8 bit mode
cf_init:
		CALL cf_wait
		LD A, 1
		OUT (CF_SECT_COUNT), A	; we want to only read or write one sector at a time
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
 
PROC
; reads a sector from a cf card
; buffer address in HL
cf_readSector:
		CALL cf_waitCmd			; wait till the cf card is ready for command
		LD A, CF_READ			; prepare read command
		OUT	(CF_CMD), A			; send read command
		CALL cf_waitDat			; wait until data is ready to be read 
		LD B, 0					; read 512 bytes, 2 bytes per loop iteration
_loop:
		CALL cf_waitDat	
		IN A, (CF_DAT)			; get a byte of data	
		LD (HL),A
		INC HL
		CALL cf_waitDat
		IN A, (CF_DAT)			;get a byte of data	
		LD (HL), A
		INC HL
		DJNZ _loop
		RET
ENDP	

cf_diag:
		CALL cf_waitCmd
		LD A, CF_DIAG
		OUT (CF_CMD), A
		CALL cf_wait
		LD A, (CF_ERR)
		RET

PROC
cf_di: 
		CALL cf_waitCmd			; wait until the cf is ready to accept commands 
		LD A, CF_ID			
		OUT (CF_CMD), A			; send the ID command
		LD B, 0					; read 256 double bytes
_loop:
		CALL cf_wait			; wait until busy bit (D7) is cleared
		IN A, (CF_DAT)			; read in a byte from the cf
		LD (HL), A				; store it in memory
		INC HL					; increment the memory pointer
		CALL cf_wait			; wait until busy bit (D7) is cleared
		IN A, (CF_DAT)			; read in a byte from the cf
		LD (HL), A				; store it in memory
		INC HL	
		DJNZ _loop
		RET
ENDP

;cf_di:
		;CALL cf_wait_cmd		; wait until the cf is ready to accept commands
		;LD A, CF_ID			
		;OUT (CF_CMD), A		; send the ID command
		;CALL cf_wait			
		;IN A, (CF_STATUS)		; load the status word
		;BIT 3, A				; check if there is data to be read
		;RET Z					; if no more data left, exit
		;CALL cf_wait			
		;IN A, (CF_DAT)			; read next byte of data
		;LD (HL), A				; store it in memory
		;INC HL					; increment HL
		;JR cf_di				; rinse and repeat
		;RET









; reads sector 0 into a buffer
; buffer address in HL
cf_readSect0:
		CALL cf_wait
		LD A, 0
		OUT	(CF_LBA0), A		;LBA 0:7
		CALL cf_wait
		LD A, 0
		OUT	(CF_LBA1), A		;LBA 8:15
		CALL cf_wait 
		LD A, 0
		OUT (CF_LBA2), A		;LBA 16:23
		CALL cf_wait
		LD A, CF_LBA_MODE		;Selects CF as master
		OUT (CF_LBA3), A		;LBA 24:27 + DRV 0 selected + bits 5:7=111
		CALL cf_readSector
		RET
	