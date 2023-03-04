;

LIST_SIZE equ 0
MAX_LIST_SIZE equ 127


; fills the entire list with zeroes without changing the list length
; IX - address of the list
list_clear:
		PUSH BC					; save register state
		PUSH IX					
		LD B, (IX + LIST_SIZE)	; load list size into B
		CALL list_isEmpty			; is list is empty, do nothing
		CP TRUE
		JP Z, .end					
		INC IX					; skip over list size
		XOR A					; load zero to A
.loop:					
		LD (IX), A				; zero four bytes (one element)
		INC IX
		LD (IX), A
		INC IX
		DJNZ .loop
.end:
		POP IX					; restore register state
		POP BC
		RET

; creates a list with a given length
; IX - address of the list
; B - number of elements in the list
; errors reported in A
list_create:
		LD A, B
		CP MAX_LIST_SIZE
		JR NC, .error
		LD (IX + LIST_SIZE), B
		LD A, OK
		RET
.error:
		LD A, ERR
		RET

; checks if the list has as many elements as it can hold
; IX - address of the list
; result in A
list_isFull:
		LD A, (IX + LIST_SIZE)
		CP MAX_LIST_SIZE
		JR C, .notFull
		LD A, TRUE
		RET
.notFull:
		LD A, FALSE
		RET
		

; returns the number of elements in the list in A
; IX - address of the list
list_len:
		LD A, (IX + LIST_SIZE)
		RET
		
; increases the list size by 1
; by adding an unitialised element at the end		
; IX - address of the list
; errors reported in A
list_expand:
		CALL list_isFull
		CP TRUE
		JR Z, .err
		LD A, (IX + LIST_SIZE)	; increase list size by 1
		INC A						
		LD (IX + LIST_SIZE), A
		LD A, 0
		RET
.err:
		LD A, ERR
		RET

; appends a new element at the end of the list
; IX - address of the list
; new element in HL
list_append:
		CALL list_isFull
		CP TRUE
		JR Z, .err
		PUSH IX
		CALL list_endAddr
		CALL list_copyElem
		POP IX					; restore register state
		CALL list_expand
		LD A, 0
		RET
.err:
		LD A, ERR
		RET

; inserts a new element at the beginning of the list
; address of the list in IX
; new element in HL
list_insert:
		CALL list_isFull
		CP TRUE
		JR Z, .err
		PUSH IX
		LD A, (IX + LIST_SIZE)
		LD B, A
		CALL list_endAddr
.loop:
		LD A, (IX - 2)
		LD (IX), A
		LD A, (IX - 1)
		LD (IX + 1), A
		DEC IX
		DEC IX
		DJNZ .loop
		CALL list_copyElem
		POP IX
		LD A, (IX + LIST_SIZE)
		INC A
		LD (IX + LIST_SIZE), A
		LD A, 0
		RET
.err:
		LD A, ERR
		RET

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
list_trunc:
		CALL list_len
		SUB B
		LD B, A
.loop:
		CALL list_trim
		DJNZ .loop
		RET
		
; removes the last element from the list 
; and returns it in HL
; IX - address of the list
list_pull:
		CALL list_isEmpty
		CP TRUE
		JP Z, .err
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
.err:
		LD A, ERR
		RET
		
; sets the size of the list to zero
; IX - address of the list
list_empty:
		LD A, 0
		LD (IX + LIST_SIZE), A
		RET
		
; checks if the list has zero elements
; IX - address of the list
; result in A
list_isEmpty:
		LD A, (IX + LIST_SIZE)
		CP 0
		JR NZ, .notEmpty
		LD A, TRUE
		RET
.notEmpty:
		LD A, FALSE
		RET

; checks if the list contains a specific value		
; list address in IX
; value in HL
; result in A
list_contains:
		PUSH IX
		LD A, (IX + LIST_SIZE)
		LD B, A
		INC IX
.loop:
		LD A, (IX + 0)
		CP L
		JR NZ, .next
		LD A, (IX + 1)
		CP L
		JR NZ, .next
		JR .true
.next:
		INC IX
		INC IX
		DJNZ .loop
		LD A, FALSE
		JP .end
.true:
		LD A, TRUE
.end:
		POP IX
		RET
		
; copies one list contents to another
; IX - source list
; IY - target list
; destroys A
list_copy:
		PUSH IX
		PUSH IY
		LD A, (IX + LIST_SIZE)
		SLA A
		INC IX
		INC IY
		LD B, A
.loop:
		LD A, (IX)
		LD (IY), A
		DJNZ .loop
		POP IY
		POP IX
		LD A, (IX + LIST_SIZE)
		LD (IY + LIST_SIZE), A
		RET
	
; returns the last item from the list
; list address in IX
; result in HL	
list_last:
		CALL list_isEmpty
		CP TRUE
		JP Z, .err
		CALL list_endAddr
		DEC IX
		DEC IX
		LD L, (IX)
		LD H, (IX + 1)
		LD A, 0
		RET
.err:
		LD A, ERR
		RET
		
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
		
list_removeAt:
		PUSH IX
		CALL list_len
		CALL list_getAddrAt
		POP AF
		SUB B
		LD B, A
		DEC B
.loop:
		LD A, (IX + 3)
		LD (IX + 1), A
		LD A, (IX + 2)
		LD (IX + 0), A
		INC IX
		INC IX
		DJNZ .loop
		POP IX
		CALL list_trim
		RET

list_insertAt:
		PUSH IX
		CALL list_len
		CALL list_endAddr
		SUB B
		LD B, A
.loop:
		LD A, (IX - 2)
		LD (IX + 0), A
		LD A, (IX - 1)
		LD (IX + 1), A
		DEC IX
		DEC IX
		DJNZ .loop
		LD (IX), L
		LD (IX + 1), H
		POP IX
		RET
		
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
		
		