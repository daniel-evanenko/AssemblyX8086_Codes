.MODEL SMALL
.STACK 100h
.DATA
	arrayBfs DB 13,10,"array before sort:	",'$'
	arrayAfs DB 13,10,"array after sort:	",'$'
	myArr1 DD 9,6,4,1,14
	Msg DB "            ",'$'
	N DW 5
.CODE
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
printArr PROC ; PROC gets arr adress and size (*arr , size)
	PUSH BP
	MOV BP,SP
	PUSH EAX
	PUSH CX
	PUSH SI
	PUSH DX
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

sortArr PROC
    PUSH BP
    MOV BP,SP
    PUSH EAX
    PUSH EBX
    PUSH CX
    PUSH DX
    PUSH SI
    MOV CX,[BP+4]  ; cx = n
    DEC CX ; CX = N-1
    outerLoop:
        MOV SI,[BP+6] ;SI = arr[0]
        MOV DX,CX ; DX=CX
        innerLoop:
            MOV EAX,[SI]  ; compre between the number arr[i] and arr[i+1]
            MOV EBX,[SI+4]
			CMP EAX,EBX
            JB noSwap
            MOV [SI],EBX  ; swap the numbers so the smaller number be in arr[i]	
            MOV [SI+4],EAX ;
            noSwap:
				ADD SI,4 ; if the smaller number is the first one ( arr[i]) so dont swap
                DEC DX
        JNZ innerLoop ; jump to innerLoop if zero flag is not set
    LOOP outerLoop
    POP SI
    POP DX
    POP CX
    POP EBX
    POP EAX
    POP BP
    RET 4
sortArr ENDP

start:
MOV AX, @DATA
MOV DS, AX
    LEA BX,myArr1
    PUSH BX
    PUSH N
	MOV AH,9H 
    MOV DX,offset arrayBfs ; print -> array before sort 
    INT 21H 
	CALL printArr
    PUSH BX
    PUSH N
    call sortArr
	MOV AH,9H 
    MOV DX,offset arrayAfs ; print -> array after sort 
    INT 21H 
	PUSH BX
    PUSH N
	CALL printArr
MOV AX, 4c00h
INT 21h
END start