.MODEL SMALL
.STACK 100h
.DATA
	
	mainDiagMsg DB "the main diagonal: ",'$'
	secDiagMsg DB "the secondary diagonal: ",'$'
	arr DD 23,12,36,99,56,43,5,78,90,120,32,69,100,210,189,43,92,54,251,12,15,1,98,123,234
	Msg DB "               ",13,10,'$'
.CODE
.386
printDdNum PROC
	PUSH BP
	MOV BP,SP
	PUSH EAX
	PUSH EBX
	PUSH DI
	PUSH EDX
	PUSH CX
	MOV EAX,[BP+4]
	MOV EBX,10
	MOV DI,11
	XOR CX,CX ; counter for ','
	loop1:
		XOR EDX,EDX
		DIV EBX
		ADD DL,'0'
		DEC DI
		CMP CX,3
		JNE skip
		MOV Msg[DI],','			; IF CX==3 PUT COMMA
		XOR CX,CX
		DEC DI
		skip:
		INC CX
		MOV Msg[DI],DL
		CMP EAX,0
		JA loop1
	MOV DX, OFFSET Msg
	ADD DX,DI
	MOV AH,9
	INT 21h
	POP CX
	POP EDX
	POP DI
	POP EBX
	POP EAX
	POP BP
	RET 4
printDdNum ENDP
arrXpatern PROC
	PUSH BP
	MOV BP,SP
	PUSH SI
	PUSH EAX
	PUSH EBX
	PUSH CX
	PUSH DX
	MOV SI,[BP+4] ; arr[0]
	MOV EBX ,[SI] ; SUM
	MOV CX,4 ; CX = N-1
	mainDiag:
	ADD SI,24 ; 24 is the next index in the mat. == (i*colums+j)*element size
	MOV EAX,[SI] ; EAX has the next vlaue to sum/mul
	MUL EBX ; EBX has the prev vlaue and mul him with the next value and store rhe result in EBX(sum) for mul the result with the next value
	MOV EBX,EAX
	LOOP mainDiag
	PUSH EAX ; PUSH EAX before the print so that the printMsg dont run over the value
	MOV DX, OFFSET mainDiagMsg ; print - the main diagonal: -> result
	MOV AH,9
	INT 21h
	CALL printDdNum
	SUB SI,16 ; SUB 16 from the place that si stoped to get to the value in secondDiagnol
	MOV EBX,[SI] ; SUM / MOV TO EBX the first number to mul
	MOV CX,4 ; CX=n-1
	secondDiag:
	SUB SI,16 ; sub 16 to get to the next index 
	MOV EAX,[SI] ; eax has the next number to mul
	MUL EBX
	MOV EBX,EAX
	LOOP secondDiag
	PUSH EAX ; PUSH EAX before the print so that the printMsg dont run over the value
	MOV DX, OFFSET secDiagMsg ; print - the secondary diagonal: -> result
	MOV AH,9
	INT 21h
	CALL printDdNum
	POP DX
	POP CX
	POP EBX
	POP EAX
	POP SI
	POP BP
	endProc:
RET 2
arrXpatern ENDP

start:
	MOV AX,@DATA
	MOV DS,AX
	LEA BX ,arr
	PUSH BX
	call arrXpatern
	MOV AH,4Ch
	INT 21h
END start