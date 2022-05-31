;

LIST_SIZE equ 0
MAX_LIST_SIZE equ 127

; fills the entire list with zeroes without changing the list length
PROC
defb "list_clear"
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
		DJNZ _loop
_end:
		POP IX					; restore register state
		POP BC
		RET
ENDP

; creates a list with a given length
; IX - address of the list
; B - number of elements in the list
defb "list_create"
list_create:
		LD (IX + LIST_SIZE), B
		RET

; checks if the list has zero elements
; result in A
PROC
defb "list_empty"
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

; checks if the list has as many elements as it can hold
; result in A
PROC
defb "list_full"
list_full:
		LD A, (IX + LIST_SIZE)
		CP MAX_LIST_SIZE
		JR C, _notFull
		LD A, TRUE
		RET
_notFull:
		LD A, FALSE
		RET
		
ENDP

; returns the number of elements in the list in A
list_len:
		LD A, (IX + LIST_SIZE)
		RET

; appends a new element at the end of the list
; address of the list in IX
; address of the value of the new element in IY
PROC
defb "list_append"
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

; inserts a new element at the beginning of the list
; address of the list in IX
; address of the value of the new element in IY
PROC
defb "list_insert"
list_insert:
		PUSH IX
		LD A, (IX + LIST_SIZE)
		LD B, A
		PUSH BC
		CALL list_endAddr
		POP BC
_loop:
		LD A, (IX - 2)
		LD (IX), A
		LD A, (IX - 1)
		LD (IX + 1), A
		DEC IX
		DEC IX
		DJNZ _loop
		POP IX
		CALL list_copyElem
		POP IX
		LD A, (IX + LIST_SIZE)
		INC A
		LD (IX + LIST_SIZE), A
		RET
ENDP

defb "list_copyElem"
list_copyElem:
		PUSH IY
		LD A, (IY)
		LD (IX), A
		LD A, (IY + 1)
		LD (IX + 1), A
		POP IY
		RET
		
; returns the address one past the last element of the list
; list address in IX
; result in IX
defb "list_endAddr"
list_endAddr:
		PUSH IX					; transfer list address from IX to BC
		POP BC
		LD A, (IX + LIST_SIZE)	; load list size to A
		LD L, A					; move list size to L
		LD H, 0					; zero H
		AND A					; clear carry
		SLA L					; multiply HL by 2
		AND A					; clear carry
		ADD HL, BC				
		PUSH HL
		POP IX
		INC IX					; add the space occupied by list size
		RET
		