INCLUDE irvine32.inc
.data


.code
main PROC
mov eax, 10
mov ebx, 1000
call Dumpregs

exit
main ENDP
END main