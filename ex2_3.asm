.MODEL SMALL
.STACK 100h
.DATA 
inputMsg DB 13,10,"please enter numbers",13,10,"that are not bigger then '4,294,967,295'",13,10,"to save and input each number press '#'.",10,13,'$'
enterNum DB 13,10,"please enter a number",13,10,'$'
Msg DB "            ",'$'
resultMsg DB 13,10,"the array: ",'$'
myArr DD 10 dup(?)
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
	PUSH CX
	PUSH EBX
	PUSH EDI ; EDI = 10, i didnt want to make a varble in .data just to mul the number in one function and i dont have any registers that are free to use
	MOV EDI,10
    MOV AH,9H ;
    MOV DX,offset enterNum;; user input msg  
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
	MOV EAX,EDX ; EAX = SUM (prev digits that were added)
	MUL EDI ; add a zero in number for the next digit : number<<
	ADD EAX,EBX ;adds prev digit to new digit
	MOV EDX,EAX ; return the result to EDX(SUM) and loop to take input for another digit.
	LOOP addDigit
	endAddDigit:
	MOV EAX,EDX ; retuns the result in EAX
	POP EDI
	POP EBX
	POP CX
	POP EDX
	POP BP
RET 
numInput ENDP

arrNumInput PROC
	PUSH BP
	MOV BP,SP
	PUSH EAX
	PUSH CX
	PUSH SI
	PUSH BX
	XOR BX,BX
	MOV CX,[BP+4] ; arr size
	MOV SI,[BP+6] ; arr addres -> arr[0]
	input:
	XOR EAX,EAX
	CALL numInput ; get a number from the user -> EAX has the user number
	MOV [SI+BX],EAX ; arr[si] == user input/num
	ADD BX,4 ;adds 4 to si to get to the next index in the arr
	LOOP input ; loop arrsize/cx times.
	POP BX
	POP SI
	POP CX
	POP EAX
	POP BP
RET 4
arrNumInput ENDP

printArr PROC ; PROC gets arr adress and size (*arr , size)
	PUSH BP
	MOV BP,SP
	PUSH EAX
	PUSH CX
	PUSH SI
	PUSH DX
	MOV AH,9H ;
    MOV DX,offset resultMsg ; print a msg for the user 
    INT 21H
	MOV CX,[BP+4] ; arr size
	MOV SI,[BP+6] ;addres of arr
	printLoop:
	XOR EAX,EAX
	MOV EAX,[SI] ; EAX = value of arr[si]
	PUSH EAX 
	CALL printDdNum ; PUSH THE VALUE AND PRINT.
	ADD SI,4 ; add 4 to get to the next index in the array.
	LOOP printLoop
	POP DX ; using him for the print in the begining of the PROC
	POP SI
	POP CX
	POP EAX
	POP BP
RET 4
printArr ENDP

start:
	MOV AX,@DATA
	MOV DS,AX
	MOV AH,9H ;
    MOV DX,offset inputMsg; user input msg  
    INT 21H
	LEA BX,myArr
	PUSH BX ; arr addres
	PUSH 10 ; arr size
	CALL arrNumInput
	PUSH BX
	PUSH 10
	CALL printArr ; i added the printArr proc to check/show if the program working like it should.
	MOV AH,4Ch
	INT 21h
END start