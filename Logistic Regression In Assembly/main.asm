INCLUDE irvine32.inc
INCLUDE macros.inc

.data 
targetY     DWORD 186,127,158,141,168,185,185,184,117,179,144,179,133,121,150,157,159,112,132,169,209,166,199,158,221
currScoreX  DWORD 90,115,112,129,120,130,103,133,109,140,100,149,111,110,140,89,100,97,110,128,135,155,180,142,149
medianX     Byte "The mean of CurrentScoreX is: ",0
medianY	    Byte "The mean of targetY is: ",0
y_intercept Byte "The y-intercept is equal to: ",0
slope	    Byte "The slope is equal to: ",0
co_relation Byte "The co-relation constant is equal to: ",0
SDX		    Byte "The standard deviation of x is equal to: ",0
SDY 	    Byte "The standard deviation of y is equal to: ",0
SummationX  Byte "The sum of current score is equal to: ",0
SummationY  Byte "The sum of target is equal to: ",0
SumX		DWORD ?
SumY		DWORD ?
sep		    Byte " | ", 0
medOfX      REAL8 ?
medOfY      REAL8 ?
StandardX   DWORD ?
StandardY	DWORD ?
temp		DWORD ?


.code
main PROC

; Printing both the x and y co-ordinate arrays
	MOV esi, OFFSET targetY
	MOV edi, OFFSET currScoreX
	MOV ecx, LENGTHOF targetY
	MOV edx, OFFSET sep
	L1:
		MOV eax, [esi]
		call WriteInt
		call WriteString
		MOV eax, [edi]
		call WriteDec
		ADD esi, 4
		ADD edi, 4
		call crlf
	LOOP L1
	call crlf
	call crlf

; calling sum and median function to calculate the average of x
; calling sum
	push OFFSET SumX
	push OFFSET currScoreX
	push lengthof currScoreX
	push TYPE currScoreX
	call sumarr
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
	call WriteFloat
	call Crlf
	;push OFFSET medOfX
	;push Offset SumX
	;push lengthof currScoreX
	;call median
	;mov edx, OFFSET SummationX
	;call WriteString
	;mov eax, SumX
	;call WriteDec
	;call crlf
	;call crlf
	;mov edx, OFFSET medianX
	;call WriteString
	;mov eax, medOfX
	;call WriteDec
	;call crlf
	;call crlf


; calling sum and median function to calculate the average of y
; calling sum
	push OFFSET SumY
	push OFFSET targetY
	push lengthof targetY
	push TYPE targetY
	call sumarr
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
	call WriteFloat
	call Crlf

	;push OFFSET medOfY
	;push Offset SumY
	;push lengthof targetY
	;call median
	;mov edx, OFFSET SummationY
	;call WriteString
	;mov eax, SumY
	;call WriteDec
	;call crlf
	;call crlf
	;mov edx, OFFSET medianY
	;call WriteString
	;mov eax, medOfY
	;call WriteDec
	;call crlf
call crlf

;; calling function to calculate the standard deviation of x
;push OFFSET medOfX
;push OFFSET StandardX
;push OFFSET CurrentScoreX
;push lengthof CurrentScoreX
;push TYPE CurrentScoreX
;call StandardDeviation
;mov edx, OFFSET SDX
;call WriteString
;mov eax, StandardX
;call WriteDec
;call crlf
;call crlf
;
;; calling function to calculate the standard deviation of y
;push OFFSET medOfY
;push OFFSET StandardY
;push OFFSET targetY
;push lengthof targetY
;push TYPE targetY
;call StandardDeviation
;mov edx, OFFSET SDY
;call WriteString
;mov eax, StandardY
;call WriteDec
;call crlf
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

median PROC
	push ebp
	mov ebp, esp
	mov ebx, DWORD PTR [ebp+8]		; length
	mov esi, DWORD PTR [ebp+12]		; offset sum var
	mov edi, DWORD PTR [ebp+16]		; offset median var
	mov eax, 0
	mov eax, [esi]
	div ebx
	mov [edi], eax
	mov esp, ebp
	pop ebp
	ret 12
median ENDP

;StandardDeviation PROC
;	push ebp
;	mov ebp, esp
;	mov edx, DWORD PTR [ebp+8]		; type
;	mov ecx, DWORD PTR [ebp+12]		; length
;	mov esi, DWORD PTR [ebp+16]		; offset target
;	mov edi, DWORD PTR [ebp+20]		; offset standard deviation var
;	mov eax, DWORD PTR [ebp+24]		; offset of mean value
;	mov DWORD PTR [ebp-4], eax
;	mov eax, 0
;	mov ebx, ecx
;	dec ebx
;	l1:
;		mov DWORD PTR [ebp-8], [esi]
;		sub [esi], [ebp-4]
;		mov eax, [esi]
;		mul [esi]
;		add DWORD PTR [ebp-12], eax
;		mov [esi], DWORD PTR [ebp-8]
;	loop l1
;	mov eax, [ebp-12]
;	div ebx
;	; applying square root
;	mov [edi], eax
;	mov esp, ebp
;	ret 20
;StandardDeciation ENDP

END main