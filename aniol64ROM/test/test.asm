PROC
test_main:
	CALL clrScr
	LD A, 'x'
	CALL putChar
	LD A, 255
	CALL delay
	CALL home
	CALL getChar
	PUSH AF
	LD A, 255
	CALL delay
	LD B, 10
	LD C, 10
	CALL gotoXY
	POP AF
	CALL putChar
	RET
ENDP



