; Dividend is in DX, Divisor is in BX, number of operating bits is in SI. Final quotient is in AX, residule is in DX.

assume cs:code,ds:data,ss:stack

data segment
data ends

stack segment stack
DB 40H DUP(?)
stack ends

code segment
start:		MOV AX,data
				MOV DS,AX
				MOV AX,stack
				MOV SS,AX
				
				PUSH DX
				PUSH BX
				PUSH AX
				
				MOV DX,0ffffH
				MOV BX,1
				CALL DIV16
				NOP				
				NOP
				NOP
				POP AX
				POP BX
				POP DX
	
				MOV AX,4C00H
				INT 21H

;;DIV16 : 16 bits / 16 bits				
;;entry parameter : Dividend is in DX, Divisor is in BX.
;;return final quotient is in AX, residule is in DX.
DIV16:		PUSH SI

				MOV SI,16
				XOR AX,AX
				
				CMP BX,0
				JE EXIT
GO_ON:		SHL DX,1
				RCL AX,1
				CMP AX,BX
				JAE DY
				AND DX,0FFFEH
				JMP MIUSCONT
DY:			SUB AX,BX
				OR DX,0001H				
MIUSCONT:	DEC SI
				CMP SI,0
				JE EXIT
				JMP GO_ON						
				
EXIT:			XCHG AX,DX
				POP SI
				RET

				
code ends
end start