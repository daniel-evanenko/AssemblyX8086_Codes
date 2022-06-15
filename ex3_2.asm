.MODEL SMALL
.STACK 100h
.DATA
arrMsg1 DB 13,10,"please enter 7 numbers into array 1 ",13,10,"that are not bigger then '4,294,967,295'",13,10,"to save and input each number press '#'.",10,13,'$'
arrMsg2 DB 13,10,"please enter 5 numbers into array 2 ",13,10,"that are not bigger then '4,294,967,295'",13,10,"to save and input each number press '#'.",10,13,'$'
Msg DB "            ",'$'
entNextNum DB 13,10,"please enter a number.",13,10,'$'
array1Bfs DB 13,10,"array 1 before sort: ",'$'
array2Bfs DB 13,10,"array 2 before sort: ",'$'
array1Afs DB 13,10,"array 1 after sort: ",'$'
array2Afs DB 13,10,"array 2 after sort: ",'$'

resultMsg DB 13,10,"the merged array: ",'$'
myArr1 DD 7 dup(0)
myArr2 DD 5 dup(0)
unionArr DD 12 dup(0)
N1 DW 7 ; ARR SIZE ;; (its DW because you cant PUSH less then DW value).
N2 DW 5; lenght of array2
N3 DW 12 ;lenght of array3
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

arrNumInput PROC ; gets an addres of array and size of it (arr* , size)
	PUSH BP
	MOV BP,SP
	PUSH CX
	PUSH SI
	MOV CX,[BP+4] ; arr size
	MOV SI,[BP+6] ; arr addres -> arr[0]
	input:
	MOV AH,9H 
    MOV DX,offset entNextNum ; print a msg for the user 
    INT 21H 
	CALL numInput ; get a number from the user -> EAX has the user number
	MOV [SI],EAX ; arr[si] == user input/num
	ADD SI,4 ;adds 4 to si to get to the next index in the arr
	LOOP input ; loop arrsize/cx times.
	POP SI
	POP CX
	POP BP
RET 4
arrNumInput ENDP
sortArr PROC ; gets an addres of array and size of it (arr* , size)
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
        JNZ innerLoop
    LOOP outerLoop

    POP SI
    POP DX
    POP CX
    POP EBX
    POP EAX
    POP BP
    RET 4
sortArr ENDP

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

recorsiveArrMerge PROC ;; if the values of array1 and array2 are equal -> the proc adds the values of array2 first and them jumps to the whilearr1 because the lenght of array2 is 0 then loops and adds all the numbers of array1 to the mergedArray.
 ; the proc gets array1, array2 array3 , lenght of array1 ,  lenght of array2 , --and lenght of array3 is unnecessary specific for my PROC--
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
	LEA SI,myArr1
	LEA DI,myArr2
	LEA BX,unionArr
	MOV AH,9H ;
    MOV DX,offset arrMsg1 ; print a msg for the user 
    INT 21H 
	PUSH SI
	PUSH N1
	CALL arrNumInput ; input 7 number from user into array 1
	MOV AH,9H 
    MOV DX,offset arrMsg2 ; print a msg for the user 
    INT 21H
	PUSH DI
	PUSH N2
	CALL arrNumInput ; input 5 number from user into array 2
	MOV AH,9H
	MOV DX,offset array1Bfs ; print -> the array before sort 
    INT 21H 
	PUSH SI
	PUSH N1
	CALL printArr ; -> prints array1 before the sort
	PUSH SI
	PUSH N1
	CALL sortArr ; sort the array 1
	MOV AH,9H
	MOV DX,offset array2Bfs ; print -> the array2 before sort 
    INT 21H
	PUSH DI
	PUSH N2
	CALL printArr; -> prints array2 before the sort
	PUSH DI
	PUSH N2
	CALL sortArr ; sort the array 2
	MOV AH,9H 
    MOV DX,offset array1Afs ; print a msg -> array1 : 
    INT 21H
	PUSH SI
	PUSH N1
	CALL printArr ; print array1
	MOV AH,9H 
    MOV DX,offset array2Afs ;  print a msg -> the array2 : 
    INT 21H
	PUSH DI
	PUSH N2
	CALL printArr ; print array2
	PUSH SI ; push addres of array1
	PUSH DI; push addres of array2
	PUSH BX; push addres of array3
	PUSH N1 ;push the lenght of array1
	PUSH N2 ;push the lenght of array2
	CALL recorsiveArrMerge
	MOV AH,9H 
    MOV DX,offset resultMsg ; print a msg -> "the mergedArray:" 
    INT 21H
	PUSH BX ; unionArr
	PUSH N3
	CALL printArr ; print the merged array.
	
	MOV AH,4Ch
	INT 21h
END start