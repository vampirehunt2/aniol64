
PROC
test_main:
		CALL keyInit
_loop:
		CALL readKey
		CALL vga_putChar
		JR _loop
ENDP
		



