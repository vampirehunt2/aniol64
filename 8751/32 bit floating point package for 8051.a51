; 32bit Floating point package for the 8051
; This version is for the ASM51 assembler by Metalink Corporation (very similar to ASM51 from Intel)
;       By Jerson Fernandes
;       email : jerson@vsnl.com
;               jerson@geocities.com
;       From  : Bombay in India
;

;Bugs reported: to equal numbers if subtracted the result was 80 000000h and
;0 + 0 was resulting in 01 000000h.
;If Aarg negative and Barg positive the result was ever negative (mantissa MSB = 1)
;The mantissa of a result from a multiplication by zero was zero but the Aexp was not cleared
;A division by zero was not sinalized
;
;Fpadd32 routine corrected
;Bug on res0 subroutine fixed enabling true zero result
;Division by zero and division overflof flags added by Joao Roberto Gabbardo
;
;
; floating point format
; exponent, 24 bits mantissa
; xxxx xxxx, S.xxx xxxx  xxxx xxxx  xxxx xxxx
; stored internally from right to left

; ZERO      = 00 000000
; MAX float = FF 7FFFFF 6.80564673E+38 -> 2** 129
; MIN float = 01 000000 1.17549435E-38 -> 2**-126

; Int2Float converts the input number to float at Aarg
; Float2Int converts the Aarg register to integer @ Aarg

; Since the input is one 24 bits signed number the maximum range is:
; Zero    =  000000h  0000000
; MAX int =  7FFFFFh  8388607
; MIN int =  100000h -8388608

; so to cover all float range more than one product or division will be needed

; To convert to interger with mantissa (can be used to check if the result is right):
; 1) Separe the signal bit
; 2) Restore the leading one so we wil have 1.xxx xxxx  xxxx xxxx  xxxx xxxx
; 3) Subtract the bias (129) from the exponent to recover the exponent of two
; 4) De-normalize the number: move the move the binary point so the exponent
;    is 0 and the value of the number remains unchanged

$title(32 bit floating point package for 8051)
$mod51

FPPush    	Macro  FPreg
        	mov	a,FPreg          ;save the result
		push	acc
		mov	a,FPreg+1
		push	acc
		mov	a,FPreg+2
		push	acc
		mov	a,FPreg+3
		push	acc
          	endm

FPPop     	Macro  FPreg
		pop	acc             ;retrieve A
		mov	FPreg+3,a
		pop	acc
		mov	FPreg+2,a
		pop	acc
		mov	FPreg+1,a
		pop	acc
		mov	FPreg,a
          	endm


;=======  Auxiliary flags ====================
        BSEG
;these flags indicate to the user when one division by zero or a overflow division occured

Div_zero:	dbit	  1	;divide by zero flag
Div_ov:         dbit	  1	;division overflow flag

        DSEG at 8   ;--- This will allow you to link in the library on the DSEGment

;=======  Floating point variables ===========

float_arg	equ	3	;3 bytes mantissa
float_exp	equ	1	;1 byte exponent
expbias	        equ	128	;exponent bias

Quo:		ds	float_arg	;holds quotient of divide
Aarg:		ds	float_arg
Aexp:		ds	float_exp
Barg:		ds	float_arg
Bexp:		ds	float_exp
Aext:		ds	1		;extension for Aarg
Aext2:	        ds	1		;for holding the aligned bit

;=======  Floating point variables ===========

;--- Again, like before, this TOS (top of Stack) pointer is used just because this is a standalone program
;--- Not needed when you make this into a library.
;--- Just make sure your main program has declared enough room for the stack to grow

TOS:    ;	equ 	30h

        CSEG at 0           ;--- will allow the linker to stack this code in the code segment

;--- The ORG 0 directive has been used to test the module as a standalone program
;--- You may remove it when you want to assemble this into a library

	jmp start

	;org 30h

start:
	mov	sp,#TOS		        ;point to the top of stack

;to test the corrections using numbers in float

	mov Aarg,#00h
	mov Aarg+1,#00h
	mov Aarg+2,#00H
	mov Aexp,#80h

	mov Barg,#00h
	mov Barg+1,#00h
	mov Barg+2,#00h
	mov Bexp,#00h


	;call swap_ab

	;JB P1.0,$			;only to stop the routine here

	;call fpAdd32
	;call fpsubtract
	;call fpmul32
	call fpdiv32

	;call copy_ab

	JB P1.0,$			;only to stop the routine here

	mov Barg,#00h
	mov Barg+1,#00h
	mov Barg+2,#00h
	mov Bexp,#00h

	;call fpsubtract
	call fpAdd32

	JB P1.0,$			;only to stop the routine here

