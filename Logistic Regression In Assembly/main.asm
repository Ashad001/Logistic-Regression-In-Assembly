INCLUDE irvine32.inc
.data
targetY    DWORD 186,127,158,141,168,185,185,184,117,179,144,179,133,91,150,157,159,112,132,169,209,166,199,158,221
currScoreX DWORD 90,115,112,129,120,130,103,133,109,140,100,149,111,75,140,89,100,97,110,128,135,155,180,142,149
sep		   BYTE " | ", 0

.code
main PROC

MOV esi, OFFSET targetY
MOV edi, OFFSET currScoreX
MOV ecx, LENGTHOF targetY
L1:
	MOV eax, [esi]
	call WriteInt
	MOV edx, OFFSET sep
	call WriteString
	MOV eax, [edi]
	call WriteInt
	ADD esi, 4
	ADD edi, 4
	call crlf
LOOP L1


exit
main ENDP
END main