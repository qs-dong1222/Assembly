assume cs:code,ds:data,ss:stack

data segment
MIN1 DB 56
MIN2 DB 02
SEC1 DB 30
SEC2 DB 10
diff_MIN DB ?
diff_SEC DB ?
data ends			

stack segment stack
DB 40H DUP (?)
stack ends

code segment
start:		MOV AX,data
				MOV DS,AX
				MOV AX,stack
				MOV SS,AX
				
				CALL compute_time_diff
				XOR AX,AX
				XOR BX,BX
				MOV AL, byte ptr diff_MIN
				MOV BL, byte ptr diff_SEC
				nop
				nop
				nop
				MOV AX,4C00H
				INT 21H

				
;; compute time difference within consecutive hours
;; result is difference in minutes and seconds				
;; no entry parameters
;; variable: MIN1,MIN2,SEC1,SEC2,diff_MIN,diff_SEC are needed				
compute_time_diff:
				PUSH AX
				PUSH BX
				MOV AL, byte ptr MIN1
				MOV BL, byte ptr MIN2
				CMP AL,BL
				JAE Y_diff_min
				SUB BL,AL
				MOV byte ptr diff_MIN, BL
				JMP CMP_SEC
Y_diff_min:ADD BL,60
				SUB BL,AL
				MOV byte ptr diff_MIN, BL
CMP_SEC:		MOV AL, byte ptr SEC1
				MOV BL, byte ptr SEC2
				CMP AL,BL
				JAE Y_diff_sec
				SUB BL,AL
				MOV byte ptr diff_SEC, BL
				JMP EXIT
Y_diff_sec:ADD BL,60
				SUB BL,AL
				MOV byte ptr diff_SEC, BL
EXIT:			POP BX
				POP AX
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