;same test but now using too the int2float and fpdivide to convert the numbers in float after

	mov Aarg,#64h		;100
	mov Aarg+1,#00h
	mov Aarg+2,#00h

	call int2float

	call copy_ab

	mov Aarg,#94h		;4,04
	mov Aarg+1,#01h
	mov Aarg+2,#00h

	call int2float
	call fpdiv32

	JB P1.0,$			;only to stop the routine here

	FPPush Aarg

	mov Aarg,#64h		;100
	mov Aarg+1,#00h
	mov Aarg+2,#00h

	call int2float

	call copy_ab

	mov Aarg,#92h		;402
	mov Aarg+1,#01h
	mov Aarg+2,#00h

	call int2float
	call fpdiv32

	JB P1.0,$			;only to stop the routine here

	call copy_ab

	FPPop Aarg

	;call fpadd32
	call fpsubtract
	call copy_ab
	mov Aarg,#64h		;100
	mov Aarg+1,#00h
	mov Aarg+2,#00h

	call int2float
	call fpmul32
	call float2int

	jmp $

;*******************************************************************************************

	;JMP	floatint		;only to test the floating routine

	mov   Aarg,#10h          	;define a 24 bit integer value +1000
      mov   Aarg+1,#27h
	mov	Aarg+2,#00h
      call  int2float

	;JB P1.0,$			;only to test the the int2float routine

	;
	call	copy_ab                 ;copy it to floating B register
	;
      mov   Aarg,#95h          	;define 24 bit integer value +1000
      mov   Aarg+1,#01h
	mov	Aarg+2,#00h
	call	int2float
      ;
	;call	fpmul32                 ;multiply A & B
	;
	call	fpdiv32         	;A / B - divide A by B

	JB P1.0,$			;somente para verificar o resultado

      ;FPPush  Aarg			;save result on stack - run macro FPPush

	call copy_ab			;copia resultado em B - somente para obtenção dos coeficientes

	JB P1.0,$			;somente para verificar o resultado

	mov	Aarg,#0E4H
	mov	Aarg+1,#0FFH
	mov 	Aarg+2,#0FFH
	call	int2float
	;call	copy_ab                 ;B = 50000 - move float to Barg/Bexp
      ;
      ;FPPop   Aarg			;restore the result on Aarg - run macro FPPop
      ;
      lcall	fpdiv32         		;A / B - divide A by B
      	;
	acall	copy_ab                 ;copy the result to B
	;
	mov	Aarg,#high 500
	mov	Aarg+1,#low 500       	;Add 5000
	mov	Aarg+2,#00H
	acall	int2float
	;
      lcall   fpAdd32			;to test the addition routine
	;lcall	fpsubtract		;to test the subtraction routine
      ;                             ;Now convert the result to 24 bit integer

floatint:
	;lcall	float2int

	sjmp	$



;========================================================================

; 32bit Floating point package for the 8051
; floating point format
; exponent, 24 bits mantissa
; xxxxxxxx, S.xxxxxxx xxxxxxxx xxxxxxxx
; stored internally from right to left


;Copy ArgA to ArgB

Copy_AB:
	mov	r7,#float_arg
	mov	r0,#Aarg
	mov	r1,#Barg
copy_AB_5:
 	mov	a,@r0
	mov	@r1,a
	inc	r0
	inc	r1
	djnz	r7,copy_AB_5
	mov	Bexp,Aexp
	ret

;Copy ArgB to ArgA

Copy_BA:
	mov	r7,#float_arg
	mov	r0,#Barg
	mov	r1,#Aarg
copy_BA_5:
 	mov	a,@r0
	mov	@r1,a
	inc	r0
	inc	r1
	djnz	r7,copy_BA_5
	mov	Aexp,Bexp
	ret

;Swap A and B registers
;
Swap_AB:
      mov     r0,#Aarg
      mov     r1,#Barg
      mov     r2,#Float_Arg   ;counter
Sw10:
	xch     a,@r0           ; [r0] ->  A
      xch     a,@r1           ; [r1] <-> A
      xch     a,@r0           ; [r0] <-  A
      inc     r0
      inc     r1
      djnz    r2,Sw10
      ;
      xch     a,Aexp
      xch     a,Bexp
      xch     a,Aexp
      ret

