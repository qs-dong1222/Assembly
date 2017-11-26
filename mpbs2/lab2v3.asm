;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Version : 1.3
;Data : 27/11/2015
;Author : Qiu
;Description : In this version, all the questions are solved by means of invoking subfunctions. 
;In version 1.0, the functionality of displaying string and input capture were achieved in particular case. 
;However, in version 1.1, in order to manage the entire program better, the modularity of programmig is used through packing
;all the processes into subfunctions and 1-3 question were organized.
;In version 1.2 and 1.3, all questions are packed to solved. Besides, by debugging, some operation regarding stack segment
;were organized.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

assume cs:code,ds:data,ss:stack
k EQU 3

data segment
String1 DB 'Input Fourth Row :$' ;head address 0
String2 DB 'Input Third Row  :$' ;head address 19
String3 DB 'Input Second Row :$' ;head address 38
String4 DB 'Input First Row  :$' ;head address 57
Fourth_Row DB 50 DUP(?)  ;head address 76 , used for storing input characters of 1st row
Third_Row DB 50 DUP(?)   ;head address 126 , ...
Second_Row DB 50 DUP(?)	;head address 176 , ...
First_Row DB 50 DUP(?)	   ;head address 226 , ...
Char_Counter_4th DB 52 DUP(?) ; head address 276, statistic # of appearence among A...Z and a...z in 4th row 
Char_Counter_3rd DB 52 DUP(?) ; head address 328, statistic # of appearence among A...Z and a...z in 3rd row 
Char_Counter_2nd DB 52 DUP(?) ; head address 380
Char_Counter_1st DB 52 DUP(?) ; head address 432
String5 DB 'Character appearing the most times in 1st row :$'
String6 DB 'Character appearing the most times in 2nd row :$'
String7 DB 'Character appearing the most times in 3rd row :$'
String8 DB 'Character appearing the most times in 4th row :$'
String9 DB 'Character appearing the halved times in 1st row :$'
String10 DB 'Character appearing the halved times in 2nd row :$'
String11 DB 'Character appearing the halved times in 3rd row :$'
String12 DB 'Character appearing the halved times in 4th row :$'
MAX_1st_Row DW ? ;high part stores index, low part stores appearence times
MAX_2nd_Row DW ?
MAX_3rd_Row DW ?
MAX_4th_Row DW ?
String_overall DB 'The character that appears among 4 rows is :$'
AfterCC_1st_Row DB 'After Caesar cipher transformation, 1st Row is :$'
AfterCC_2nd_Row DB 'After Caesar cipher transformation, 2nd Row is :$'
AfterCC_3rd_Row DB 'After Caesar cipher transformation, 3rd Row is :$'
AfterCC_4th_Row DB 'After Caesar cipher transformation, 4th Row is :$'
Caesar_cipher DB 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
data ends

stack segment stack
DB 40H DUP(?)
stack ends

code segment
start:		MOV AX,data
				MOV DS,AX
				MOV AX,stack
				MOV SS,AX

				MOV CX,4
INPUT_LOOP:PUSH CX
			
				CALL PRINT_STR
			
				XOR SI,SI
CONTINUE	:	CALL GET_CHAR
				CMP AL,0DH			; compare with "Enter" key.
				JE FINISH_ROW
				CMP SI,49			; see if it fills up the entire elements of xxx row 
				JE FINISH_ROW
				CALL STORE			; this ASCII value should be stored in to xxx row if two conditions above are not satisfied.
				INC SI
				JMP CONTINUE
					
