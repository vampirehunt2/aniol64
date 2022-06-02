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
list_isEmpty:
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
list_isFull:
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
		
list_expand:
		LD A, (IX + LIST_SIZE)	; increase list size by 1
		INC A						
		LD (IX + LIST_SIZE), A
		RET

; appends a new element at the end of the list
; address of the list in IX
; address of the value of the new element in IY
PROC
defb "list_appendP"
list_appendP:
		PUSH IX
		CALL list_endAddr
		CALL list_copyElemP
		POP IX					; restore register state
		CALL list_expand
		RET
ENDP

; inserts a new element at the beginning of the list
; address of the list in IX
; address of the value of the new element in IY
PROC
defb "list_insertP"
list_insertP:
		PUSH IX
		LD A, (IX + LIST_SIZE)
		LD B, A
		CALL list_endAddr
_loop:
		LD A, (IX - 2)
		LD (IX), A
		LD A, (IX - 1)
		LD (IX + 1), A
		DEC IX
		DEC IX
		DJNZ _loop
		POP IX      ; TODO źle
		CALL list_copyElemP
		POP IX
		LD A, (IX + LIST_SIZE)
		INC A
		LD (IX + LIST_SIZE), A
		RET
ENDP

defb "list_insertV"
list_insertV:
		RET
	
defb "list_appendV"	
list_appendV:
		PUSH IX
		CALL list_endAddr
		CALL list_copyElemV
		POP IX					; restore register state
		CALL list_expand
		RET
	
defb "list_addR"	
list_addR:
		RET
		
defb "list_addV"
list_addV:
		RET

; removes last element from the list
; list address in IX	
defb "list_trim"
list_trim:
		CALL list_isEmpty
		CP TRUE
		RET Z
		LD A, (IX + LIST_SIZE)
		DEC A
		LD (IX + LIST_SIZE), A
		RET

; removes the last elements 
; leaving only first B elements in the list	
; list address in IX	
PROC
defb "list_trunc"
list_trunc:
		CALL list_len
		SUB B
		LD B, A
_loop:
		CALL list_trim
		DJNZ _loop
		RET
ENDP
		
list_remove:
		RET
		
; removes all content from the list
list_empty:
		LD A, 0
		LD (IX + LIST_SIZE), A
		RET
		
list_containsR:
		RET
		
list_containsV:
		RET
		
; copies one list contents to another
; IX - source list
; IY - target list
; destroys A
PROC
list_copy:
		PUSH IX
		PUSH IY
		LD A, (IX + LIST_SIZE)
		SLA A
		INC IX
		INC IY
		LD B, A
_loop:
		LD A, (IX)
		LD (IY), A
		DJNZ _loop
		POP IY
		POP IX
		LD A, (IX + LIST_SIZE)
		LD (IY + LIST_SIZE), A
		RET
ENDP
		
; returns the last item from the list
; list address in IX
; result pointed to by IX
list_lastR:
		CALL list_endAddr
		DEC IX
		DEC IX
		RET
	
; returns the last item from the list
; list address in IX
; result in HL	
list_lastV:
		CALL list_lastR
		LD L, (IX)
		LD H, (IX + 1)
		RET

defb "list_copyElemP"
list_copyElemP:
		PUSH IY
		LD A, (IY)
		LD (IX), A
		LD A, (IY + 1)
		LD (IX + 1), A
		POP IY
		RET
		
defb "list_copyElemV"
list_copyElemP:
		LD A, L
		LD (IX), A
		LD A, H
		LD (IX + 1), A
		RET
		
; returns the address one past the last element of the list
; list address in IX
; result in IX
defb "list_endAddr"
list_endAddr:
		PUSH BC
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
		POP BC
		RET
		
list_shift
		