; Negate mantissa
; INPUT   R0 - pointer to the mantissa LSB to negate
; OUTPUT       negated mantissa
;
Negate:
      mov     a,@r0
	cpl	  a
	add	  a,#1	;2s complement
	mov	  @r0,a
      inc     r0
	mov	  a,@r0
	cpl	  a
	addc	  a,#0
	mov	  @r0,a
      inc     r0
	mov	  a,@r0
	cpl	  a
	addc	  a,#0
	mov	  @r0,a
      ret

; Convert a integer to a floating point number
; Input	- 24 bit signed integer @ Aarg
; Output- 32 bit floating point number @ Aarg

int2float:

; Normalize the 24 bit signed integer in Aarg

Normalize:
	mov	  r6,#24		;exponent counter
	mov	  a,Aarg+2	;extract sign
	anl	  a,#80h
	mov	  r5,a		;keep in R5
	jz	  norm5

      ;negative number make +ve as we have the sign
      mov     r0,#Aarg
      lcall   Negate

Norm5:
	mov	  r0,#Aarg+2
	mov	  a,@r0
	orl	  a,#0
	jnz	  Norm10
	;the highest 8 are 0, shift 8
	mov	  a,#0
	xch	  a,Aarg
	xch	  a,Aarg+1
	xch	  a,Aarg+2
	clr	  c
	mov	  a,r6
	subb	  a,#8
	mov	  r6,a		;update the exponent
	;
      jz      Norm0           ;if no more exponent, its zero (0)
	jnc	  Norm5           ;continue if still more is left of the exponent
      ;
Norm10:
	mov	  a,@r0		;read the msb
 	jb	  Acc.7,Norm_end
	;shift one bit left
	mov	  a,Aarg
	clr	  c
	rlc	  a
	mov	  Aarg,a
	mov	  a,Aarg+1
	rlc	  a
	mov	  Aarg+1,a
	mov	  a,Aarg+2
	rlc	  a
	mov	  Aarg+2,a
	djnz	  r6,Norm10	;note the shift in the exponent too

Norm_end:
	mov	  a,#expbias
	add	  a,r6
	mov	  Aexp,a

	;now make the msbit implicit and put in the sign there

	mov	  a,r5
	orl	  a,#7fh
	anl	  a,Aarg+2
	mov	  Aarg+2,a	;sign is always for int2float
	ret
Norm0:
      mov     Aexp,a
      ret

; Float to integer conversion routine
; Input	- floating point number in Aarg,Aexp
; Output- 24 bit signed integer in Aarg
float2int:
	mov	  a,Aexp
	clr	  c
	subb	  a,#expbias
	jc	  res0	      ;result is 0
	cjne	  a,#24,$+3		;overflow,return a 0 int
	jnc	  res0
	mov	  r6,a	      ;keep the exponent here
	;find out how much to shift the float to get our int
	mov	  a,#24
	clr	  c
	subb	  a,r6
	mov	  r6,a
	;take out the sign and make msb explicit
	mov	  a,Aarg+2		;keep in R5
	mov	  r5,a
	orl	  a,#80h
	mov	  Aarg+2,a		;explicit msb
	;now shift the float to form the int
flint10:
	mov	  a,r6		;if exp >= 8, shift bytes
	clr	  c
	subb	  a,#9
	jnc	  flint20
	;now do bit shifts
flint15:
 	clr	  c
	mov	  a,Aarg+2
	rrc	  a
	mov	  Aarg+2,a
	mov	  a,Aarg+1
	rrc	  a
	mov	  Aarg+1,a
	mov	  a,Aarg+0
	rrc	  a
	mov	  Aarg+0,a
	djnz	  r6,flint15
	;we're done getting the int,restore the sign
	mov	  a,r5
	anl	  a,#80h
	jz	flint30
	;restore the negative number
      mov     r0,#Aarg
      lcall   Negate
flint30:
	ret

flint20:
 	;shift right 8 bits
	clr	  a
	xch	  a,Aarg+2
	xch	  a,Aarg+1
	xch	  a,Aarg+0
	;and adjust the exp counter in r6
	mov	  a,r6
	subb	  a,#8
	mov	  r6,a
	sjmp	flint10

;Make Aarg,Aexp zero

res0:
	clr	  a
	mov	  Aarg+0,a
	mov	  Aarg+1,a
	mov	  Aarg+2,a
	mov	  Aexp,a
	ret

