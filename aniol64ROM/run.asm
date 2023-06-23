; apl bytecode interpreter

MAX_EXPR_BCS    equ 64

CurrentBC       equ PROGRAM_DATA + 00h
PrevBC          equ PROGRAM_DATA + 02h
NextBC          equ PROGRAM_DATA + 04h
ExprStart       equ PROGRAM_DATA + 06
ExprEnd         equ PROGRAM_DATA + 08h
StmtStart       equ PROGRAM_DATA + 0Ah
StmtEnd         equ PROGRAM_DATA + 0Ch
EvalProgress    equ PROGRAM_DATA + 0Eh
Expression      equ 8280h
Vars            equ 8300h

; initialises the apl interpreter
run_init:
    LD HL, Bytecodes
    LD (StmtStart), HL      ; initilise the line pointer to the beginning of the program
    RET

run_main:
    CALL run_init
.loop:
    CALL run_findStmtEnd
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
    RET

; executes the current statement
run_execStmt:
    LD HL, (StmtStart)      ; check the first bytecode in the statement
    LD A, (HL)
    AND 10000000b           ; if the top bit of the bytecode is set, it's a variable
    CP 0
    JP NZ, run_execAssignment
    LD A, (HL)
    CP SYSCALL_B
    JP Z, run_execSyscall
    CP CALL_B
    JP Z, run_execUserCall
    ; TODO: handle unrecognised token

; moves HL to the next bytecode
run_nextBC:
    LD A, (HL)
    CP NUM_B
    JR Z, .three
    CP SYSCALL_B
    JR Z, .two          ; system calls are two bytes long
    CP CALL_B
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
run_evaluate:   
    LD IX, Expression
    INC HL              ; assuming this is called from run_execAssignment, and HL is pointing to the assignment operator
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
    CP CALL_B
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
    CALL run_evalMul
    CALL run_evalAdd
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

; checks if the bytecode in A is a single operand- type operator
; result in A
run_isOneOperandOp:
    CP NOT_B
    JR Z, .true
    CP ADDR_B
    JR Z, .true
    CP DEREFERENCE_B
    JR Z, .true
    ; TODO minus
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
    LD A, (HL)          ; load the next butecode into A
    CP EQUAL_B          ; check if the next token is the assignment operator
    JR NZ, .syntaxError
    CALL run_evaluate
    CP 0                ; check exit code for success
    JR NZ, .syntaxError
    LD HL, (StmtStart)  ; first bytecode of an assignment statement is a variable TODO: extract this to a routine
    LD A, (HL)          ; load the variable bytecode
    AND 01111111b       ; get the variable index
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

; executes a system function
run_execSyscall:
    RET


; executes a user-defined procedure
run_execUserCall:
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
