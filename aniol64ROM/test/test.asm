
PROC
test_main:
		CALL ps2_dartInit
_loop:
		CALL ps2_readKey
		CALL vga_putChar
		JR _loop
ENDP
		