;Floating point divide
; Input	- Arg 1 in Aarg, Aexp
;		- Arg 2 in Barg, Bexp
; Output- Divide arg1 by arg2
;		- result in Aarg
; Temp	- R5 resulting sign
; acc for dividend is
;          Aarg[2,1,0],Quo[2,1,0] msb first

fpdiv32:
	;check if Bexp == 0
	clr	  Div_zero
	clr	  Div_ov
	mov	  a,Bexp
	jnz	  fpd10
	ajmp	  fpdivz
fpd10:
	mov	  a,Aarg+2		;extract resulting sign
	xrl	  a,Barg+2
	anl	  a,#80h		;keep the sign bit here
	mov	  r5,a
	;make the msb explicit in args
	mov	  a,#80h
	orl	  a,Aarg+2
	mov	  Aarg+2,a
	mov	  a,#80h
	orl	  a,Barg+2
	mov	  Barg+2,a
	;if A<B mantissa, divide, else align
	clr	  a
	mov	  Quo,a
	mov	  Quo+1,a
	mov	  Quo+2,a
	clr	  c
	mov	  a,Aarg
	subb	  a,Barg
	mov	  a,Aarg+1
	subb	  a,Barg+1
	mov	  a,Aarg+2
	subb	  a,Barg+2
	jc	  fpdok
	;make A mantissa < B mantissa
	clr	  c
	mov	  a,Aarg+2	;msb
	rrc	  a
	mov	  Aarg+2,a
	mov	  a,Aarg+1
	rrc	  a
	mov	  Aarg+1,a
	mov	  a,Aarg
	rrc	  a
	mov	  Aarg,a		;lsb
	mov	  a,Aext2		;msb
	rrc	  a
	mov	  Aext2,a		;move into quotient
	;adjust the Aexp accordingly
	mov	  a,Aexp
	inc	  a
	mov	  Aexp,a
	;get the resulting exponent in Aexp
fpdok:
	clr	  c
	mov	  a,Aexp
	subb	  a,Bexp
	add	  a,#expbias
	mov	  Aexp,a	;resulting exponent here
fpdargok:
	clr	  a
	mov	  Aext,a
	mov	  r7,#24	;initialize bit counter for divide
fpdloop32:
 	;shift left 1 bit
 	clr	  c
	mov	  a,Aext2
	rlc	  a
	mov	  Aext2,a
	mov	  a,Aarg+0
	rlc	  a
	mov	  Aarg+0,a
	mov	  a,Aarg+1
	rlc	  a
	mov	  Aarg+1,a
	mov	  a,Aarg+2
	rlc	  a
	mov	  Aarg+2,a
	;move the bit into our accumulator
	mov	  a,Aext
	rlc	  a
	mov	  Aext,a
	;subtract
	clr	  c
	mov	  a,Aarg+0
	subb	  a,Barg+0
	mov	  a,Aarg+1
	subb	  a,Barg+1
	mov	  a,Aarg+2
	subb	  a,Barg+2
	mov	  a,Aext
	subb	  a,#0
	jc	  nosub		;cannot subtract
	clr	  c
	mov	  a,Aarg+0		;subtract
	subb	  a,Barg+0
	mov	  Aarg+0,a
	mov	  a,Aarg+1
	subb	  a,Barg+1
	mov	  Aarg+1,a
	mov	  a,Aarg+2
	subb	  a,Barg+2
	mov	  Aarg+2,a
	mov	  a,Aext
	subb	  a,#0
	mov	  Aext,a
nosub:
	cpl	  c			;shift in the complement of C
	mov	  a,Quo		;into the result
	rlc	  a
	mov	  Quo,a
	mov	  a,Quo+1
	rlc	  a
	mov	  Quo+1,a
	mov	  a,Quo+2
	rlc	  a
	mov	  Quo+2,a
	djnz	  r7,fpdloop32
	;move the quotient to Aarg and make msb implicit
	mov	  a,Quo+1
	mov	  Aarg+1,a
	mov	  a,Quo+0
	mov	  Aarg+0,a
	mov	  a,r5
	jnz	  minusdiv
	mov	  a,Quo+2
	anl	  a,#7fh		;make msb implicit if +ve number
	mov	  Aarg+2,a
	ret
minusdiv:
 	mov	  a,Quo+2
	mov	  Aarg+2,a
	ret
