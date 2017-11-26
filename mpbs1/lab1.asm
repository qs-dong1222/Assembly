;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Version : 1.3
;Author : Qiu
;Date : 19/10/2015
;Description : In this version(1.3), the double loop operation on managing the matrix has been improved by using CX only.
;In addition, the number of bits of each element in MATRIX is shortened from DD(in version 1.2) to DW(in version 1.3) according
;to the requirements "IN WORD". (even though the word type CANNOT be always suitable for every result of multiplication.) 
;The verification on maximum value of matrix and overflow flag still works. 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

assume cs:code,ds:data,ss:stack

data segment
Array	DB 1,2,3,4,5,6,7,8,9,10
Result DW 9 DUP(?)
MIN_ARRAY DB ?
MIN_RESULT DW ?
MAX_MATRIX DW 0000H,0000H
OVERFLOW DB 0
MATRIX	DW 81 DUP(?)
data ends

stack segment stack
DW 20H DUP(0)
stack ends

code segment
start:	MOV AX,data
			MOV DS,AX
			 
			MOV AX,stack
			MOV SS,AX        ; There are 40H bytes in stack, so set SP = 40H.
			
			SUB AX,AX
			SUB DX,DX
			MOV BX,0
			MOV SI,0
			MOV CX,9
SUM:		MOV AL,data:[BX]
			INC BX
			MOV DL,data:[BX]
			ADD AX,DX
			MOV Result[SI],AX
			ADD SI,2
			SUB AX,AX
			SUB DX,DX
			LOOP SUM		; add up two consecutive elements. Array is for storing sequence A, Result is for storing sequence B.		
			
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			
			SUB AX,AX
			SUB DX,DX
			MOV BX,0
FETCH1:	MOV AL,Array[BX]
			MOV MIN_ARRAY,AL
LOOP1:	CMP BX,9
			JZ  EXIT1
			INC BX
			MOV AL,MIN_ARRAY
			CMP AL,Array[BX]
			JC  LOOP1
			MOV AL,Array[BX]
			MOV MIN_ARRAY,AL
			JMP LOOP1
EXIT1:	NOP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  minimum of array is stored in MIN_ARRAY(btye)

			SUB AX,AX
			SUB DX,DX
			MOV BX,0
FETCH2:	MOV AX,Result[BX]
			MOV MIN_RESULT,AX
LOOP2:	CMP BX,16
			JZ  EXIT2
			INC BX
			INC BX
			MOV AX,MIN_RESULT
			CMP AX,Result[BX]
			JC  LOOP2
			MOV AX,Result[BX]
			MOV MIN_RESULT,AX
			JMP LOOP2
EXIT2:	NOP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  minimum of result is stored in MIN_RESULT(word)			

;;;; Arrangement of matrix is following

			SUB DX,DX
			SUB BX,BX
			SUB DI,DI
			SUB BP,BP
			SUB SI,SI
			
			MOV CX,9
EXLOOP:	PUSH	CX
			
			MOV CX,9
INLOOP:	MOV AL,data:Array[BP]   
			MOV AH,0							;(AX)= (AH,Array[BX])
			MOV DI,Result[SI]
			MUL DI							; multiplication -> (DX)(AX)
			MOV MATRIX[BX][SI],AX
			CMP DX,0							;check if there is a occurrence of overflow
			JNC SETOF
BACK:		CMP DX,MAX_MATRIX+2
			JNC XCHE							; if DX > MAX_MATRIX, jump to updating process.
			JNZ NOXCHE						; if DX < MAX_MATRIX, nothing has to be done and go back to execute another loop.
			CMP AX,MAX_MATRIX			; if DX = MAX_MATRIX, compare the AX with MAX_MATRIX.
			JNC XCHE							; if AX > MAX_MATRIX, jump to updating process. otherwise go back to execute another loop.
NOXCHE:	ADD SI,2
			LOOP INLOOP
			INC BP
			ADD BX,18
			XOR SI,SI
			
			POP CX
			LOOP EXLOOP
			JMP EXIT
			
XCHE:		MOV MAX_MATRIX,AX
			MOV MAX_MATRIX+2,DX
			JMP NOXCHE
			
SETOF:	MOV OVERFLOW,1
			JMP BACK
					
EXIT:		NOP							; marked the end of code segment to easily debug.

;;;;;;found the maximum of matrix
; ALL QUESTIONS ARE SOLVED

			MOV AX,4C00H
			INT 21H
code ends

end start