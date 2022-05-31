test_main:
		LD B, 10
		LD C, 20
		CALL vga_gotoXY
		LD A, '#'
		CALL vga_putChar
		RET



