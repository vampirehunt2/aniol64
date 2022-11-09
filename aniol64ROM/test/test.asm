 
PROC
test_main:
		CALL ps2_keyInit
_loop:
		;CALL ps2_readScancode
		;CALL mon_printByte
		CALL ps2_readKey
		CALL vga_putChar
		JR _loop
ENDP
		



