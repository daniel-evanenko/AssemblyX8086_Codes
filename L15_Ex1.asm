.MODEL SMALL
.STACK 100h
.DATA
	Msg DB "       ",'$' 
.CODE
.368
printDwNum PROC
	PUSH BP
	MOV BP,SP
	PUSH AX
	PUSH BX
	PUSH DI
	PUSH DX
	MOV AX,[BP+4]
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
addseries PROC
	PUSH BP
	MOV BP,SP
	MOV ECX,[BP+4]
	CMP CL,1
	JBE endF
	XOR EAX,EAX
	addNum:
	ADD EAX,ECX
	LOOP addNum
	endF:
	POP BP
	POP ECX
	RET 2
	addseries ENDP

start:
	MOV AX,@DATA
	MOV DS,AX
	PUSH 100
	CALL addseries
	PUSH EAX
	CMP EAX,15
	JNE err
	PUSH 1
	CALL printDwNum
	jmp end2:
	err:
	push 0
	CALL printDwNum
	end2:
	MOV AH,4Ch
	INT 21h
END start