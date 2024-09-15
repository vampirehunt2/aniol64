PROC
test_main:
	;CALL ps2_clockInhibit
	;CALL delay1520us
	;CALL ps2_clockRelease
	;RET
	LD A, 0FFh;0EDh
	CALL ps2_transmit
	;LD A, 00000100b
	;CALL ps2_transmit
	RET
ENDP



