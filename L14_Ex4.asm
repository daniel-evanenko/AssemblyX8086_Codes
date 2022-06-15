.MODEL SMALL
.STACK 100h
.DATA
	Msg DB "       ",'$' 
.CODE
printDwNum PROC
	PUSH BP
	MOV BP,SP
	PUSH AX
	PUSH BX
	PUSH DI
	PUSH DX
	MOV AX,[BP+4] EAX = 7654321
	MOV BX,10
	MOV DI,6 
	loop1:
		XOR DX,DX
		DIV BX
		ADD DL,'0'
		DEC DI
		MOV Msg[DI],DL
		CMP AX,0
		JA loop1
	MOV DX, OFFSET Msg
	ADD DX,DI
	MOV AH,9
	INT 21h
	POP DX
	POP DI
	POP BX
	POP AX
	POP BP
	RET 2
printDwNum ENDP
fibo PROC
	PUSH BP 
	MOV BP,SP
	PUSH CX
	PUSH BX
	MOV AX,[BP+4] ; AX - N
	CMP AX,1 ;N<1 - if its below ot equal end program. 
	JBE endf
	MOV CX,AX ; else ->  CX = N-1.
	DEC CX  
	PUSH CX
	CALL fibo
	MOV BX,AX ;BX = fibo(n-1)
	DEC CX ; CX=n-2
	PUSH CX
	CALL fibo
	ADD AX,BX
	endf:
	POP BX
	POP CX
	POP BP
	RET 2
fibo ENDP


printFibo PROC
	PUSH BP
	MOV BP,SP
	PUSH BX
	PUSH CX
	MOV CX,[BP+4] ;CX = N
	CMP CX,1
	JB endF1
	XOR BX,BX ; AX=0
	INC BX
	PUSH BX
	CALL fibo
	doWhile:
		PUSH AX
		CALL printDwNum
		INC BX
		PUSH BX
		CALL fibo
	CMP AX,CX
	JBE doWhile
	endF1:
	POP CX
	POP BX
	POP BP
	RET 2
printFibo ENDP
start:
	MOV AX,@DATA
	MOV DS,AX
	PUSH 100
	CALL printFibo
	MOV AH,4Ch
	INT 21h
END start