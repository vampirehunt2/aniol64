;

LIST_SIZE equ 0

PROC
list_clear:
		PUSH BC					; save register state
		PUSH IX					
		LD B, (IX + LIST_SIZE)	; load list size into B
		CALL list_empty			; is list is empty, do nothing
		CP TRUE
		JP Z, _end					
		INC IX					; skip over list size
		XOR A					; load zero to A
_loop:					
		LD (IX), A				; zero four bytes (one element)
		INC IX
		LD (IX), A
		INC IX
		LD (IX), A
		INC IX
		LD (IX), A
		INC IX
		DJNZ _loop
_end:
		POP IX					; restore register state
		POP BC
		RET
ENDP

list_create:
		LD (IX + LIST_SIZE), B
		RET

PROC
list_empty:
		LD A, (IX + LIST_SIZE)
		CP 0
		JR NZ, _notEmpty
		LD A, TRUE
		RET
_notEmpty:
		LD A, FALSE
		RET
ENDP

PROC
list_append:
		PUSH BC					; save register state
		PUSH IX
		CALL list_endAddr
		CALL list_copyElem
		POP IX					; restore register state
		LD A, (IX + LIST_SIZE)	; increase list size by 1
		INC A						
		LD (IX + LIST_SIZE), A
		POP BC					; restore register state
		RET
ENDP

list_copyElem:
		PUSH IY
		LD A, (IY)
		LD (IX), A
		LD A, (IY + 1)
		LD (IX + 1), A
		LD A, (IY + 2)
		LD (IX + 2), A
		LD A, (IY + 3)
		LD (IX + 3), A
		POP IY
		RET
		
list_endAddr:
		PUSH IX					; transfer list address from IX to BC
		POP BC
		LD A, (IX + LIST_SIZE)	; load list size to A
		LD L, A					; move list size to L
		LD H, 0					; zero H
		AND A					; clear carry
		SLA L					; multiply HL by 2
		RL H
		AND A					; clear carry
		SLA L					; multiply HL by 2 again
		RL H
		AND A					; clear carry
		ADD HL, BC
		PUSH HL
		POP IX
		INC IX					; add the space occupied by list size
		RET
		