fpdivz:
	;return divide by zero error
	setb   Div_zero		;sinalize a division by zero
	ret
fpov:	;return divide overflow
	setb	 Div_ov		;sinalize a division overflow
 	ret

;Floating point multiplication
; Input	- Aarg,Aexp
;		- Barg,Bexp
; Output- Aarg,Aexp
; partial product = Quo[2..0],Aarg[2..0]

fpmul32:
	;if A == 0 || B == 0 result = 0
	mov	  a,Aexp
	jz	  fpm10
	mov	  a,Bexp
	jnz	  fpm20
fpm10:
	ljmp	  res0
fpm20:				; get the resulting exponent
	clr	  c
	mov	  a,Aexp
	subb	  a,#expbias
	add	  a,Bexp
	mov	  Aexp,a		;store resulting exponent here
	jnc	  fpm30
	ljmp	  fpov
fpm30:
	mov	  a,Aarg+2		;extract resulting sign
	xrl	  a,Barg+2
	anl	  a,#80h		;keep the sign bit here
	mov	  r5,a
	;make the msb explicit in args
      mov	  a,Aarg+2
	orl	  a,#80h
	mov	  Aarg+2,a
	mov  	  a,Barg+2
	orl	  a,#80h
	mov	  Barg+2,a
	;now multiply using Quo as the partial product
	clr	  a
	mov	  Quo,a
	mov	  Quo+1,a
	mov	  Quo+2,a
	mov	  r7,#24		;bits
fpmloop:
	mov	  a,Aarg
	rrc	  a
	jnc	  fpmnoadd
	;add the multiplier to the product
	mov	  a,Quo
	add	  a,Barg
	mov	  Quo,a
	mov	  a,Quo+1
	addc	  a,Barg+1
	mov	  Quo+1,a
	mov	  a,Quo+2
	addc	  a,Barg+2
	mov	  Quo+2,a
fpmnoadd:
	;right shift the product
	mov	  a,Quo+2
	rrc	  a
	mov	  Quo+2,a
	mov	  a,Quo+1
	rrc	  a
	mov	  Quo+1,a
	mov	  a,Quo
	rrc	  a
	mov	  Quo,a
	;shift right the multiplicand
	clr	  c
	mov	  a,Aarg+2
	rrc	  a
	mov	  Aarg+2,a
	mov	  a,Aarg+1
	rrc	  a
	mov	  Aarg+1,a
	mov	  a,Aarg
	rrc	  a
	mov	  Aarg,a
fpm40:
	djnz	  r7,fpmloop
	;multiplication is over
	;check for normalisation now
	mov	  a,Quo+2
	jb	  acc.7,fpm50
	clr	  c
	mov	  a,Quo
	rlc	  a
	mov	  Quo,a
	mov	  a,Quo+1
	rlc	  a
	mov	  Quo+1,a
	mov	  a,Quo+2
	rlc	  a
	mov	  Quo+2,a
	dec	  Aexp
fpm50:
	mov	  Aarg,Quo
	mov	  Aarg+1,Quo+1
	mov	  a,r5
	anl	  a,#80h			;check sign of result
	jz	  fpmplus
	mov	  Aarg+2,Quo+2
	ret

fpmplus:
 	mov	  a,Quo+2
 	anl	  a,#7fh
	mov	  Aarg+2,a
	ret

;Floating point subtraction
;       B = -B
fpSubtract:
      	mov   a,Barg+2
      		xrl   a,#80h
      mov   Barg+2,a        		;change the sign of B
      	; and now do the addition as usual
      	ljmp  fpAdd32

;Floating point addition
; If A == 0, return B as result
; If B == 0, return A as result
; Make Bexp = Aexp by increasing the exponent
;      Aarg += Barg
; Result is in Aarg
;
; Declare Local Variables a la Keil :-)
;  R6 = XOR of signs
;  R5 = sign of A
;  R4 = exp shift counter
;

XORsign         set     R6
Asign           set     R5
Bsign		    set	R3
ExpCtr          set     R4

fpAdd32:
	mov	r1,#08h		;Aarg,Aexp and Barg,Bexp = 0?
	mov	r0,#Aarg
tst_0:
	mov	a,@r0
	cjne	a,#00h,fpA_1
	inc	r0
	djnz	r1,tst_0
	ret				;if so return

fpA_1:
      mov   a,Aarg+2
      xrl   a,Barg+2
      anl   a,#80h          	;keep XOR of signs in R6
      mov   XORsign,a
	mov   a,Aarg+2
