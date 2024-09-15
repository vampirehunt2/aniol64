;----------------------------------------------------
; Project: aniol64.zdsp
; File: mem.asm
; Date: 10/1/2021 15:20:21
;
; Created with zDevStudio - Z80 Development Studio.
;
;----------------------------------------------------

BANK_PORT equ 11011111b  ; DFh bank switching is activated with A5
MEM_ERR equ 1
MEM_TEST: defb "MemTst", 0


; checks if NV RAM is installed
; returns 0 in A if non-volatile memory is found
; returns non-zero in A if data from previous run is not found
; this may happen if volatile RAM is installed
; or when it's the first run of the computer
memTest:
	LD IX, MEM_TEST
	LD IY, TestAddr
	CALL str_cmp	; checks if RAM already contains the test string
	CP 0
	RET Z		   ; if test string found, return 0 in A
	LD IX, MEM_TEST ; otherwise copy it into the memory
	LD IY, TestAddr
	CALL str_copy
	LD A, MEM_ERR
	RET
	
copyRom2Ram:
	LD HL, 00h
	LD DE, 00h
	LD BC, 8000h
	LDIR
	LD A, 00
	OUT (0DFh), A
	RET

mem_cpy:
	RET


; sets the currently switched in ROM bank
; A - ROM bank to switch in, 0-7
setRomBank:
	PUSH BC		 ; save current state of BC
	AND 00000111b   ; make sure the RAM bank is not switched by accident
	LD B, A		 ; move the ROM bank number to B
	LD A, (Banks)   ; load the currently switched in banks for ROM and RAM
	AND 11111000b   ; clear the current ROM bank number, leave current RAM bank number intact
	OR B			; set the new ROM bank number
	LD C, BANK_PORT
	OUT (C), A	  ; write the bank numbers to the bank switch register
	LD (Banks), A   ; save the bank numbers to memory
	POP BC		  ; restore original state of BC
	RET

; sets the currently switched in RAM bank
; A - RAM bank to switch in, 0-31, top three bits are ignored.
setRamBank:
	PUSH BC		 ; save current state of BC
	SLA A
	SLA A
	SLA A		   ; make sure the ROM bank is not switched by accident
	LD B, A		 ; move the RAM bank number to B
	LD A, (Banks)   ; load the currently switched in banks for ROM and RAM
	AND 00000111b   ; clear the current RAM bank, leave the current ROM bank intact
	OR B
	LD C, BANK_PORT
	OUT (C), A	  ; write the bank numbers to the bank switch register
	LD (Banks), A   ; save the bank numbers to memory
	POP BC		  ; restore original state of BC
	RET

; gets the currently switched in ROM bank number 0-7
; result in A
getRomBank:
	LD A, (Banks)
	AND 00000111b
	RET

; gets the currently switched in RAM bank number 0-31
; result in A
getRamBank:
	LD A, (Banks)
	SRL A
	SRL A
	SRL A
	RET


