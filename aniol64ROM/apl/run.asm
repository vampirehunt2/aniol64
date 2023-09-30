; apl bytecode interpreter

Terminated:     defb "Program terminated", 0

MAX_EXPR_BCS    equ 64

CurrentBC       equ PROGRAM_DATA + 00h
PrevBC          equ PROGRAM_DATA + 02h
NextBC          equ PROGRAM_DATA + 04h
ExprStart       equ PROGRAM_DATA + 06h  
ExprEnd         equ PROGRAM_DATA + 08h
StmtStart       equ PROGRAM_DATA + 0Ah
StmtEnd         equ PROGRAM_DATA + 0Ch
EvalProgress    equ PROGRAM_DATA + 0Eh
NestingLevel    equ PROGRAM_DATA + 0Fh
StackPtr        equ PROGRAM_DATA + 10h  ; 2 bytes
Trap            equ PROGRAM_DATA + 12h  ; stack pointer at the beggining of the run, to fall back onto in case of a syntax error
DataSeg         equ PROGRAM_DATA + 14h
ProcAddr        equ PROGRAM_DATA + 16h
RunStack        equ 8240h   
Expression      equ 8280h
Vars            equ 8300h
Procedures      equ 8400h


run_debug:
    CALL apl_main
    CALL run_main
    RET

; initialises the apl interpreter
run_init:
    CALL run_findProcedures
    LD HL, Bytecodes
    LD (StmtStart), HL      ; initilise the line pointer to the beginning of the program
    LD HL, RunStack            ; initialise the soft stack
    LD (StackPtr), HL
    CALL run_findStmtEnd
    RET

run_findProcedures:
    LD HL, Bytecodes
.loop:
    LD A, (HL)
    CP END_B
    JR Z, .end
    CP PROC_B
    JR Z, .proc
    CALL run_nextBC
    JR .loop
.proc:
    LD (CurrentBC), HL  ; save the current bytecode pointer   
    INC HL        
    INC HL              ; move HL to the procedure index
    LD A, (HL)          ; procedure index now in A
    SLA A               ; multiply the procedure index by two...
    INC HL            
    INC HL
    LD (ProcAddr), HL
    LD HL, Procedures   ; point HL to the beginning of the procedure address table
    LD C, A             ; get an index into the two-byte-per-element procedure address table  
    LD B, 0
    ADD HL, BC          ; pointer to the procedure address table entry now in HL
    LD (DataSeg), HL    ; the last procedure declared so far is the beginning of the data segment (will be incremented later)
    LD DE, (ProcAddr)
    LD (HL), E
    INC HL
    LD (HL), D
    LD HL, (CurrentBC)
    CALL run_nextBC
    JR .loop
.end:
    LD HL, (DataSeg)
    INC HL
    INC HL              
    LD (DataSeg), HL    ; we can later start putting data (strings, arrays, records) from this address
    RET

run_syntaxError:
    LD SP, (Trap)
    RET

run_main:
    CALL run_init
    LD (Trap), SP
.loop:
    CP FALSE                ; check for end of program
    JR Z, .end              ; end of program reached
    CALL run_execStmt       ; execute the current statement
    CALL run_nextStmt       ; move to the next statement
    JR .loop
.end
    RET

; finds the end of the current statement
; beggining of the statement passed as pointer in StmtStart
; result in StmtEnd
; FALSE returned in A if end of program is reached
run_findStmtEnd:
    LD HL, (StmtStart)
.loop:
    INC HL 
    LD A, (HL)
    CP SEPARATOR_B
    JR Z, .found:
    CP 'D'          ; END token
    JR Z, .notFound
    JR .loop
.found:
    LD (StmtEnd), HL
    RET
.notFound:
    LD A, FALSE
    RET

; moves StmtStart to the beggining of the next statement
run_nextStmt:
    LD HL, (StmtEnd)
    INC HL
    LD (StmtStart), HL
    CALL run_findStmtEnd
    RET

; executes the current statement
run_execStmt:
    LD HL, (StmtStart)      ; check the first bytecode in the statement
    LD A, (HL)
    AND 10000000b           ; if the top bit of the bytecode is set, it's a variable
    CP 0
    JP NZ, run_execAssignment
    LD A, (HL)
    CP IF_B
    JP Z, run_if
    CP ELSE_B
    JP Z, run_else
    CP WHILE_B
    JP Z, run_while
    CP LOOP_B
    JP Z, run_loop
    CP SYSCALL_B
    JP Z, run_execSyscall
    CP USERCALL_B
    JP Z, run_execUserCall
    CP RET_B
    JP Z, run_ret
    CP STOP_B
    JP Z, run_stop
    CP ARRAY_B
    JP Z, run_declareArray
    ; TODO: handle unrecognised token

