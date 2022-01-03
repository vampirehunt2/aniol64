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
;cti equ PROGRAM_DATA + 3  ; current token index
token equ PROGRAM_DATA + 4 ; 20 byte buffer for the currently parsed token
tokens equ PROGRAM_DATA + 24 ; array of 2-byte tokens

PROC
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
        JR Z, _cal_main_exit
        JP cal_main_loop
_cal_error:
        CALL lcd_gotoLn4
        LD IX, CalError
        CALL lcd_wriStr
        CALL kbd_readKey
        CALL lcd_gotoLn4
        LD IX, BlankLine
        CALL lcd_wriStr
        JP cal_main_loop
_cal_main_exit:
        RET
ENDP

; processes the first token of a string
; and puts it in the tokens array at current index
; and modifies the input string to cut out the token
; IX: address of the string
PROC
defb "cal_nextToken"
cal_nextToken:
        LD A, (IX)
        CP OPEN_BRACKET
        JR Z, _storeSymbol
        CP CLOSE_BRACKET
        JR Z, _storeSymbol
        CP PLUS
        JR Z, _storeSymbol
        CP PLUS
        JR Z, _storeSymbol
        CP MINUS
        JR Z, _storeSymbol
        CP ASTERISK
        JR Z, _storeSymbol
        CP SLASH
        JR Z, _storeSymbol
        CP PERCENT
        JR Z, _storeSymbol
        CALL isHexDigit
        CP 1
        JR Z, _tokenizeNumber
_tokenizeNumber:
        LD IY, token
_tokenizeNumberLoop:
        LD A, (IX)
        CALL isHexDigit
        CP 0
        JR Z, _endOfNumber
        LD A, (IX)
        LD (IY), A
        INC IX
        INC IY
        JR _tokenizeNumberLoop
_endOfNumber:
        LD A, 0
        LD (IY), A
        PUSH IX
        LD IX, token
        CALL parseByte
        CP 0                   ; check for parsing errors
        JR NZ, _error          ; process parse errors
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
_storeSymbol:                  ; saving the currently process math symbol in the tokens array
        LD IY, tokens          ; point IY to the beginning of the tokens array
        LD D, 0
        ADD IY, DE
        LD (IY), A             ; store the symbol to the tokens table at current index
        LD A, 0
        LD (IY + 1), A         ; store a trailing zero, as the second byte of the token is not used for symbols
        INC E
        INC E
        INC IX                 ; discard the processed token
        RET
_error:
        POP IX
        RET
ENDP

PROC
defb "cal_tokenize"
cal_tokenize:
        ; init the variables
        LD A, -1
        LD (obi), A
        LD E, 0 ; current token index
_tokenizeLoop:
        CALL str_ltrim
        CALL str_len
        CP 0
        JR Z, _endOfLine
        CALL cal_nextToken
        JR _tokenizeLoop
_endOfLine
        LD IY, tokens          ; point IY to the beginning of the tokens array
        LD D, 0
        ADD IY, DE
        LD A, EOL
        LD (IY), A             ; store the EOL to the tokens table at current index
        RET
ENDP
