
PROC
test_main:
		CALL keyInit
_loop:
		;CALL ps2_readScancode
		;CALL mon_printByte
		CALL readKey
		CALL vga_putChar
		JR _loop
ENDP
		



