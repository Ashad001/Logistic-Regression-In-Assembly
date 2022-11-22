INCLUDE irvine32.inc

.data 
targetY     DWORD 186,127,158,141,168,185,185,184,117,179,144,179,133,91,150,157,159,112,132,169,209,166,199,158,221
currScoreX  DWORD 90,115,112,129,120,130,103,133,109,140,100,149,111,75,140,89,100,97,110,128,135,155,180,142,149
medianX     Byte "The mean of CurrentScoreX is: ",0
medianY	    Byte "The mean of targetY is: ",0
y_intercept Byte "The y-intercept is equal to: ",0
slope	    Byte "The slope is equal to: ",0
co_relation Byte "The co-relation constant is equal to: ",0
SDX		    Byte "The standard deviation of x is equal to: ",0
SDY 	    Byte "The standard deviation of y is equal to: ",0
sep		    Byte " | ", 0
medOfX      DWORD ?
medOfY      DWORD ?
StandardX   DWORD ?
StandardY	DWORD ?


.code
main PROC

; Printing both the x and y co-ordinate arrays
MOV esi, OFFSET targetY
MOV edi, OFFSET currScoreX
MOV ecx, LENGTHOF targetY
L1:
	MOV eax, [esi]
	call WriteInt
	MOV edx, OFFSET sep
	call WriteString
	MOV eax, [edi]
	call WriteDec
	ADD esi, 4
	ADD edi, 4
	call crlf
LOOP L1
call crlf
call crlf

; calling median function to calculate the median of x
push OFFSET medOfX
push OFFSET currScoreX
push lengthof currScoreX
push TYPE targetY
call median
mov edx, OFFSET medianX
call WriteString
mov eax, medOfX
call WriteDec
call crlf
call crlf

; calling median function to calculate the median of y
push OFFSET medOfY
push OFFSET targetY
push lengthof targetY
push TYPE targetY
call median
mov edx, OFFSET medianY
call WriteString
mov eax, medOfY
call WriteDec
call crlf
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



median PROC
	push ebp
	mov ebp, esp
	mov edx, DWORD PTR [ebp+8]		; type
	mov ecx, DWORD PTR [ebp+12]		; length
	mov esi, DWORD PTR [ebp+16]		; offset target
	mov edi, DWORD PTR [ebp+20]		; offset median var
	mov eax, 0
	mov ebx, ecx
	L2:
		ADD eax, [esi]
		add esi, edx
	loop L2
	mov edx, 0
	mov esi, 0
	div ebx
	mov [edi], eax
	mov esp, ebp
	pop ebp
	ret 16
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