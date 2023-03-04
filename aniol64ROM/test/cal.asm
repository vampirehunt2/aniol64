;----------------------------------------------------
; Project: aniol64.zdsp
; File: cal.asm
; Date: 1/3/2022 15:03:50
;
; Created with zDevStudio - Z80 Development Studio.
;
;----------------------------------------------------

;token types
PERCENT equ 37  ; modulo operator
OPEN_BRACKET equ 40
CLOSE_BRACKET equ 41
ASTERISK equ 42 ; multiply
PLUS equ 43     ; add
MINUS equ 45    ; subtract
SLASH equ 47    ; divide
NUMBER equ 1    ; the byte following the 1 is the value of the number
EOL equ 2       ; end of line

Title: defb "     Calculator     ", 0
CalExit: defb "bye", 0
CalError: defb "Syntax error", 0

; variables
start equ PROGRAM_DATA
stop equ PROGRAM_DATA + 1
obi equ PROGRAM_DATA + 2   ; open bracket index
cti equ PROGRAM_DATA + 3  ; current token index
token equ PROGRAM_DATA + 4 ; 20 byte buffer for the currently parsed token
tokens equ PROGRAM_DATA + 24 ; array of 2-byte tokens

cal_main:
        CALL lcd_clrScr
        LD IX, Title
        CALL lcd_wriStr
cal_main_loop:
        ; init the screen
        CALL lcd_gotoLn2
        LD IX, BlankLine
        CALL lcd_wriStr
        CALL lcd_gotoLn3
        LD IX, BlankLine
        CALL lcd_wriStr
        CALL lcd_gotoLn2
        ; get input and process line
        CALL kbd_readLine
        LD IX, LineBuff
        LD IY, CalExit
        CALL str_cmp
        JR Z, .cal_main_exit ; if the string contains the exit command, quit
        LD IX, LineBuff ; reload, because str_cmp does not preserve IX
        CALL cal_tokenize
        JP cal_main_loop
.cal_error:
        CALL lcd_gotoLn4
        LD IX, CalError
        CALL lcd_wriStr
        CALL kbd_readKey
        CALL lcd_gotoLn4
        LD IX, BlankLine
        CALL lcd_wriStr
        JP cal_main_loop
.cal_main_exit:
        RET

cal_eval:
        RET

; evaluates an expression that does not contain parantheses
; start - index of the first byte of the first token of the expression
;   in the tokens table
; stop - index of the first byte of the last token of the expression
;   in the tokens table
db "cal_eval_simple"
cal_eval_simple:
; save state
        PUSH IX
        PUSH BC
; initialise the data
        LD IX, tokens    ; point IX to the beginning of the tokens table
        LD B, 0
        LD A, (start)
        LD (cti), A       ; point cti to the start index of the expression
        LD C, A
        ADD IX, BC        ; point IX to the first byte of the first token
        LD A, (stop)
        LD B, A           ; from now on the stop variable is stored in B
.loop:
        LD A, (IX)        ; load the first byte of the current token
        CP ASTERISK
        CALL Z, cal_mul    ; do multiplication and division first...
        CP SLASH           ; ...to maintain operator priority
        CALL Z, cal_div
        LD A, (cti)
        CP B
        JP Z, .end      ; if reached the end of the expression, exit
        INC IX          ; else move two bytes over, to the next token
        INC IX
        INC A
        INC A
        LD (cti), A
        JP .loop
.end:
        POP BC
        POP IX
        RET

; prepares operands for a binary arithmetic operation
; by putting the first one in B and the second one in C
cal_prep_operands:
        PUSH IX
        DEC IX  ; second byte of the previous token
        LD A, (IX)
        LD B, A ; first operand stored in B
        INC IX
        INC IX
        INC IX
        INC IX ; second byte of the following token
        LD A, (IX)
        LD C, A  ; second operand stored in C
        POP IX
        RET

cal_shift_expr:
; IX at this point contains address of the first byte of the operator token
        PUSH IX
        PUSH AF
        DEC IX
        DEC IX  ; point IX to the first byte of the first operand
        LD A, NUMBER
        LD (IX), A  ; store the token type indicating number
        POP AF  ; A now contains the result of the previously executed arithmetic operation
        INC IX
        LD (IX), A  ; store the number value
        INC IX ; now pointing IX to the first byte of the first token that needs to be overwritten
.loop:
        LD A, (IX + 4) ; skipping over 2 tokens - the operator and the second operand
        LD (IX), A
        CP EOL      ; check if we've reached the end of the expression
        INC IX
        INC IX
        JR NZ, .loop   ; if not, proceed on