FINISH_ROW: XOR SI,SI
				CALL PRINT_ENTER	
				
				POP CX				
				LOOP INPUT_LOOP
		
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 1st question is solved	

				PUSH DI
				PUSH BP
				PUSH SI
				MOV BP, offset string5
				MOV DI, offset Char_Counter_1st
				CALL MAX_PRINT_FUNC
				MOV MAX_1st_Row, SI		; return SI = (index of max)(max # of appearing times in Char_Counter_xxx)
												
				PUSH DX
				MOV DX, offset String9      ; print String9
				CALL PRINT_GEN_STR
				POP DX
				
				PUSH AX
				PUSH DI
				MOV AX,MAX_1st_Row
				MOV DI, offset Char_Counter_1st		;print the 1st row's halved characters
				CALL FIND_HALVE
				CALL PRINT_ENTER
				POP DI
				POP AX
				
				POP SI
				POP BP
				POP DI
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;		Done with the 1st row's halved characters

				PUSH DI
				PUSH BP
				PUSH SI
				MOV BP, offset string6
				MOV DI, offset Char_Counter_2nd
				CALL MAX_PRINT_FUNC
				MOV MAX_2nd_Row, SI
				
				PUSH DX
				MOV DX, offset String10      ; print String10
				CALL PRINT_GEN_STR
				POP DX
				
				PUSH AX
				PUSH DI
				MOV AX,MAX_2nd_Row
				MOV DI, offset Char_Counter_2nd				;print the 2nd row's halved characters
				CALL FIND_HALVE
				CALL PRINT_ENTER
				POP DI
				POP AX
				
				POP SI
				POP BP
				POP DI
				
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	Done with the 2nd row's halved characters			
				PUSH DI
				PUSH BP
				PUSH SI
				MOV BP, offset string7
				MOV DI, offset Char_Counter_3rd
				CALL MAX_PRINT_FUNC
				MOV MAX_3rd_Row, SI
					
				PUSH DX
				MOV DX, offset String11      ; print String11
				CALL PRINT_GEN_STR
				POP DX
				
				PUSH AX
				PUSH DI
				MOV AX,MAX_3rd_Row
				MOV DI, offset Char_Counter_3rd		;print the 3rd row's halved characters
				CALL FIND_HALVE
				CALL PRINT_ENTER
				POP DI
				POP AX
								
				POP SI
				POP BP
				POP DI
				
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	Done with the 3rd row's halved characters				
				PUSH DI
				PUSH BP
				PUSH SI
				MOV BP, offset string8
				MOV DI, offset Char_Counter_4th
				CALL MAX_PRINT_FUNC
				MOV MAX_4th_Row, SI
				
				PUSH DX
				MOV DX, offset String12      ; print String12
				CALL PRINT_GEN_STR
				POP DX
				
				PUSH AX
				PUSH DI
				MOV AX,MAX_4th_Row
				MOV DI, offset Char_Counter_4th		;print the 4th row's halved characters
				CALL FIND_HALVE
				CALL PRINT_ENTER
				POP DI
				POP AX
				
				POP SI
				POP BP
				POP DI
				
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Done with the 4th row's halved characters
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 2nd question is solved
			
				PUSH DX
				MOV DX, offset String_overall      ; print String_overall
				CALL PRINT_GEN_STR
				POP DX
				
question3:	MOV SI, offset Char_Counter_4th		 
				XOR BX,BX
				MOV CX,52
				
LOOPROW:		PUSH CX
				CMP byte ptr [SI+BX],0						; compare this element's value, seeing if it has shown in this row
				JE NEXT_COLUMN
				
				ADD SI,52										;
				CMP SI, offset Char_Counter_1st		; check if the pointer is still inside the Matrix of Char_Counter_xxx
				JA PRINT_CHAR									; if pointer goes out of the Matrix of Char_Counter_xxx, this character corressponding
				JMP LOOPROW									; to its column should be printed
	
PRINT_CHAR:CMP BX,26					;
				PUSH BX						;
				JAE SMALL_OUT2			;
				JMP BIG_OUT2				;
SMALL_OUT2:ADD BX,6H					; compare ASCII of this character and print this character
BIG_OUT2:	ADD BX,41H					;
				MOV DL,BL 					;
				MOV AH,02H					;
				INT 21H						;
				POP BX						;
				
NEXT_COLUMN:INC BX												; 
				MOV SI, offset Char_Counter_4th			; move to first row of the Matrix of Char_Counter_xxx and next column
				POP CX
				LOOP LOOPROW
				CALL PRINT_ENTER
				
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	3rd question is solved

question4:	PUSH DX
				MOV DX, offset AfterCC_1st_Row
				CALL PRINT_GEN_STR
				POP DX
				
				PUSH AX
				PUSH BX
				MOV AX,k
				MOV BX, offset First_Row
				CALL ccTrans
				POP AX
				POP BX
				
				CALL PRINT_ENTER
;;;;;;;;;;;; 1st row finished the Caesar cipher transformation				
				PUSH DX
				MOV DX, offset AfterCC_2nd_Row
				CALL PRINT_GEN_STR
				POP DX
				
				PUSH AX
				PUSH BX
				MOV AX,k+1
				MOV BX, offset Second_Row
				CALL ccTrans
				POP AX
				POP BX
				CALL PRINT_ENTER
;;;;;;;;;;;; 2nd row finished the Caesar cipher transformation				
				PUSH DX
				MOV DX, offset AfterCC_3rd_Row
				CALL PRINT_GEN_STR
				POP DX
				
				PUSH AX
				PUSH BX
				MOV AX,k+2
				MOV BX, offset Third_Row
				CALL ccTrans
				POP AX
				POP BX
				CALL PRINT_ENTER
;;;;;;;;;;;; 3rd row finished the Caesar cipher transformation				
				PUSH DX
				MOV DX, offset AfterCC_4th_Row
				CALL PRINT_GEN_STR
				POP DX
				
				PUSH AX
				PUSH BX
				MOV AX,k+3
				MOV BX, offset Fourth_Row
				CALL ccTrans
				POP AX
				POP BX
				CALL PRINT_ENTER
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; 4th question is solved
		
				MOV AX,4C00H				; EXIT of program
				INT 21H
				
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; SUBFUNCTIONS					

;; print 4 dedicated character strings above in data segment that ends up with '$'				
PRINT_STR:	PUSH AX
				PUSH BX
				PUSH CX
				PUSH DX
				
				DEC CX
				MOV AL,CL
				MOV BL,19
				MUL BL
				MOV DX,AX			; calculate the head address of string to display: input xxx row
				MOV AH,09H
				INT 21H
				
				POP DX
				POP CX
				POP BX
				POP AX
				RET
				
GET_CHAR:	MOV AH,01H
				INT 21H
				RET
				
;;store A...Z and a...z into 	First_Row, Second_Row, etc.			
STORE:			PUSH AX
					PUSH BX
					PUSH CX
					
					PUSH AX
					MOV AL,CL
					MOV CH,50
					MUL CH
					MOV BX,AX
					POP AX
					MOV byte ptr DS:26[BX+SI],AL
					
					PUSH DI
					PUSH AX
					DEC CL
					MOV AL,CL
					MOV CH,52
					MUL CH
					MOV DI,AX
					POP AX
					MOV BL,AL
					XOR BH,BH
					CMP BL,60H
					JA  SMALL_LETTER
					JMP BIG_LETTER
SMALL_LETTER: SUB BX,6
BIG_LETTER:	ADD Char_Counter_4th[DI+BX-41H],1	  ; count times of appearence of A...Z, a...z.
					POP DI

					POP CX
					POP BX
					POP AX
					RET
				
;;print '\n'				
PRINT_ENTER: 	PUSH AX				
					PUSH DX				
					MOV AH,02H			
					MOV DL,0AH			
					INT 21H					
					POP DX
					POP AX
					RET

;; Print a general string that ends up with '$'
;; entry parameter : DX = string's head address.
PRINT_GEN_STR: MOV AH,09H 
					 INT 21H
					 RET

;; print prompt string and the character that appears the most time				 
;; entry parameter : (DI)= counting array's head address. (BP)= character string's address
;; return parameter : SI = (index of max)(max # of appearing times in Char_Counter_xxx) 
MAX_PRINT_FUNC:	PUSH BX
						PUSH DX
						PUSH CX
						PUSH AX

						XOR BX,BX
						XOR DX,DX
						MOV CX,52
SELECT_MAX_ROW:	CMP DL,byte ptr [BX+DI]	  ;DL stores max # of appearing times in Char_Counter_xxx
						JAE DL_GREATER
						MOV DL,byte ptr [BX+DI]  ;DH stores index of this max # in Char_Counter_xxx
						MOV DH,BL
DL_GREATER:		INC BX
						LOOP SELECT_MAX_ROW
						
						PUSH DX
						MOV DX,BP
						CALL PRINT_GEN_STR
						POP DX							; Print :"Character appearing the most times in xxx row :"
						
						PUSH DX
						CMP DH,26
						JAE SMALL_OUT
						JMP BIG_OUT
SMALL_OUT:			ADD DH,6H
BIG_OUT:				ADD DH,41H
						MOV DL,DH
						XOR DH,DH
						MOV AH,02H
						INT 21H
						POP DX						; print character appearing the most times.
						
						CALL PRINT_ENTER			; print '\n'
						
						MOV SI,DX					;DL stores max # of appearing times in Char_Counter_xxx
														;DH stores index of this max # in Char_Counter_xxx
						POP AX
						POP CX
						POP DX
						POP BX
						RET	
						
;; find the character that appears half times of max
;; entry parameter : AL= max # of times of appearence in Char_Counter_xxx, DI=head address of the Char_Counter_xxx					
FIND_HALVE:	   PUSH CX
						PUSH BX
						PUSH DX

						SHR AL,1               ; AL/2
						CMP AL,0
						JE	 GOBACK
						XOR BX,BX
						MOV CX,52
HERE:					CMP byte ptr [DI+BX],AL
						JNE DIDT_FIND
						CMP BX,26
						PUSH BX
						JAE SMALL_OUT1
						JMP BIG_OUT1
SMALL_OUT1:		ADD BX,6H
BIG_OUT1:			ADD BX,41H
						MOV DL,BL 
						PUSH AX
						MOV AH,02H
						INT 21H
						POP AX						;interrupt AH=02H INT 21H will return AL=ASCII of displayed character
						POP BX
DIDT_FIND:			INC BX
						LOOP HERE
						
GOBACK:				POP DX
						POP BX
						POP CX
						RET
						
;;Print out the Caesar cipher transformed sequence of the given row of characters						
;;entry parameter AX = Caesar cipher parameter K, BX = address of sequence of chars(xx_Row) that is going to be transformed
ccTrans:				PUSH CX
						PUSH SI
						PUSH DI
						XOR DI,DI
						MOV CX,50
						
EXTERNAL:			PUSH CX
						XOR SI,SI
						CMP byte ptr [BX+DI], 0
						JNE CHECKCHAR
						POP CX
						POP DI
						POP SI
						POP CX
						RET
CHECKCHAR:			MOV CL, byte ptr [BX+DI]
						CMP CL, byte ptr Caesar_cipher[SI]
						JNE NEXRCMP
TRANSFORM:			PUSH SI
						PUSH DX
						PUSH AX
						
						ADD SI,AX
						MOV DL, byte ptr Caesar_cipher[SI]
						MOV AH,02H
						INT 21H
						
						POP AX
						POP DX
						POP SI
						JMP GO_OUT

NEXRCMP:				INC SI
						JMP CHECKCHAR
GO_OUT:				INC DI
						POP CX
						LOOP EXTERNAL
						
						POP DI
						POP SI
						POP CX
						RET
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;						
											
code ends

end start