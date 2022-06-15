.MODEL SMALL
.STACK 100h
.DATA
numPrint DB 13,10,"the number you entered: ",'$'
inputMsg DB 13,10,"please enter a number that is not bigger then '4,294,967,295': ",'$'
Msg DB "            ",'$'
ten DD 10
.code
.386
printDdNum PROC
	PUSH BP
	MOV BP,SP
	PUSH EAX
	PUSH EBX
	PUSH DI
	PUSH EDX
	MOV EAX,[BP+4]
	MOV EBX,10
	MOV DI,11
	loop1:
		XOR EDX,EDX
		DIV EBX
		ADD DL,'0'
		DEC DI
		MOV Msg[DI],DL
		CMP EAX,0
		JA loop1
	MOV DX, OFFSET Msg
	ADD DX,DI
	MOV AH,9
	INT 21h
	POP EDX
	POP DI
	POP EBX
	POP EAX
	POP BP
	RET 4
printDdNum ENDP
numInput PROC
	PUSH BP
	MOV BP,SP
	PUSH EDX
	PUSH ECX
	PUSH EBX
    MOV AH,9H ;
    MOV DX,offset inputMsg;; user input msg  
    INT 21H
	XOR EDX,EDX; EDX = SUM
	MOV CX,10 ; loop 10 times for up to 10 digit number. MAX NUM: '4,294,967,295'
	addDigit:
	XOR EAX,EAX
	MOV AH,1 ;
	INT 21H  ; takes input from user and checks if its equal to '#' 
	CMP AL,'#' ; not equal? -> sub 48 from the asci number of the input to make it a digit.
	JE endAddDigit
	SUB AL,48
	XOR AH,AH
	MOV EBX,EAX ; stores the result digit in EBX
	MOV EAX,EDX ; EAX = SUM
	MUL ten ; add a zero in num for the next digit
	ADD EAX,EBX ;adds prev digit to new digit
	MOV EDX,EAX ; return the result to EDX(SUM) and jumps to take input for another digit.
	LOOP addDigit
	endAddDigit:
	MOV EAX,EDX ; retuns the result in EAX
	POP EBX
	POP ECX
	POP EDX
	POP BP
RET 
numInput ENDP

start:
	MOV AX,@DATA
	MOV DS,AX
	CALL numInput
	PUSH EAX ; PUSH EAX first to not run over the value in eax with print.
	MOV AH,9H 
    MOV DX,offset numPrint; user input msg  
    INT 21H
	CALL printDdNum
	
	MOV AH,4Ch
	INT 21h
END start