fpA10:
      ;save sign of A in R5
      mov   a,Aarg+2
      anl   a,#80h
      mov   Asign,a

	;save sign of B in R3
	mov   a,Barg+2
      anl   a,#80h
      mov   Bsign,a
      ;
      ; Now make the MS bits explicit in both mantissas
      mov   a,Aarg+2
      orl   a,#80h
      mov   Aarg+2,a
      ;
      mov   a,Barg+2
      orl   a,#80h
      mov   Barg+2,a
      ;
	;if (Aexp == Bexp) fpA40
      clr   c
      mov   a,Aexp
      subb  a,Bexp
      jz    fpA40

	mov   ExpCtr,a    ;keep Aexp-Bexp shift count in R4

	jc	fpA15		;if Aexp > Bexp
	call  FPawhile	;make Aexp = Bexp shifting Bexp right
	jmp   fpA40
	;
fpA15:
	clr   c
	mov   a,Bexp
	subb  a,Aexp
	mov   ExpCtr,a    ;keep Bexp-Aexp shift count in R4
	call  Swap_AB	;if Aexp < Bexp exchange Aexp with Bexp
	call  FPawhile	;make Aexp = Bexp
	call  Swap_AB	;restore Aexp and Bexp
	;
fpA40:
	mov   a,XORsign		;are both Asign and Bsign +ve or -ve?
	jz    fpA50			;if so don't negate

	mov a,Asign			;Asign = R5
	jz fpA41			;Asign -ve? (Asign  = 1)

	mov r0,#Aarg		;if so negate A mantissa
	lcall Negate
	jmp fpA50

fpA41:
	mov r0,#Barg		;if no negate B mantissa
	lcall Negate

fpA50:
      ;add A = A+B
      mov   r0,#Aarg
      mov   r1,#Barg
      mov   r2,#Float_arg   		;counter
      clr   c
fpA45:
      mov   a,@r0
      addc  a,@r1
      mov   @r0,a
      inc   r0
      inc   r1
      djnz  r2,fpA45
      ;
      ;done with addition
	;
      mov   a,XORsign       		;numbers are both +ve or -ve?
	jnz	XORsign_1			;XORsign = 0 means  +ve + +ve or -ve + -ve
	jnc	Norm_1			;carry = 0 means 0 + number
	;
fpCorrect:
      ;if Cy is left over, shift the Aarg and correct the exponent
      mov	a,Aarg+2
	rrc	a
	mov	Aarg+2,a
	mov	a,Aarg+1
	rrc	a
	mov	Aarg+1,a
	mov	a,Aarg
	rrc	a
	mov	Aarg,a
      ; Aexp ++;
      inc   Aexp
	;
test_sign:
	mov 	a,Asign			;test to see is the result is +ve or -ve
	orl 	a,Bsign
	jnz	end_fadd			;result is negative?
	;
MSB_zero:
	mov	a,Aarg+2			;if no let MSB = 0
	anl	a,#7Fh
	mov	Aarg+2,a
end_fadd:
	ret
	;
norm_1:
	call	fpANrm
 	jmp	test_sign
	;
XORsign_1:
	jc 	norm_2			;-ve number?
	mov	r0,#Aarg			;if so complement
	call	Negate
	jmp	fpAnrm			;and normalize
norm_2:
	call	FPAnrm			;else normalize
	jmp	MSB_zero			;and MSB = 0


	;
fpANrm:
      ;Normalize the result
      mov	a,Aarg+2			;read the msb
 	jb	Acc.7,fpAend
	;shift one bit left
	mov	a,Aarg
	clr	c
	rlc	a
	mov	Aarg,a
	mov	a,Aarg+1
	rlc	a
	mov	Aarg+1,a
	mov	a,Aarg+2
	rlc	a
	mov	Aarg+2,a
      ;
      dec   Aexp
      ;
	mov     a,Aexp
     	cjne    a,#00h,fpANrm
fpAend:
	ret

fpAWhile:
      ; Barg >>= 1;
      clr	c
      mov	a,Barg+2
	rrc	a
	mov	Barg+2,a
	mov	a,Barg+1
	rrc	a
	mov	Barg+1,a
	mov	a,Barg
	rrc	a
	mov	Barg,a

      ; Bexp ++;
      inc   Bexp
      djnz  ExpCtr,fpAWhile

	ret

        end
