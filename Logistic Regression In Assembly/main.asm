INCLUDE irvine32.inc
INCLUDE macros.inc

.data 
targetY     DWORD 186,127,158,141,168,185,185,184,117,179,144,179,133,121,150,157,159,112,132,169,209,166,199,158,221
currScoreX  DWORD 90,115,112,129,120,130,103,133,109,140,100,149,111,110,140,89,100,97,110,128,135,155,180,142,149
XMeanSub    REAL8 lengthof currScoreX DUP (?)
YMeanSub    REAL8 lengthof targetY DUP (?)
meanX		BYTE "The mean sub array of x is: ",0
meanY		BYTE "The mean sub array of y is: ",0
medianX     Byte "The mean of CurrentScoreX is: ",0
medianY	    Byte "The mean of targetY is: ",0
y_intercept Byte "The y-intercept is equal to: ",0
slope	    Byte "The slope is equal to: ",0
co_relation Byte "The co-relation constant is equal to: ",0
SDX		    Byte "The standard deviation of x is equal to: ",0
SDY 	    Byte "The standard deviation of y is equal to: ",0
SummationX  Byte "The sum of current score is equal to: ",0
SummationY  Byte "The sum of target is equal to: ",0
equation	BYTE "The equation of linear regression is: ",0
slopeVal	BYTE "The value of b is: ",0
interVal	BYTE "The value of a is: ",0
addition	BYTE " + ",0
x			BYTE " . x",0
y			BYTE "y = "
r			REAL8 ?
a			REAL8 ?
b			REAL8 ?
SumX		DWORD ?
SumY		DWORD ?
sep		    Byte " | ", 0
medOfX      REAL8 ?
medOfY      REAL8 ?
StandardX   REAL8 ?
StandardY	REAL8 ?
temp		SDWORD ?


.code
main PROC

; Printing both the x and y co-ordinate arrays
MOV esi, OFFSET targetY
MOV edi, OFFSET currScoreX
MOV ecx, LENGTHOF targetY
MOV edx, OFFSET sep
Display:
	MOV eax, [esi]
	call WriteDec
	call WriteString
	MOV eax, [edi]
	call WriteDec
	ADD esi, 4
	ADD edi, 4
	call crlf
LOOP Display
call crlf
call crlf

; initializing the mansub array for both the co-ordinates
MeanSubforX:
	mov esi, 0
	mov edi, 0
	mov ecx, lengthof CurrScoreX
	mov edx, OFFSET meanX
	call WriteString
	call crlf
	finit
	fld medOfX
	XMeanCalculate:
		fild CurrScoreX[esi * TYPE CurrScoreX]
		fsub st, st(1)
		call WriteFloat
		call crlf
		fstp XMeanSub[esi * TYPE XMeanSub]
		inc esi
		inc edi
	loop XMeanCalculate
	call crlf
	call crlf

MeanSubforY:
	mov esi, 0
	mov edi, 0
	mov ecx, lengthof targetY
	mov edx, OFFSET meanY
	call WriteString
	call crlf
	finit
	fld medOfY
	YMeanCalculate:
		fild targetY[esi * TYPE targetY]
		fsub st, st(1)
		call WriteFloat
		call crlf
		fstp YMeanSub[esi * TYPE YMeanSub]
		inc esi
		inc edi
	loop YMeanCalculate
	call crlf
	call crlf


; calling sum and median function to calculate the average of x
; calling sum
push OFFSET SumX
push OFFSET currScoreX
push lengthof currScoreX
push TYPE currScoreX
call sumarr
mov edx, OFFSET SummationX
call WriteString
mov eax, SumX
call WriteDec
call crlf
; calling median
MOV ecx, LENGTHOF currScoreX
MOV temp, ecx
MOV esi, 0
fldz
MED1:
	fild currScoreX[esi]
	fadd 
	ADD esi, TYPE DWORD
LOOP MED1
fidiv temp
fstp medOfX
fld medOfX
mov edx, OFFSET medianX
call WriteString
call WriteFloat
call crlf


; calling sum and median function to calculate the average of y
; calling sum
push OFFSET SumY
push OFFSET targetY
push lengthof targetY
push TYPE targetY
call sumarr
mov edx, OFFSET SummationY
call WriteString
mov eax, SumY
call WriteDec
call crlf
; calling median
MOV ecx, LENGTHOF targetY
MOV temp, ecx
MOV esi, 0
fldz
MED2:
	fild targetY[esi]
	fadd 
	ADD esi, TYPE DWORD
