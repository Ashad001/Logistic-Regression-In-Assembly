INCLUDE Irvine32.inc

.data
CenterX BYTE ?											; Center With Respect To x coordinate
CenterY BYTE ?											; Center With Respect To y coordinate
win			DWORD 0,1,1,1,0,0,0,1,1,0,1,1,1,1,1,0,1,1,1,0,0,1,1,1,0
targetY     DWORD 186,127,158,141,168,185,185,184,117,179,144,179,133,121,150,157,159,112,132,169,209,166,199,158,221
currScoreX  DWORD 90,115,112,129,120,130,103,133,109,140,100,149,111,110,140,89,100,97,110,128,135,155,180,142,149
predictedY	REAL8 LENGTHOF targetY  DUP (?)

LoadingBar BYTE "***",0
; TEXTS
; Loading
Text01		BYTE "Welcome To Cricket Insights",0

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
xLet		BYTE " . x",0
yLet		BYTE "y = ", 0
r			REAL8 ?
a			REAL8 ?
b			REAL8 ?
SumX		DWORD ?
SumY		DWORD ?
MeanSubSumX	Real8 ?
MeanSubSumY	Real8 ?
sep		    Byte " | ", 0
medOfX      REAL8 ?
medOfY      REAL8 ?
StandardX   REAL8 ?
StandardY	REAL8 ?
store		SDWORD ?
temporary1	Real8 0.00
temporary2  DWORD 0
temporary3	Real8 0.00



; UI
msg1		BYTE "Tell us the current score at 14th Over, and we will tell you what target are you expecting", 0
ask1		BYTE "Enter current score: ", 0
out1		BYTE "Expected Target Is: ", 0
caption		BYTE "we ain't over! ", 0
question	BYTE "are you in a chase? ", 0
ask4		BYTE "Enter actual target:  ", 0
output1		BYTE "Target is chasable", 0
output2		BYTE "Target is unchasable", 0


; TEMP (TO be Erased from Memory Permanently)
valB BYTE "The value of B is: ", 0
valA BYTE "The value of Ais: ", 0

inputCurrScore DWORD ?
actualTarget DWORD ?


y			DWORD ?
temp		DWORD ?
error		REAL8 LENGTHOF targetY DUP (?)
err			REAL8 0.0
b0			REAL8 0.0
b1			REAL8 0.0
b2			REAL8 0.0
alpha		REAL8 0.00004929
e			REAL8 2.71828
temp2		REAL8 0.0
p			REAL8 0.0
minus		SDWORD -1
tempP		SDWORD ?
pred		REAL8 0.0
midVal		REAL8 0.0
toMul		REAL8 3.5
compar		DWORD 69
hundred		DWORD 100




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
MOV store, ecx
MOV esi, 0
fldz
MED1:
	fild currScoreX[esi]
	fadd 
	ADD esi, TYPE DWORD
LOOP MED1
fidiv store
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
MOV store, ecx
MOV esi, 0
fldz
MED2:
	fild targetY[esi]
	fadd 
	ADD esi, TYPE DWORD
LOOP MED2
fidiv store
fstp medOfY
fld medOfY
mov edx, OFFSET medianY
call WriteString
call WriteFloat
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

; calculating the standard deviation of x
mov ecx, lengthof CurrScoreX
mov esi, 0
mov edi, 0
finit
fldz
fst temporary1
finit
SD1:
	finit
	fld Xmeansub[esi * TYPE Xmeansub]
	fld Xmeansub[esi * TYPE Xmeansub]
	fmul st, st(1)
	fld temporary1
	fadd st, st(1)
	fst temporary1
	inc esi
loop SD1
fst MeanSubSumX
mov temporary2, lengthof Xmeansub
dec temporary2
finit
fild temporary2
fld temporary1
fdiv st, st(1)
fsqrt
fst StandardX
mov edx, OFFSET SDX
call WriteString
call WriteFloat
call crlf


; calculating the standard deviation of y
mov ecx, lengthof targetY
mov esi, 0
mov edi, 0
finit
fldz
fst temporary1
finit
SD2:
	finit
	fld Ymeansub[esi * TYPE ymeansub]
	fld Ymeansub[esi * TYPE ymeansub]
	fmul st, st(1)
	fld temporary1
	fadd st, st(1)
	fst temporary1
	inc esi