; moves HL to the next bytecode
run_nextBC:
    LD A, (HL)
    CP NUM_B
    JR Z, .three
    CP SYSCALL_B
    JR Z, .two          ; system calls are two bytes long
    CP USERCALL_B
    JR Z, .two          ; as are user-defined procedures
    JR .one             ; all other bytecodes are one-byte long
    ; TODO: handle string literals
.three:
    INC HL
.two:
    INC HL
.one:
    INC HL
    RET

; evaluates an expression
; assuming HL is pointing to the byte before the expression
run_evaluate:   
    LD IX, Expression
    INC HL              ; assuming HL is pointing to the byte before the expression
.loop:                  ; this loop copies the expression to Expression, evaluating all the variables in the process
    LD A, (HL)
    CP SEPARATOR_B      ; check if end of statement is reached,
    JR Z, .eval         ; if yes, proceed to evaluating
    AND 10000000b       ; check if the bytecode is a variable
    CP 0
    JR NZ, .var         ; if yes, evaluate the variable
    LD A, (HL)
    CP NUM_B
    JR Z, .num
    CP SYSCALL_B
    JR Z, .call          ; system calls are two bytes long...
    CP USERCALL_B
    JR Z, .call          ; ...as are user-defined procedures
    JR .other
.var:
    LD A, (HL)
    AND 01111111b       ; get the variable index
    SLA A               ; multiply it by 2, as numeric variables are 2 bytes long
    LD C, A
    LD B, 0
    PUSH HL             ; save HL
    LD HL, Vars         
    ADD HL, BC          ; get the variable address
    LD A, NUM_B
    LD (IX), A          ; load the numeric value bytecode
    INC IX
    LD A, (HL)
    LD (IX), A          ; copy the first byte of the variable value
    INC HL
    INC IX
    LD A, (HL)
    LD (IX), A          ; copy the second byte of the variable value
    POP HL              ; restore HL`
    INC HL
    INC IX
    JR .loop
.num:
    LD (IX), A          ; copy the first bytecode
    INC IX
    INC HL
    LD A, (HL)          
.call:
    LD (IX), A          ; copy another bytecode
    INC IX
    INC HL
    LD A, (HL)          
.other:
    LD (IX), A          ; copy yet another bytecode
    INC HL
    INC IX
    JR .loop
; the expression is now copied to Expression.
; evaluate the expression
.eval:                  
    LD (IX), A          ; storing the separator bytecode, that marks the end of the expression
.evalloop:
    LD A, FALSE
    LD (EvalProgress), A
    CALL run_sanitiseParens
    CALL run_evalFunction
    CALL run_evalIndex
    CALL run_evalUnary
    CALL run_evalMul
    CALL run_evalAdd
    CALL run_evalComp
    LD A, (EvalProgress)
    CP FALSE
    JR Z, .end          ; no more progress was made, can't reduce the expression anymore
    JR .evalloop
.end:                   ; check if we are left with just a single value
    LD A, (Expression)
    CP NUM_B
    JR NZ, .syntaxErr
    LD A, (Expression + 3)
    CP SEPARATOR_B
    JR NZ, .syntaxErr
    LD A, 0
    RET                 ; success
.syntaxErr:             ; TODO: handle the syntax error
    LD A, 1
    RET


; removes redundant parenthesis from Expression
run_sanitiseParens:
    LD HL, Expression
.loop:
    PUSH HL             ; save the current pointer into the expression
    LD A, (HL)
    CP SEPARATOR_B      ; checking for end of expression
    JR Z, .end
    CP LEFT_PAREN_B     ; check if the current bytecode is an opening parenthesis
    JR NZ, .next        ; if not, skip to the next bytecode
    INC HL              ; if yes, move to the next byte
    LD A, (HL)
    CP NUM_B            ; check if the next byte is a value    
    JR NZ, .next        ; if not, skip to the next bytecode    
    INC HL              ; if yes, move to the next bytecode after the value
    INC HL
    INC HL              
    LD A, (HL)
    CP RIGHT_PAREN_B    ; check if the  bytecode is a closing parenthesis
    JR NZ, .next
    ; remove the redundant parenthesis here
    LD A, TRUE
    LD (EvalProgress), A; indicate that there was an action performed to reduce the expression
    PUSH HL             ; transfer the pointer into Expression to IX
    POP IX              ; IX now pointing to the closing parenthesis
    LD A, NUM_B         ; we know NUM_B is at IX - 3
    LD (IX - 4), A      ; copy NUM_B where the opening parenthesis was
    LD A, (IX - 2)
    LD (IX - 3), A      ; copy the lower byte of the numerical value
    LD A, (IX - 1)
    LD (IX - 2), A      ; copy the higher byte of the numerical value
.loop1:                 ; copy everything to the end of the expression back
    LD A, (IX + 1)
    LD (IX - 1), A
    CP SEPARATOR_B      ; check for end of expression
    JR Z, .next
    INC IX              ; move to the next byte of the expression
    JR .loop1
.next:
    POP HL              ; restore the current pointer into the expression
    CALL run_nextBC     ; move to the next bytecode 
    JR .loop
.end:
    POP HL
    RET


run_evalFunction:
    LD HL, Expression
.loop:
    PUSH HL             ; save the current pointer into the expression
    LD A, (HL)
    CP SEPARATOR_B      ; checking for end of expression
    JR Z, .end          ; if end of expression reached, return
    CP SYSCALL_B
    JR NZ, .end        
    INC HL  
    INC HL              ; move to the operand            
    LD A, (HL)          ; load the operand bytecode to A
    CP NUM_B            ; check if it is a number
    JR NZ, .next        ; if not, go to the next bytecode
    LD A, TRUE
    LD (EvalProgress), A; indicate that there was an action performed to reduce the expression
; prepare operand
    PUSH HL
    POP IX              ; IX now pointing to NUM_B bytecode of the operand
    LD L, (IX + 1)      ; lower byte of the first operand
    LD H, (IX + 2)      ; higher byte of the first operand
    LD A, (IX - 1)      ; syscall index
    CALL run_execFunction
.cont:
    LD (IX - 2), NUM_B
    LD (IX - 1), L      ; store lower byte of result
    LD (IX + 0), H      ; store higher byte of result
.loop1:                 ; copy everything to the end of the expression back
    LD A, (IX + 3)
    LD (IX + 1), A
    CP SEPARATOR_B      ; check for end of expression
    JR Z, .next
    INC IX              ; move to the next byte of the expression
    JR .loop1
    POP HL
    JR .loop
.next:
    POP HL              ; restore the current pointer into the expression
    CALL run_nextBC     ; move to the next bytecode 
    JP .loop
.end:
    POP HL
    RET

run_evalUnary:
    LD HL, Expression
.loop:
    PUSH HL             ; save the current pointer into the expression
    LD A, (HL)
    CP SEPARATOR_B      ; checking for end of expression
    JR Z, .end          ; if end of expression reached, return
    CALL run_isUnaryOperator    
    CP TRUE
    JR NZ, .next        ; if no, move to the next bytecode
    INC HL              ; if yes, skip over the bytecode
    LD A, (HL)          ; load the next bytecode after the operator to A
    CP NUM_B            ; check if it's a value
    JR NZ, .next        ; if no, move to the next bytecode  
    LD A, TRUE
    LD (EvalProgress), A; indicate that there was an action performed to reduce the expression
; prepare operand
    PUSH HL
    POP IX              ; IX now pointing to NUM_B bytecode of the second operand
    LD L, (IX + 1)      ; lower byte of the first operand
    LD H, (IX + 2)      ; higher byte of the first operand
    LD A, (IX - 1)      ; operator
    CP NOT_B
    JR Z, .not
    CP MINUS_B
    JR Z, .minus
    CP ADDR_B
    JR Z, .addr
    CP DEREFERENCE_B
    JR Z, .der
.not:                   ; perform bitwise negation
    CALL i16_not
    JR .cont
.minus:                 ; perform arithmetic negation
    CALL i16_neg        
    JR .cont
.addr:                   
   ; TODO
    JR .cont
.der:                   ; perform dereference
    LD C, (HL)
    INC HL
    LD B, (HL)
    LD H, B
    LD L, C
.cont:
    LD (IX - 1), NUM_B
    LD (IX + 0), L      ; store lower byte of result
    LD (IX + 1), H      ; store higher byte of result
.loop1:                 ; copy everything to the end of the expression back
    LD A, (IX + 3)
    LD (IX + 2), A
    CP SEPARATOR_B      ; check for end of expression
    JR Z, .next
    INC IX              ; move to the next byte of the expression
    JR .loop1
    POP HL
    JR .loop
.next:
    POP HL              ; restore the current pointer into the expression
    CALL run_nextBC     ; move to the next bytecode 
    JP .loop
.end:
    POP HL
    RET


; computes and processes the result of an indexing operation (base addr + offset)
; on two numerical operands
run_evalIndex:
    LD HL, Expression
.loop:
    PUSH HL             ; save the current pointer into the expression
    LD A, (HL)
    CP SEPARATOR_B      ; checking for end of expression
    JR Z, .end          ; if end of expression reached, return
    CP NUM_B            ; check if we have a numerical value
    JR NZ, .next        ; if no, move to the next bytecode
    INC HL              ; if yes, skip over the numerical value
    INC HL
    INC HL  
    LD A, (HL)          ; load the next bytecode after the numerical value to A
    CP INDEX_B
    JR Z, .do
    JR .next            ; if no index operator is found, move to the next bytecode
.do:
    INC HL
    LD A, (HL)
    CP NUM_B            ; check if the second operand is a value
    JR NZ, .next        ; if not, skip
    LD A, TRUE
    LD (EvalProgress), A; indicate that there was an action performed to reduce the expression
; prepare operands      ; TODO: extract subroutine
    PUSH HL
    POP IX              ; IX now pointing to NUM_B bytecode of the second operand
    LD L, (IX - 3)      ; lower byte of the first operand
    LD H, (IX - 2)      ; higher byte of the first operand
    LD C, (IX + 1)      ; lower byte of the second operand
    LD B, (IX + 2)      ; higher byte of the second operand
; perform indexing operation
    SLA C               ; m,ultiply BC by 2, which is the size of a value
    RL B
    ADD HL, BC          ; address of the value now in HL
    LD C, (HL)          ; load lower byte of result to C
    INC HL
    LD B, (HL)          ; load higher value of result to B
    LD H, B             ; transfer the result from BC to HL
    LD L, C
; store result          ; TODO: extract subroutine
    LD (IX - 3), L      ; store lower byte of result
    LD (IX - 2), H      ; store higher byte of result
.loop1:                 ; copy everything to the end of the expression back
    LD A, (IX + 3)
    LD (IX - 1), A
    CP SEPARATOR_B      ; check for end of expression
    JR Z, .next
    INC IX              ; move to the next byte of the expression
    JR .loop1
    POP HL
    JR .loop
.next:
    POP HL              ; restore the current pointer into the expression
    CALL run_nextBC     ; move to the next bytecode 
    JR .loop
.end:
    POP HL
    RET


; computes and processes the result of a multiplication-type operation
; on two numerical operands
run_evalMul:
    LD HL, Expression
.loop:
    PUSH HL             ; save the current pointer into the expression
    LD A, (HL)
    CP SEPARATOR_B      ; checking for end of expression
    JR Z, .end          ; if end of expression reached, return
    CP NUM_B            ; check if we have a numerical value
    JR NZ, .next        ; if no, move to the next bytecode
    INC HL              ; if yes, skip over the numerical value
    INC HL
    INC HL  
    LD A, (HL)          ; load the next bytecode after the numerical value to A
    CP MUL_B
    JR Z, .do
    CP DIV_B
    JR Z, .do
    CP MOD_B
    JR Z, .do
    CP CONJUNCTION_B
    JR Z, .do
    JR .next            ; if no multiplication-type operator is found, move to the next bytecode
.do:
    INC HL
    LD A, (HL)
    CP NUM_B            ; check if the second operand is a value
    JR NZ, .next        ; if not, skip
    LD A, TRUE
    LD (EvalProgress), A; indicate that there was an action performed to reduce the expression
; prepare operands
    PUSH HL
    POP IX              ; IX now pointing to NUM_B bytecode of the second operand
    LD L, (IX - 3)      ; lower byte of the first operand
    LD H, (IX - 2)      ; higher byte of the first operand
    LD C, (IX + 1)      ; lower byte of the second operand
    LD B, (IX + 2)      ; higher byte of the second operand
    LD A, (IX - 1)      ; operator
    CP MUL_B
    JR Z, .mul
    CP DIV_B
    JR Z, .div
    CP MOD_B
    JR Z, .mod
    CP CONJUNCTION_B
    JR Z, .con
.mul:                   ; perform multiplication
    CALL i16_mul
    JR .cont
.div:                   ; perform division
    CALL i16_div        
    LD H, D             ; move division result from DE to HL
    LD L, E
    JR .cont
.mod:                   ; perform modulo
    CALL i16_div    
    JR .cont
.con:                   ; perform bitwise conjuction
    CALL i16_and
.cont:
    LD (IX - 3), L      ; store lower byte of result
    LD (IX - 2), H      ; store higher byte of result
.loop1:                 ; copy everything to the end of the expression back
    LD A, (IX + 3)
    LD (IX - 1), A
    CP SEPARATOR_B      ; check for end of expression
    JR Z, .next
    INC IX              ; move to the next byte of the expression
    JR .loop1
    POP HL
    JR .loop
.next:
    POP HL              ; restore the current pointer into the expression
    CALL run_nextBC     ; move to the next bytecode 
    JR .loop
.end:
    POP HL
    RET

run_evalAdd:
    LD HL, Expression
.loop:
    PUSH HL             ; save the current pointer into the expression
    LD A, (HL)
    CP SEPARATOR_B      ; checking for end of expression
    JR Z, .end          ; if end of expression reached, return
    CP NUM_B            ; check if we have a numerical value
    JR NZ, .next        ; if no, move to the next bytecode
    INC HL              ; if yes, skip over the numerical value
    INC HL
    INC HL  
    LD A, (HL)          ; load the next bytecode after the numerical value to A
    CP ADD_B
    JR Z, .do
    CP SUB_B
    JR Z, .do
    CP ALTERNATIVE_B
    JR Z, .do
    JR .next            ; if no multiplication-type operator is found, move to the next bytecode
.do:
    INC HL
    LD A, (HL)
    CP NUM_B            ; check if the second operand is a value
    JR NZ, .next        ; if not, skip
    LD A, TRUE
    LD (EvalProgress), A; indicate that there was an action performed to reduce the expression
; prepare operands  TODO: extract procedure
    PUSH HL
    POP IX              ; IX now pointing to NUM_B bytecode of the second operand
    LD L, (IX - 3)      ; lower byte of the first operand
    LD H, (IX - 2)      ; higher byte of the first operand
    LD C, (IX + 1)      ; lower byte of the second operand
    LD B, (IX + 2)      ; higher byte of the second operand
    LD A, (IX - 1)      ; operator
    CP ADD_B
    JR Z, .add
    CP SUB_B
    JR Z, .sub
    CP ALTERNATIVE_B
    JR Z, .alt
.add:                   ; perform addition
    CALL i16_add
    JR .cont
.sub:                   ; perform subtraction
    CALL i16_sub        
    JR .cont
.alt:                   ; perform bitwise alternative
    CALL i16_or    
.cont:                  ; TODO: extract procedure
    LD (IX - 3), L      ; store lower byte of result 
    LD (IX - 2), H      ; store higher byte of result
.loop1:                 ; copy everything to the end of the expression back
    LD A, (IX + 3)
    LD (IX - 1), A
    CP SEPARATOR_B      ; check for end of expression
    JR Z, .next
    INC IX              ; move to the next byte of the expression
    JR .loop1
    POP HL
    JR .loop
.next:
    POP HL              ; restore the current pointer into the expression
    CALL run_nextBC     ; move to the next bytecode 
    JR .loop
.end:
    POP HL
    RET

; computes and processes the result of a comparison operation
; on two numerical operands
run_evalComp:
    LD HL, Expression
.loop:
    PUSH HL             ; save the current pointer into the expression
    LD A, (HL)
    CP SEPARATOR_B      ; checking for end of expression
    JP Z, .end          ; if end of expression reached, return
    CP NUM_B            ; check if we have a numerical value
    JP NZ, .next        ; if no, move to the next bytecode
    INC HL              ; if yes, skip over the numerical value
    INC HL
    INC HL  
    LD A, (HL)          ; load the next bytecode after the numerical value to A
    CP EQUAL_B
    JR Z, .do
    CP GREATER_B
    JR Z, .do
    CP LESSER_B
    JR Z, .do
    CP GREATER_EQUAL_B
    JR Z, .do
    CP LESSER_EQUAL_B
    JR Z, .do
    CP NOT_EQUAL_B
    JR Z, .do
    JP .next            ; if no multiplication-type operator is found, move to the next bytecode
.do:
    INC HL
    LD A, (HL)
    CP NUM_B            ; check if the second operand is a value
    JP NZ, .next        ; if not, skip
    LD A, TRUE
    LD (EvalProgress), A; indicate that there was an action performed to reduce the expression
; prepare operands
    PUSH HL
    POP IX              ; IX now pointing to NUM_B bytecode of the second operand
    LD L, (IX - 3)      ; lower byte of the first operand
    LD H, (IX - 2)      ; higher byte of the first operand
    LD C, (IX + 1)      ; lower byte of the second operand
    LD B, (IX + 2)      ; higher byte of the second operand
    LD A, (IX - 1)      ; operator
    CP GREATER_B
    JR Z, .gt
    CP LESSER_B
    JR Z, .lt
    CP GREATER_EQUAL_B
    JR Z, .ge
    CP LESSER_EQUAL_B
    JR Z, .le
    CP EQUAL_B
    JR Z, .eq
    CP NOT_EQUAL_B
    JR Z, .neq
.gt:                   
    CALL i16_cmp
    CP 1
    JR Z, .true
    JR .false
.lt:                   
    CALL i16_cmp        
    CP -1
    JR Z, .true
    JR .false
.ge:                 
    CALL i16_cmp
    CP -1
    JR NZ, .true    
    JR .false
.le:                  
    CALL i16_cmp
    CP 1
    JR NZ, .true    
    JR .false
.eq:                  
    CALL i16_cmp
    CP 0
    JR Z, .true    
    JR .false
.neq:                  
    CALL i16_cmp
    CP 0
    JR NZ, .true    
    JR .false
.true:
    LD HL, 0xFFFF
    JR .cont
.false:
    LD HL, 0
    JR .cont
.cont:
    LD (IX - 3), L      ; store lower byte of result
    LD (IX - 2), H      ; store higher byte of result
.loop1:                 ; copy everything to the end of the expression back
    LD A, (IX + 3)
    LD (IX - 1), A
    CP SEPARATOR_B      ; check for end of expression
    JR Z, .next
    INC IX              ; move to the next byte of the expression
    JR .loop1
    POP HL
    JP .loop
.next:
    POP HL              ; restore the current pointer into the expression
    CALL run_nextBC     ; move to the next bytecode 
    JP .loop
.end:
    POP HL
    RET

; checks if the bytecode in A is a single operand prefix operator
; result in A
run_isUnaryOperator:
    CP NOT_B
    JR Z, .true
    CP ADDR_B
    JR Z, .true
    CP DEREFERENCE_B
    JR Z, .true
    CP MINUS_B
    JR Z, .true
    LD A, FALSE
    RET 
.true:
    LD A, TRUE
    RET


; checks if the bytecode in A is a addition-type operator
; result in A
run_isAddOp:
    CP ADD_B
    JR Z, .true
    CP SUB_B
    JR Z, .true
    CP ALTERNATIVE_B
    JR Z, .true
    LD A, FALSE
    RET
.true:
    LD A, TRUE
    RET

; checks if the bytecode in A is a multiplication-type operator
; result in A
run_isMulOp:
    CP MUL_B
    JR Z, .true
    CP DIV_B
    JR Z, .true
    CP MOD_B
    JR Z, .true
    CP CONJUNCTION_B
    JR Z, .true
    LD A, FALSE
    RET
.true:
    LD A, TRUE
    RET


; evaluates an expression and assigns to a variable
run_execAssignment:
    LD HL, (StmtStart)  ; first bytecode of an assignment statement is a variable
    INC HL              ; move HL to the next bytode after the variable
    LD A, (HL)          ; load the next bytecode into A
    CP EQUAL_B          ; check if the next token is the assignment operator
    JR NZ, .syntaxError
    CALL run_evaluate
    CP 0                ; check exit code for success
    JR NZ, .syntaxError
    LD HL, (StmtStart)  ; first bytecode of an assignment statement is a variable TODO: extract this to a routine
    LD A, (HL)          ; load the variable bytecode
    AND 01111111b       ; get the variable index        ; TODO extract below code to run_getVarAddr
    SLA A               ; multiply it by 2, as numeric variables are 2 bytes long
    LD C, A
    LD B, 0
    LD HL, Vars         
    ADD HL, BC          ; get the variable address
    LD A, (Expression + 1)  ; lower byte of the result
    LD (HL), A
    INC HL
    LD A, (Expression + 2)  ; higher byte of the result
    LD (HL), A
    RET
.syntaxError:
    ; TODO raise syntax error
    RET

; "executes" an else statement.
; actually, else is not executed. If an else statement is encountered out in the wild, 
; the entire block just needs to be skipped
run_else:
    LD A, 0
    LD (NestingLevel), A             ; initialise the nested IF statement counter to zero
.loop:
    CALL run_nextStmt       ; move to the next statement
    CP FALSE                ; check for end of program
    JR Z, .syntaxErr        ; unexpected end of program reached
    LD HL, (StmtStart)
    LD A, (HL)
    CP ENDIF_B              ; if end if is found, end the loop
    JR Z, .endif
    CP IF_B
    JR Z, .if
    JR .loop
.endif:
    LD A, (NestingLevel)
    CP 0                    ; check if we're in a nexted IF statement
    JR Z, .end              ; if no, end the loop
    DEC A
    LD (NestingLevel), A             ; if yes, decrement the nexted IF statement count
    JR .loop
.if:
    LD A, (NestingLevel)
    INC A
    LD (NestingLevel), A             ; increment the nested IF statement counter
    JR .loop
.end:
    RET
.syntaxErr:
    ; TODO handle syntax error
    RET

; executes a loop (end of while) statement
run_loop:
    LD HL, (StackPtr)
    DEC HL
    LD B, (HL)
    DEC HL
    LD C, (HL)
    LD (StackPtr), HL
    DEC BC                  ; moving back to the end of the previous statement, 
    LD (StmtEnd), BC        ; so that the next run_nextStmt call goes back to the WHILE statement
    RET

;executes a while loop
run_while:
    CALL run_evaluate
    LD HL, (Expression + 1) ; check the result of the condition (+1 to skip the NUM_B bytecode)
    LD BC, 0                ; 
    CALL i16_cmp            ; compare it with zero
    CP 0                    ; check if result is zero (logical FALSE)
    JR NZ, .true            
    LD A, 0
    LD (NestingLevel), A    ; initialise the nested WHILE statement counter to zero
.loop:
    CALL run_nextStmt       ; move to the next statement
    CP FALSE                ; check for end of program
    JR Z, .syntaxErr        ; unexpected end of program reached
    LD HL, (StmtStart)
    LD A, (HL)
    CP LOOP_B              ; if end of loop is found, end the loop
    JR Z, .endwhile
    CP WHILE_B
    JR Z, .while
    JR .loop
.while:
    LD A, (NestingLevel)
    INC A
    LD (NestingLevel), A    ; increment the nested WHILE statement counter
    JR .loop
.endwhile:
    LD A, (NestingLevel)
    CP 0                    ; check if we're in a nested WHILE statement
    JR Z, .end              ; if no, end the loop
    DEC A
    LD (NestingLevel), A    ; if yes, decrement the nested WHILE statement count
    JR .loop
.true:
    LD BC, (StmtStart)      ; save the return address of the loop on stack
    LD HL, (StackPtr)
    LD (HL), C
    INC HL
    LD (HL), B
    INC HL
    LD (StackPtr), HL
    RET
.end:
    RET
.syntaxErr:
    ; TODO handle syntax error
    RET
    
; executes a conditional statement
run_if:
    CALL run_evaluate
    LD HL, (Expression + 1) ; check the result of the condition (+1 to skip the NUM_B bytecode)
    LD BC, 0                ; 
    CALL i16_cmp            ; compare it with zero
    CP 0                    ; check if result is zero (logical FALSE)
    RET NZ                  ; if it's not zero do nothing, let the program continue
    LD A, 0
    LD (NestingLevel), A    ; initialise the nested IF statement counter to zero
.loop:
    CALL run_nextStmt       ; move to the next statement
    CP FALSE                ; check for end of program
    JR Z, .syntaxErr        ; unexpected end of program reached
    LD HL, (StmtStart)
    LD A, (HL)
    CP ENDIF_B              ; if end if is found, end the loop
    JR Z, .endif
    CP IF_B
    JR Z, .if
    CP ELSE_B 
    JR Z, .else
    JR .loop
.else:
    LD A, (NestingLevel)
    CP 0                    ; check if we're in a nexted IF statement
    JR Z, .end              ; if no, end the loop
    JR .loop
.endif:
    LD A, (NestingLevel)
    CP 0                    ; check if we're in a nested IF statement
    JR Z, .end              ; if no, end the loop
    DEC A
    LD (NestingLevel), A    ; if yes, decrement the nested IF statement count
    JR .loop
.if:
    LD A, (NestingLevel)
    INC A
    LD (NestingLevel), A    ; increment the nested IF statement counter
    JR .loop
.end:
    RET
.syntaxErr:
    ; TODO handle syntax error
    RET

; executes a system procedure
run_execSyscall:
    INC HL          ; move HL to the syscall id
    LD A, (HL)
    CP SYS_WRITE_B
    JP Z, sys_write
    CP SYS_BEEP_B
    JP Z, sys_beep
    CP SYS_CLICK_B
    JP Z, sys_click
    CP SYS_NEWLN_B
    JP Z, sys_nextLn
    CP SYS_READ_B
    JP Z, sys_read
    RET

; executes a system function
; syscall index in A
; argument in HL
; result in HL
run_execFunction:
    CP SYS_ABS_B
    JP Z, sys_abs
    CP SYS_RND_B
    JP Z, sys_rnd
    CP SYS_PEEK_B
    JP Z, sys_peek
    RET


; executes a user-defined procedure
run_execUserCall:
    LD BC, (StmtStart)      ; save the return address of the proc call on stack
    LD HL, (StackPtr)
    LD (HL), C
    INC HL
    LD (HL), B
    INC HL
    LD (StackPtr), HL
    LD HL, (StmtStart)
    INC HL              ; move HL to point to the procedure index
    LD A, (HL)          ; load the procedure index to A
    SLA A               ; multiply the procedure index by two...
    LD HL, Procedures   ; point HL to the beginning of the procedure address table
    LD C, A             ; get an index into the two-byte-per-element procedure address table  
    LD B, 0
    ADD HL, BC          ; pointer to the procedure address table entry now in HL
    LD C, (HL)
    INC HL
    LD B, (HL)
    DEC BC
    LD (StmtEnd), BC
    RET

; returns from procedure
run_ret:
    LD HL, (StackPtr)
    DEC HL
    LD B, (HL)
    DEC HL
    LD C, (HL)
    LD (StackPtr), HL
    INC BC
    INC BC
    LD (StmtEnd), BC        ; so that the next run_nextStmt call goes to the next statement after the user call
    RET

run_stop:
    LD IX, Terminated
    CALL writeLn
    LD SP, (Trap)
    RET

; declared array or record
run_declareArray:
    INC HL          ; move HL to the variable being declared
    PUSH HL         ; save the pointer into the statement
    LD A, (HL)      ; load variable index to A
    AND 01111111b   ; get the variable index
    SLA A           ; multiply it by 2, as numeric variables are 2 bytes long
    LD C, A
    LD B, 0
    LD HL, Vars         
    ADD HL, BC      ; get the variable address
    LD BC, (DataSeg)
    LD (HL), C      ; save the current pointer into the data segment as the value of the new variable...
    INC HL          ; ...i.e. set the variable to be the address of the beggining of the free space...
    LD (HL), B      ; ...in the data segment
    POP HL          ; restore the pointer into the statement
    CALL run_evaluate
    LD HL, (DataSeg)
    LD BC, (Expression + 1) ; the +1 skips the NUM_B bytecode
    SLA C           ; multiply the result of the expression by 2...
    RL  B           ; as the value of the expression means the number of 2-byte elements
    ADD HL, BC
    LD (DataSeg), HL
    RET



; checks if the bytecode pointed to by HL is a value
; i.e a literal or a variable
; result in A
run_isValue:
    LD A, (HL)    
    CP NUM_B        ; if the first byte of the bytecode is NUM_B, that indicates a literal numerical value   
    JR Z, .true
    AND 10000000b   ; if the top bit of the bytecode is set, that indicates a variable
    CP 0
    JR NZ, .true
    LD A, FALSE
    RET
.true:
    LD A, TRUE
    RET
