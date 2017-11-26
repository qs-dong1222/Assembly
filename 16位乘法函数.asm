assume cs:code,ds:data,ss:stack

data segment
RESULT DD ?
CHENG DW ?
BEICHENG DD ?
data ends			

stack segment stack
DB 40H DUP (?)
stack ends

code segment
start:		 MOV AX,data
				 MOV DS,AX
				 MOV AX,stack
				 MOV SS,AX
				 
				 MOV WORD PTR BEICHENG,0F123H
				 MOV CHENG,0F251H
				 CALL MUL16
				 NOP
				 NOP
				 
				 MOV AX,4C00H
				 INT 21H
				 
				 
;;MUL16:  16 bits * 16 bits
;;First define variable as follows: 
;;RESULT DD ?
;;CHENG DW ?
;;BEICHENG DD ?
;;entry parameter: CHENG=multipiler_1, WORD PTR BEICHENG=multipiler_2, return (DX)(AX)
MUL16:		 PUSH SI
				 PUSH DI
				 
				 XOR AX,AX
				 MOV byte ptr RESULT,0
				 MOV byte ptr RESULT[2],0
				 
BEGIN:		 INC AX
				 CMP AX,17
				 JE EXIT
				 SHR CHENG,1
				 JNC NEXT
				 MOV DI,WORD PTR BEICHENG
				 MOV SI,WORD PTR BEICHENG[2]
				 ADD WORD PTR RESULT,DI
				 ADC WORD PTR RESULT[2],SI
NEXT:			 SHL WORD PTR BEICHENG,1
				 RCL WORD PTR BEICHENG[2],1
				 JMP BEGIN
				 
EXIT:			 MOV AX, WORD PTR RESULT
				 MOV DX, WORD PTR RESULT[2]
				 
				 POP DI
				 POP SI
				 RET
				

code ends
end start