loop SD2
fst MeanSubSumY
mov temporary2, lengthof Ymeansub
dec temporary2
finit
fild temporary2
fld temporary1
fdiv st, st(1)
fsqrt
fst StandardY
mov edx, OFFSET SDY
call WriteString
call WriteFloat
call crlf

; calculating the value of r
mov ecx, lengthof CurrScoreX
mov esi, 0
finit
fldz
fst temporary1
fst temporary1
corelation:
	finit
	fld Ymeansub[esi * TYPE Ymeansub]
	fld Xmeansub[esi * TYPE Xmeansub]
	fmul st, st(1)
	fld temporary1
	fadd st, st(1)
	fst temporary1
	inc esi
loop corelation
finit
fld MeanSubSumX
fld MeanSubSumY
fmul st, st(1)
fsqrt
fst temporary3
finit
fld temporary3
fld temporary1
fdiv st, st(1)
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
	fld StandardX
	fld StandardY
	fdiv st, st(1)
	fld r
	fmul st, st(1)
	fst b
	call WriteFloat
	call crlf

; calculating the value of intercept (a value)
mov edx, OFFSET interVal
call WriteString
CalculateA:
	finit
	fld b
	fld medOfX
	fmul st, st(1)
	fld medOfY
	fsub st, st(1)
	fst a
	call WriteFloat
	call crlf

; displaying the equation
call crlf
call crlf
mov edx, OFFSET equation
call WriteString
call crlf
mov edx, OFFSET yLet
call WriteString
finit
fld a 
call WriteFloat
mov edx, OFFSET addition
call WriteString
finit
fld b
call WriteFloat
mov edx, OFFSET xLet
call WriteString
call crlf
call crlf

MOV centerX, 60d
MOV centerY, 14d
call readint
call clrscr
call Loading

call ClrScr
fld StandardX
fdiv StandardY
fmul r
fstp b

fld b
fmul medOfX
fsubr medOfY
fstp a
call crlf

MOV dh, CenterY
MOV dl, 14
sub dh, 5
call GotoXY
MOV edx, OFFSET msg1
call WriteString
MOV dl, 17
MOV dh, 11
call GoToXY
MOV edx, OFFSET ask1
call WriteString 
call ReadDec
MOV inputCurrScore, eax

MOV dl, 17
MOV dh, 13
call GoToXY
fld b
fimul inputCurrScore
fadd a
fistp y

MOV edx, OFFSET out1
call WriteString
MOV eax, y
call WriteDec


MOV ebx, OFFSET caption
MOV edx, OFFSET question
call MsgBoxAsk

.IF(eax==7)
exit
.ENDIF


MOV ecx, LENGTHOF targetY
MOV esi, 0
MOV edi, OFFSET currScoreX
LR1:
	MOV eax, [edi]
	MOV temp, eax
	fld b
	fimul temp
	fadd a
	fstp predictedY[esi]
	add esi, TYPE predictedY
	add edi, 4
LOOP LR1

MOV ecx, LENGTHOF targetY
MOV edi, OFFSET targetY
MOV ebx, 0
MOV esi, 0
LR2:
	fld predictedY[esi]
	fmul b2
	fstp temp2

	MOV eax, [edi]
	MOV temp, eax
	fld b1
	fimul temp
	fadd temp2
	fadd b0

	fist tempP
	MOV edx, tempP
	cmp edx, 0
	JG Ls
	MOV eax, -1
	MUL edx
	MOV tempP, eax

	Ls:
	fchs
	fstp p

	
	
	MOV edx, ecx
	MOV ecx, tempP
	fld e
	fstp temp2
	cmp ecx, 0
	JLE qe
	fld1
	LR3:
		fdiv temp2
	LOOP LR3
	fstp temp2
	
	fld temp2
	fstp pred
	qe:

	fld1
	fadd pred
	fstp pred
	fld1
	fdiv pred
	fstp pred

	MOV eax, win[ebx]
	fld pred
	MOV temp, eax
	fisubr temp
	fstp err


	fld alpha 
	fmul err 
	fmul pred
	fstp temp2


	fld1 
	fsub pred
	fstp midVal

	fld midVal
	fmul temp2
	fstp midVal

	; B0 calculation
	fld midVal
	fsubr b0
	fstp b0

	; B1 calculation
	MOV eax, [edi]
	MOV temp, eax
	fld midVal
	fimul temp
	fadd b1
	fstp b1

	; B2 calculation
	fld predictedY[esi]
	fmul midVal
	fadd b2
	fstp b2

	


	MOV ecx, edx
	SUB ecx, 1
	ADD esi, TYPE predictedY
	ADD ebx, 4
	ADD edi, 4
	cmp ecx, 0
	JE rett
	