LOOP MED2
fidiv temp
fstp medOfY
fld medOfY
mov edx, OFFSET medianY
call WriteString
call WriteFloat
call crlf

; calculating the standard deviation of x
mov ecx, lengthof CurrScoreX
mov esi, 0
mov temp, 0
finit
fldz
fld medOfX
SD1:
	fild CurrScoreX[esi]
	fsub st,st(1)
	fmul st, st(0)
	faddp st(2), st
	add esi, TYPE CurrScoreX
loop SD1
mov eax, lengthof CurrScoreX
dec eax
mov temp, eax
fild temp
fdiv
fstp st(1)
fsqrt
fst StandardX
mov edx, OFFSET SDX
call WriteString
call WriteFloat
call crlf


; calculating the standard deviation of y
mov ecx, lengthof targetY
mov esi, 0
mov temp, 0
finit
fldz
fld medOfY
SD2:
	fild targetY[esi]
	fsub st,st(1)
	fmul st, st(0)
	faddp st(2), st
	add esi, TYPE targetY
loop SD2
mov eax, lengthof targetY
dec eax
mov temp, eax
fild temp
fdiv
fstp st(1)
fsqrt
fst StandardY
mov edx, OFFSET SDY
call WriteString
call WriteFloat
call crlf

; calculating the value of r
mov ecx, lengthof CurrScoreX
mov esi, 0
mov temp, 0
finit
fldz
fldz
fldz
fld medofY
fld medOfX
corelation:
	fild targetY[esi]
	fsub st, st(2)
	fild CurrScoreX[esi]
	fsub st, st(2)
	fld st(0)
	fmul st, st(1)
	fadd st(6), st
	fxch st(2)
	fst st(2)
	fmul st, st(2)
	faddp st(7), st
	fmul
	faddp st(5), st
	add esi, TYPE DWORD
loop corelation
fxch st(4)
fmul st, st(3)
fsqrt
fxch st(2)
fdiv st, st(2)
fst r
mov edx, OFFSET co_relation
call WriteString
call WriteFloat 
call crlf

; calculating the value of slope (b value)
mov edx, OFFSET slopeVal
call WriteString
CalculateB:
	finit
	fld r
	fld StandardY
	fld StandardX
	fdiv st, st(1)
	fmul
	call WriteFloat
	fst b
	call crlf

; calculating the value of intercept (a value)
mov edx, OFFSET interVal
call WriteString
CalculateA:
	finit
	fld medofY
	fld b
	fld medOfX
	fmul
	fsub
	call WriteFloat
	fst a
	call crlf

; displaying the equation
call crlf
call crlf
finit
mov edx, OFFSET equation
call WriteString
call crlf
mov edx, OFFSET y
call WriteString
fld a 
call WriteFloat
mov edx, OFFSET addition
call WriteString
fld b
call WriteFloat
mov edx, OFFSET x
call WriteString
call crlf
call crlf


; printing all the result (is ko delete nahi krna)
;mov edx, OFFSET SummationX
;call WriteString
;mov eax, SumX
;call WriteDec
;call crlf
;
;mov edx, OFFSET SummationY
;call WriteString
;mov eax, SumY
;call WriteDec
;call crlf
;
;finit
;
;mov edx, OFFSET medianX
;call WriteString
;fst medOfX
;call WriteFloat
;call Crlf
;
;mov edx, OFFSET medianY
;call WriteString
;fst medOfY
;call WriteFloat
;call Crlf
;
;mov edx, OFFSET SDX
;call WriteString
;fst StandardX
;call WriteFloat
;call crlf
;
;mov edx, OFFSET SDY
;call WriteString
;fst StandardY
;call WriteFloat
;call crlf
;
;mov edx, OFFSET co_relation
;call WriteString
;fst r
;call WriteFloat
;call crlf

exit
main ENDP

sumarr PROC
	push ebp
	mov ebp, esp
	mov edx, DWORD PTR [ebp+8]		; type
	mov ecx, DWORD PTR [ebp+12]		; length
	mov esi, DWORD PTR [ebp+16]		; offset target
	mov edi, DWORD PTR [ebp+20]		; sum var offset
	mov eax, 0
	L2:
		ADD eax, [esi]
		add esi, edx
	loop L2
	mov [edi], eax
	mov esp, ebp
	pop ebp
	ret 16
sumarr ENDP

END main
