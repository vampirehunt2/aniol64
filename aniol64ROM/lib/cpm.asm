;

copyRom2Ram:
	LD HL, 00h
	LD DE, 00h
	LD BC, 8000h
	LDIR
	LD A, 00
	OUT (0DFh), A
	RET
	