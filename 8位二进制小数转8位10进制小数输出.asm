assume cs:code,ds:data,ss:stack

data segment
DEC_FRAC DD 0
BIN_FRAC DB 11001000b
data ends

stack segment stack
DB 20H DUP(?)
stack ends

code segment
start:	MOV AX,data
			MOV DS,AX
			MOV AX,stack
			MOV SS,AX

			PUSH AX
			MOV AL,BIN_FRAC
			CALL BIN_FRAC_2_DEC_FRAC
			POP AX
			;;;;; done with the conversion
			
			
			;; display is in following
			PUSH DX
			MOV DX,30h
			CALL PRINT_CHAR
			POP DX           ; print '0'
			
			PUSH DX
			MOV DX,2Eh
			CALL PRINT_CHAR
			POP DX           ; print '.'
			
			
			;; print 8 conbinational BCD in DEC_FRAC one by one
			XOR DX,DX
			MOV DI,3
			MOV CX,4
			
			
BBBBB:	MOV DL, byte ptr DEC_FRAC[DI]
			SHR DL,1
			SHR DL,1
			SHR DL,1
			SHR DL,1
			ADD DL,30H
			CALL PRINT_CHAR
			MOV DL, byte ptr DEC_FRAC[DI]
			AND DL,00001111B
			ADD DL,30H
			CALL PRINT_CHAR
			DEC DI
			
			LOOP BBBBB
			
			NOP
			NOP
			NOP
			MOV AX,4C00H
			INT 21H
			
			
			
;; entry parameter AL = original binary fraction number to be converted
;; a veriable called 'DEC_FRAC' of 32bits is needed
;; return is combinational BCD in DEC_FRAC, 4 bits each digit.
BIN_FRAC_2_DEC_FRAC:
			PUSH CX
			PUSH DI
			MOV DEC_FRAC,0
			
			MOV DI,3
			MOV CX,4
			
AAAA:		PUSH CX	
			MOV CL,10
			MUL CL
			AND AH,00001111B
			SHL AH,1
			SHL AH,1
			SHL AH,1
			SHL AH,1
			ADD byte ptr DEC_FRAC[DI],AH
			MUL CL
			AND AH,00001111B
			ADD byte ptr DEC_FRAC[DI],AH
			DEC DI
			
			POP CX
			LOOP AAAA
					
			POP DI
			POP CX
			RET
			
;; print a general ASCII character
;; entry DX = ASCII 				 
PRINT_CHAR: 	PUSH AX							
					MOV AH,02H					
					INT 21H					
					POP AX
					RET


code ends
end start


