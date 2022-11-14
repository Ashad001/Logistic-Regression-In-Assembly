INCLUDE irvine32.inc
.data
targetY    DWORD 186,127,158,141,168,185,185,184,117,179,144,179,133,91,150,157,159,112,132,169,209,166,199,158,221
currScoreX DWORD 90,115,112,129,120,130,103,133,109,140,100,149,111,75,140,89,100,97,110,128,135,155,180,142,149
sep		   BYTE " | ", 0
medOfX    DWORD ?
medOfY     DWORD ?
.code
main PROC

MOV esi, OFFSET targetY
MOV edi, OFFSET currScoreX
MOV ecx, LENGTHOF targetY
;L1:
;	MOV eax, [esi]
;	call WriteInt
;	MOV edx, OFFSET sep
;	call WriteString
;	MOV eax, [edi]
;	call WriteInt
;	ADD esi, 4
;	ADD edi, 4
;	call crlf
;LOOP L1

MOV medOfY , 0
L1:
	MOV ebx, [esi]
	ADD medOfY, ebx
	ADD esi, 4
LOOP L1
MOV eax, medOfY
MOV edx, 0
MOV ebx, 0
MOV bx, LENGTHOF targetY
DIV bx
MOV medOfY, eax
call WriteInt
call Crlf

MOV ecx, LENGTHOF currScoreX
MOV medOfX, 0
L2:
	MOV ebx, [edi]
	ADD medOfX, ebx
	ADD edi, 4
LOOP L2
MOV eax, medOfX
MOV edx, 0
MOV ebx, 0
MOV bx, LENGTHOF currScoreX
DIV bx
MOV medOfX, eax
call WriteInt




exit
main ENDP
END main