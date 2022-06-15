.MODEL SMALL
.STACK 100h
.DATA

Msg DB "            ",'$'
array1 DB 13,10,"array 1: ",'$'
array2 DB 13,10,"array 2: ",'$'
resultMsg DB 13,10,"the merged array: ",'$'
myArr1 DD 56,103,1001,90021
myArr2 DD 30,50,200,3427,65090
unionArr DD 9 dup(0)
; I SET N1,N2,N3 to the lenght of the array so it easier to change the values
N1 DW 4 ; ARR SIZE ;; (its DW because you cant PUSH less then DW value).
N2 DW 5; lenght of array2
N3 DW 9 ;lenght of array3
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

recorsiveArrMerge PROC ; the proc gets array1, array2 array3 , lenght of array1 ,  lenght of array2 , and lenght of array3 is unnecessary specific for my PROC 
	PUSH BP
	MOV BP,SP
	PUSH SI
	PUSH DI
	PUSH BX
	PUSH CX
	PUSH DX
	MOV SI,[BP+12] ;ARR1
	MOV DI,[BP+10] ;ARR2
	MOV BX,[BP+8] ; UNION
	MOV CX,[BP+6] ; N1
	MOV DX,[BP+4] ;N2
	check:
	CMP DX,0 ; if length of array2 is 0 ( its in the end of the array) jump to whileArr1 , else -> check length of array1
	JE whileArr1
	CMP CX,0 ; if the length of array 2 and array1 is 0 jump to endProc , else -> get the value of array2.
	JE endProc
	MOV EAX,[DI]
	CMP [SI],EAX ; if(array1[i]>array2[j]) jump to addArr2 , else -> add value of array1 to array3.
	JA addArr2
	MOV EAX,[SI]
	MOV [BX],EAX ;array3[k] = array1[i]
	ADD SI,4 ; inc si to get to the next value/index in array1.
	DEC CX ; dec by 1 the lenght of array1.
	JMP skip ; skip adding the value of array2.
	addArr2: ; if the value of array2 is smaller then array1 then add the value of array2 to array3
	MOV [BX],EAX ;array3[k] = array2[J] 
	ADD DI,4 ; inc di to get to the next value/index in array2
	DEC DX ; dec by 1 the lenght of array2
	skip:
	ADD BX,4 ;inc bx to get to the next value/index in array3.
	JMP pushVal ; if the arrays are not in the end so call the proc again.
	;JMP check ; jmp to check the varbles again.
	whileArr1: ; if the lenght of array2 is 0 then add the remaining values in array1 to array3.
	CMP CX,0
	JE endProc ; if the lenght of array1 its 0 (its in the end) then jmp to endProc and start returning , else -> add the remaining values in array1 to array3.
	MOV EAX,[SI] ; get the value in array1 and put it in array3 (merged array)
	MOV [BX],EAX
	ADD SI,4
	ADD BX,4
	DEC CX
	JMP whileArr1; loop until it gets to the end of the array and then start returning
	JMP endProc 
	whileArr2: ; if the lenght of array1 is 0 then add the remaining values in array2 to array3.
	CMP DX,0
	JE endProc ; if the lenght of array2 its 0 (its in the end) then jmp to endProc and start returning , else -> add the remaining values in array2 to array3.
	MOV EAX,[DI] ; get the value in array2 and put it in array3 (merged array)
	MOV [BX],EAX
	ADD DI,4
	ADD BX,4
	DEC DX
	JMP whileArr2 ; loop until it gets to the end of the array and then start returning
	JMP endProc
	pushVal: ; push the parameters for the proc and call it again.
	PUSH SI ; push addres of array1
	PUSH DI; push addres of array2
	PUSH BX; push addres of array3
	PUSH CX ; push lenght of array1
	PUSH DX ; push lenght of array2
	CALL recorsiveArrMerge
	endProc:
	POP DX
	POP CX
	POP BX
	POP DI
	POP SI
	POP BP
RET 10
recorsiveArrMerge ENDP



start:
	MOV AX,@DATA
	MOV DS,AX
	MOV AH,9H 
    MOV DX,offset array1 ; print a msg for the user 
    INT 21H
	LEA SI,myArr1
	PUSH SI
	PUSH N1
	CALL printArr ; print array1
	MOV AH,9H 
    MOV DX,offset array2 ; print a msg for the user 
    INT 21H
	LEA DI,myArr2
	PUSH DI
	PUSH N2
	CALL printArr ; print array2
	LEA BX,unionArr
	PUSH SI ; push addres of array1
	PUSH DI; push addres of array2
	PUSH BX; push addres of array3
	PUSH N1 ;push the lenght of array1
	PUSH N2 ;push the lenght of array2
	CALL recorsiveArrMerge
	MOV AH,9H 
    MOV DX,offset resultMsg ; print a msg for the user 
    INT 21H
	PUSH BX ; unionArr
	PUSH N3
	CALL printArr ; print the merged array.
	
	MOV AH,4Ch
	INT 21h
END start