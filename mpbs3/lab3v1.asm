;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;Version : 1.1
;Data : 1/1/2016
;Author : Qiu
;Description : In this version, condition of leap year has been properly solved. All the question are solved.
;The returning parameter of subfunction, i.e the numbers of weeks, is in AX. 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


PUBLIC _countweeks
.MODEL SMALL

.DATA
DAY DB ?
MONTH DB ?
YEAR DW ?
LEAP_YEARS DW ?
NOT_LEAP DB ?
TOTAL_DAYS DD ?
			

.STACK
DB 40H DUP (?)


.CODE
_countweeks PROC
				PUSH  BP
				MOV BP,SP
				MOV BX,[BP+4] ;BX is a segment address
				MOV DI,[BP+6] ;DI is an offset address
				ADD BX,DI
	 
				 XOR AX,AX
				 XOR SI,SI
				 
				 MOV AL, byte ptr [BX+SI]
				 SUB AL,30H   
				 MOV AH,10
				 MUL AH			
				 MOV AH,AL		
				 INC SI
				 MOV AL, byte ptr [BX+SI] 
				 SUB AL,30H   
				 ADD AL,AH		; AL= date of day based on decimal.
				 MOV DAY,AL
				 ;;;;;;;;;day
				 
				 MOV AL, byte ptr [BX+SI+2]
				 SUB AL,30H   
				 MOV AH,10
				 MUL AH			
				 MOV AH,AL		
				 INC SI
				 MOV AL, byte ptr [BX+SI+2] 
				 SUB AL,30H   
				 ADD AL,AH		; AL= date of month based on decimal.
				 MOV MONTH,AL
				 ;;;;;;;;;;;;month
				 
				 MOV AL, byte ptr [BX+SI+4]
				 SUB AL,30H   
				 XOR AH,AH		
				 MOV DI,1000
				 MUL DI			; DX=0,AX=2000
				 MOV BP,AX		
				 INC SI
				 MOV AL, byte ptr [BX+SI+4]
				 SUB AL,30H   
				 XOR AH,AH		
				 MOV DI,100
				 MUL DI			
				 ADD BP,AX		; BP = 2000+000
				 INC SI
				 MOV AL, byte ptr [BX+SI+4]
				 SUB AL,30H   
				 MOV AH,10
				 MUL AH			
				 ADD BP,AX		
				 INC SI
				 MOV AL, byte ptr [BX+SI+4]
				 SUB AL,30H   
				 XOR AH,AH		
				 ADD BP,AX		; BP=2000+000+10+3 assuming year 2013
				 MOV YEAR,BP
				 ;;;;;;;;;;;;;year
				 
				 ;; BX is no longer used.
				 ;;;;;;;;;;;;;;;; conversion from ASCII to decimal is done.
				 
				 MOV AX,YEAR
				 SUB AX,2000				 ; AX= difference of year
				 PUSH AX
				 XOR DX,DX   				 ; use 32bits div
				 MOV BX,4
				 DIV BX						 ;	  AX=Quotient , (DX)=RESIDULE.
				 CMP DX,0					
				 JE NEXT						 ; if this inputting year is leap year then jump.	
				 INC AX						 ; add up the leap year of 2000.
				 MOV NOT_LEAP,1			 ; if this inputting year isn't leap year then NOT_LEAP=1.
NEXT:			 MOV LEAP_YEARS,AX		 ; AX now = number of leap years from 2000.1.1 to xxxx.1.1
				 POP AX    				 ; AX = difference of year
				 MOV BX,365
				 MUL BX     			    ; (DX)(AX)=number of days from 2000.1.1 to xxxx.1.1 assuming no leap years.
				 ADD AX,LEAP_YEARS      ; (DX)(AX)=number of days from 2000.1.1 to xxxx.1.1 considering leap years.
				 MOV word ptr TOTAL_DAYS,AX
				 MOV word ptr TOTAL_DAYS[2],DX
				
				;;;;;;;;;;;;;;;;;   done with the total days of years.

				 XOR AX,AX
				 XOR DX,DX
				 MOV DL, byte ptr MONTH
				 MOV DI,DX
				 XOR CX,CX;;
				 MOV CL, byte ptr MONTH;;
				 CMP DI,8
				 JB LESS_7    
				 MOV CX,7
				 XOR BX,BX
NEXT_A:		 CMP BX,0
				 JE  PLUS_31
				 ADD AX,30
				 XOR BX,BX
				 JMP LOOP1
				 
PLUS_31:		 ADD AX,31
				 MOV BX,1
LOOP1:		 LOOP NEXT_A

				 XOR CX,CX
				 MOV CL, byte ptr MONTH
				 SUB CX,7
LESS_7:	 	 DEC CX
				 CMP CX,0
				 JE HERE               ;;;;;;;;;; no more month needs to be added
				 XOR BX,BX
NEXT_B:		 CMP BX,0
				 JE  PLUS_31_A
				 ADD AX,30
				 XOR BX,BX
				 JMP LOOP2
				 
PLUS_31_A:  ADD AX,31
				 MOV BX,1
LOOP2:		 LOOP NEXT_B

				 ;;;;;;;  done with the basic calculation of # of days of month

HERE:			 CMP DI,2
				 JBE  EXIT
				 XOR BX,BX
				 MOV BL, byte ptr NOT_LEAP
				 CMP BL,0            
				 JE  IS_LEAP      
				 DEC AX
IS_LEAP:		 DEC AX
			 
EXIT:			 XOR BX,BX
				 MOV BL, byte ptr DAY
				 ADD AX,BX
				 ADD word ptr TOTAL_DAYS,AX
				 ADC word ptr TOTAL_DAYS[2],0
				 ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;  done with the # of days in month
				 
				 MOV DX, word ptr TOTAL_DAYS[2]
				 MOV AX, word ptr TOTAL_DAYS
				 MOV CX,7
				 DIV CX           ;  DX = RESIDULE, AX = # of weeks
				 
				 ; ALL IS SOLVED
							
							
							
							
				 POP BP
				 RET
_countweeks ENDP
				 END