JMP LR2

rett:


MOV dl, 17
MOV dh, 15

call GoToXy
xor eax, eax
MOV edx, OFFSET ask4
call WriteString
call ReadDec
MOV actualTarget , eax

fld b2
fimul actualTarget
fadd b0
fstp temp2

fld b1
fimul y
fadd temp2

fstp pred

MOV dl, 30
MOV dh, 18
call GoToXy


fld pred
fmul toMul
fstp temp2


fld temp2
fimul hundred 
fistp temp




MOV eax, temp
cmp eax, compar
JB GRE
MOV edx, OFFSET output2
call WriteString
JMP re

GRE:
MOV edx, OFFSET output1
call WriteString

re:
call crlf
call writeFloat
call Crlf
fstp pred



exit
main ENDP


Loading PROC

	mov ecx, 100
	.WHILE(ecx >= 0)
		mov dh, CenterY
		mov dl, CenterX
		sub dh, 2
		.IF (ecx == 0)
			sub dl , 15
			call GotoXY
			mov edx, OFFSET LoadingBar
			call WriteString
			call WriteString
		.ELSEIF (ecx == 100)
			sub dl , 12
			call GotoXY
			mov edx, OFFSET LoadingBar
			call WriteString
		.ELSEIF (ecx == 90)
			sub dl , 9
			call GotoXY
			mov edx, OFFSET LoadingBar
			call WriteString
		.ELSEIF (ecx == 80)
			sub dl , 6
			call GotoXY
			mov edx, OFFSET LoadingBar
			call WriteString
		.ELSEIF (ecx == 70)
			sub dl , 3
			call GotoXY
			mov edx, OFFSET LoadingBar
			call WriteString
		.ELSEIF (ecx == 60)
			call GotoXY
			mov edx, OFFSET LoadingBar
			call WriteString
		.ELSEIF (ecx == 50)
			add dl , 3
			call GotoXY
			mov edx, OFFSET LoadingBar
			call WriteString
		.ELSEIF (ecx == 40)
			add dl , 6
			call GotoXY
			mov edx, OFFSET LoadingBar
			call WriteString
		.ELSEIF (ecx == 30)
			add dl , 9
			call GotoXY
			mov edx, OFFSET LoadingBar
			call WriteString
		.ELSEIF (ecx == 10)
			add dl , 12
			call GotoXY
			mov edx, OFFSET LoadingBar
			call WriteString
		.ELSEIF (ecx == 0)
			add dl , 15
			call GotoXY
			mov edx, OFFSET LoadingBar
			call WriteString
		.ENDIF
		mov dh, CenterY
		mov dl, CenterX
		call GotoXY
		mov eax, ecx
		call WriteDec
		mov eax, '%'
		call WriteChar
	
		.IF(ecx >= 20)
			mov eax, LENGTHOF Text01
			sub eax, 1
			SHR eax, 1
			mov dh, CenterY
			mov dl, CenterX
			add dh, 1
			sub dl, al
			call GotoXY
			mov eax, 80
			mov edx, OFFSET Text01 
		.ELSEIF(ecx >= 50)
			sub eax, 1
			SHR eax, 1
			mov dh, CenterY
			mov dl, CenterX
			add dh, 1
			sub dl, al
			call GotoXY
			mov eax, 9
		.ELSEIF(ecx >=70)
			sub eax, 1
			SHR eax, 1
			mov dh, CenterY
			mov dl, CenterX
			add dh, 1
			sub dl, al
			call GotoXY
			mov eax, 18
		.ELSEIF(ecx >=93)
			sub eax, 1
			SHR eax, 1
			mov dh, CenterY
			mov dl, CenterX
			add dh, 1
			sub dl, al
			call GotoXY
			mov eax, 15
		.ELSE
			sub eax, 1
			SHR eax, 1
			mov dh, CenterY
			mov dl, CenterX
			add dh, 1
			sub dl, al
			call GotoXY
			mov eax, 50
		.ENDIF
		call WriteString
		sub ecx, 1
		call Delay
		.IF(ecx==0)
			JMP rett
		.ENDIF
		;call Clrscr
	.ENDW
	rett:
	ret
Loading ENDP

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


end main

