FILE_TABLE_SECTORS 		equ 63

PROC
; computes the number of sectors required to store a file of a given size
; file size in DE
; result in E
dos_getSectorNum:
	LD A, 0
	LD B, 9
_div:		; divides the number of bytes by sector size
	SRL D
	RR E
	JR NC, _cont
	LD A, 1	; a non-zero bit was shifted out, meaning there is one extra, incomplete sector needed.
_cont:
	DJNZ _div
	CP 0
	RET Z
	INC E
	RET
ENDP


PROC
; file table sector number in A
; file record position in file table sector in C
; returns first file sector number of a file within a logical drive in AB, LSB to MSB
dos_computeSector:
	PUSH DE
	DEC A 	; decreasing A by one to account for the directory table sector
	LD B, 5
	LD D, 0
_mul:		; multiply AD by 32, as in 32 file records per sector
	AND A 	; clear carry
	RLA		; multiply A by 2
	RL D	; multiply D by 2
	DJNZ _mul
	AND A 	; clear carry
	ADC A, C   ; add the number of the file record in the file table sector
	JR NC, _skip
	INC D
_skip:
	LD B, 5
_mul2:		; multiply AD by 32, as in 32 sectors per file
	AND A 	; clear carry
	RLA		; multiply A by 2
	RL D	; multiply D by 2
	DJNZ _mul2
	AND A	; clear carry
	ADC A, FILE_TABLE_SECTORS + 1
	JR NC, _skip2
	INC D
_skip2:
	LD B, D
	POP DE
	RET
ENDP

; moves AB to the next sector number within the current logical disk
; essentially adds one to AB.
dos_nextSector:
	AND A 	; clear carry
	INC A
	RET NC
	INC B
	RET

rog_connectRoom:
	LD A, (IX + RoomW)
	SRL A 		; divide width by 2
	LD B, A
	LD A, (IX, RoomX)
	LD (AvX0), A ; store average X value for the first room
	LD A, (IY + RoomW)
	SRL A 		; divide width by 2
	LD B, A
	LD A, (IY, RoomX)
	LD (AvX1), A ; store average X value for the second room
	LD A, (IX + RoomH)
	SRL A 		; divide height by 2
	LD B, A
	LD A, (IX, RoomY)
	LD (AvY0), A ; store average Y value for the second room
	LD A, (IY + RoomH)
	SRL A 		; divide height by 2
	LD B, A
	LD A, (IY, RoomY)
	LD (AvY1), A ; store average X value for the second room
	; check what is the difference between the two rooms' average X
	LD A, (AvX0)
	LD B, A
	LD A, (AvX1)
	SUB B
	CALL i8_abs
	LD (AvX0), A
	; check what is the difference between the two rooms' average Y
	LD A, (AvY0)
	LD B, A
	LD A, (AvY1)
	SUB B
	CALL i8_abs
	; check if the two rooms are closer to each other in X or in Y coeffs
	LD B, A
	LD A, (AvX0)
	CP B
	CALL C, rog_hConn
	CALL NC, rog_vConn
	LD A, TRUE
	LD (IY + RoomConn), A
	RET