.end:
        LD A, (stop)  ; after the shift the expression is now two tokens shorter...
        DEC A         ; ...because we've replaced two operands and one operator...
        DEC A         ; ...with a single result, so decreasing stop by 4
        DEC A
        DEC A
        LD (stop), A
        POP IX
        RET

;
cal_mul:
        AND A ; clear carry
        PUSH BC
        CALL cal_prep_operands
.loop:
        PUSH AF
        LD A, B
        CP 0
        JR Z, .zero
        POP AF
        LD A, 0
        ADD A, C
        DJNZ .loop
        JR .end
.zero:
        POP AF  ; if first operand is 0 then return 0 in A
        LD A, 0
.end:
        CALL cal_shift_expr
        POP BC
        RET

cal_div:
        PUSH BC
        CALL cal_prep_operands
        LD A, B
        LD B, 0
        AND A ; clear carry
.loop:
        CP C
        JR C, .end
        SUB C
        INC B
        JR .loop
.end:
        LD A, B
        CALL cal_shift_expr
        POP BC
        RET

cal_add:
        PUSH BC
        CALL cal_prep_operands
        AND A ; clear carry
        LD A, B
        ADD A, C
        CALL cal_shift_expr
        POP BC
        RET

cal_sub:
        PUSH BC
        CALL cal_prep_operands
        LD A, B
        SUB C
        CALL cal_shift_expr
        POP BC
        RET



; breaks down a line into tokens.
; puts the tokens into the 'tokens' table
; each token consists of two bytes:
; operators have the ascii code of the operator and a padding zero
; operands have a NUMBER constand follwed by the number itself
; IX - address of the string to tokenize
 defb "cal_tokenize"
cal_tokenize:
        ; init the variables
        LD A, -1
        LD (obi), A
        LD E, 0 ; current token index
.tokenizeLoop:
        CALL str_ltrim
        CALL str_len
        CP 0
        JR Z, .endOfLine
        CALL cal_nextToken
        JR .tokenizeLoop
.endOfLine
        LD IY, tokens          ; point IY to the beginning of the tokens array
        LD D, 0
        ADD IY, DE
        LD A, EOL
        LD (IY), A             ; store the EOL to the tokens table at current index
        RET

; processes the first token of a string
; and puts it in the tokens array at current index
; and modifies the input string to cut out the token
; IX: address of the string
 defb "cal_nextToken"
cal_nextToken:
        LD A, (IX)
        CP OPEN_BRACKET
        JR Z, .storeSymbol
        CP CLOSE_BRACKET
        JR Z, .storeSymbol
        CP PLUS
        JR Z, .storeSymbol
        CP PLUS
        JR Z, .storeSymbol
        CP MINUS
        JR Z, .storeSymbol
        CP ASTERISK
        JR Z, .storeSymbol
        CP SLASH
        JR Z, .storeSymbol
        CP PERCENT
        JR Z, .storeSymbol
        CALL isHexDigit
        CP 1
        JR Z, .tokenizeNumber
.tokenizeNumber:
        LD IY, token
.tokenizeNumberLoop:
        LD A, (IX)
        CALL isHexDigit
        CP 0
        JR Z, .endOfNumber
        LD A, (IX)
        LD (IY), A
        INC IX
        INC IY
        JR .tokenizeNumberLoop
.endOfNumber:
        LD A, 0
        LD (IY), A
        PUSH IX
        LD IX, token
        CALL parseByte
        CP 0                   ; check for parsing errors
        JR NZ, .error          ; process parse errors
        LD IY, tokens          ; point IY to the beginning of the tokens array
        LD D, 0
        ADD IY, DE
        LD A, NUMBER
        LD (IY), A              ; save the constant identifying a number in the first byte of the tokens array entry
        INC IY
        LD (IY), B              ; save the actual value of the number in the second byte of the tokens array entry
        POP IX                  ; restore IX to point to the input line again, so that next token can be parsed out
        INC E
        INC E
        RET
.storeSymbol:                  ; saving the currently process math symbol in the tokens array
        LD IY, tokens          ; point IY to the beginning of the tokens array
        LD D, 0
        ADD IY, DE
        LD (IY), A             ; store the symbol to the tokens table at current index
        LD A, 0
        LD (IY + 1), A         ; padding, as the second byte of the token is not used for symbols
        INC E
        INC E
        INC IX                 ; discard the processed token
        RET
.error:
        POP IX
        RET


