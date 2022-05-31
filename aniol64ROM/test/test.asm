TestCtr equ PROGRAM_DATA

PROC
testNmiHandler:
		LD A, (TestCtr)
		LD B, A
		LD A, (NmiCount)
		AND 00100000b
		CP B
		JR NZ, _doTest
		JR _end		
_doTest:
		PUSH AF
		CALL rnd
		CALL vga_putChar
		POP AF
		JR _end
_end:
		LD (TestCtr), A		
		RET
ENDP

test_main:
		LD HL, testNmiHandler
		CALL registerNmiHandler
		CALL kbd_readKey
		CALL resetNmiHandler
		RET



