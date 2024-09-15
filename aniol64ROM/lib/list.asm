;

LIST_SIZE equ 0
MAX_LIST_SIZE equ 127


; fills the entire list with zeroes without changing the list length
; IX - address of the list
PROC
list_clear:
		PUSH BC					; save register state
		PUSH IX					
		LD B, (IX + LIST_SIZE)	; load list size into B
		CALL list_isEmpty			; is list is empty, do nothing
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
; errors reported in A
PROC
list_create:
		LD A, B
		CP MAX_LIST_SIZE
		JR NC, _error
		LD (IX + LIST_SIZE), B
		LD A, OK
		RET
_error:
		LD A, ERR
		RET
ENDP

; checks if the list has as many elements as it can hold
; IX - address of the list
; result in A
PROC
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
; IX - address of the list
list_len:
		LD A, (IX + LIST_SIZE)
		RET
		
; increases the list size by 1
; by adding an unitialised element at the end		
; IX - address of the list
; errors reported in A
PROC
list_expand:
		CALL list_isFull
		CP TRUE
		JR Z, _err
		LD A, (IX + LIST_SIZE)	; increase list size by 1
		INC A						
		LD (IX + LIST_SIZE), A
		LD A, 0
		RET
_err:
		LD A, ERR
		RET
ENDP

; appends a new element at the end of the list
; IX - address of the list
; new element in HL
PROC
list_append:
		CALL list_isFull
		CP TRUE
		JR Z, _err
		PUSH IX
		CALL list_endAddr
		CALL list_copyElem
		POP IX					; restore register state
		CALL list_expand
		LD A, 0
		RET
_err:
		LD A, ERR
		RET
ENDP

; inserts a new element at the beginning of the list
; address of the list in IX
; new element in HL
PROC
list_insert:
		CALL list_isFull
		CP TRUE
		JR Z, _err
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
		CALL list_copyElem
		POP IX
		LD A, (IX + LIST_SIZE)
		INC A
		LD (IX + LIST_SIZE), A
		LD A, 0
		RET
_err:
		LD A, ERR
		RET
ENDP

; removes last element from the list
; list address in IX	
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
list_trunc:
		CALL list_len
		SUB B
		LD B, A
_loop:
		CALL list_trim
		DJNZ _loop
		RET
ENDP
		
; removes the last element from the list 
; and returns it in HL
; IX - address of the list
PROC
list_pull:
		CALL list_isEmpty
		CP TRUE
		JP Z, _err
		PUSH IX
		CALL list_endAddr
		LD A, (IX - 1)
		LD H, A
		LD A, (IX - 2)
		LD L, A
		POP IX
		CALL list_trim
		LD A, 0
		RET
_err:
		LD A, ERR
		RET
ENDP
		
; sets the size of the list to zero
; IX - address of the list
list_empty:
		LD A, 0
		LD (IX + LIST_SIZE), A
		RET
		
; checks if the list has zero elements
; IX - address of the list
; result in A
PROC
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

; checks if the list contains a specific value		
; list address in IX
; value in HL
; result in A
PROC
list_contains:
		PUSH IX
		LD A, (IX + LIST_SIZE)
		LD B, A
		INC IX
_loop:
		LD A, (IX + 0)
		CP L
		JR NZ, _next
		LD A, (IX + 1)
		CP L
		JR NZ, _next
		JR _true
_next:
		INC IX
		INC IX
		DJNZ _loop
		LD A, FALSE
		JP _end
_true:
		LD A, TRUE
_end:
		POP IX
		RET
ENDP
		
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
; result in HL	
PROC
list_last:
		CALL list_isEmpty
		CP TRUE
		JP Z, _err
		CALL list_endAddr
		DEC IX
		DEC IX
		LD L, (IX)
		LD H, (IX + 1)
		LD A, 0
		RET
_err:
		LD A, ERR
		RET
ENDP
		
list_copyElem:
		LD A, L
		LD (IX), A
		LD A, H
		LD (IX + 1), A
		RET
		
; returns the address one past the last element of the list
; list address in IX
; result in IX
list_endAddr:
		PUSH HL
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
		POP HL
		RET
		
; gets the B-th element from the list
; IX - list address
; result in HL
list_getAt:
		PUSH IX
		CALL list_getAddrAt
		LD A, (IX + 0)
		LD L, A
		LD A, (IX + 1)
		LD H, A
		POP IX
		RET
	
; puts an element on the B-th place the list
; IX - list address
; HL - element to add
list_putAt:
		PUSH IX
		CALL list_getAddrAt
		LD A, L
		LD (IX + 0), A
		LD A, H
		LD (IX + 1), A
		POP IX
		RET

PROC		
list_removeAt:
		PUSH IX
		CALL list_len
		CALL list_getAddrAt
		POP AF
		SUB B
		LD B, A
		DEC B
_loop:
		LD A, (IX + 3)
		LD (IX + 1), A
		LD A, (IX + 2)
		LD (IX + 0), A
		INC IX
		INC IX
		DJNZ _loop
		POP IX
		CALL list_trim
		RET
ENDP

PROC
list_insertAt:
		PUSH IX
		CALL list_len
		CALL list_endAddr
		SUB B
		LD B, A
_loop:
		LD A, (IX - 2)
		LD (IX + 0), A
		LD A, (IX - 1)
		LD (IX + 1), A
		DEC IX
		DEC IX
		DJNZ _loop
		LD (IX), L
		LD (IX + 1), H
		POP IX
		RET
ENDP
		
; gets the address of the B-th element of the list
; IX - list address
; result in IX
list_getAddrAt:
		PUSH BC
		AND A		; clear carry
		LD A, B
		SLA A		; multiply by 2
		INC A		; skip over list size byte
		LD C, A
		LD B, 0
		PUSH IX
		POP HL
		ADD HL, BC
		PUSH HL
		POP IX
		POP BC
		RET
		
		