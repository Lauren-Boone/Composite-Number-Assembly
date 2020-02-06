TITLE Composite Numbers   (Assignment.asm)

; Author: Lauren Boone
; Last Modified: 4/28/19
; OSU email address:  boonela@oregonstate.edu


; Description: This program calculates and displays composites numbers. The user is asked for a nmuber
;between [1-400] and displays the composite numbers up to and including the nth composite number.  

INCLUDE Irvine32.inc

; constant values for validating input
	UPPER_LIMIT = 400
	LOWER_LIMIT = 1
	MAX_SPACE = 8
	MAX_ROWS=10

.data

;introduction
progTitle		BYTE	"Welcome to Composite Numbers",0
programmer		BYTE	"Author: Lauren Boone",0
instruct1		BYTE	"Enter the number of composite numbers you would like to see",0
instruct2		BYTE	"I'll accept orders for up to 400 composite [1-400]",0
inputPrompt		BYTE	"Enter the number of composites to display...[1-400]: ",0
invalid			BYTE	"Out of range. Try again.",0
goodbye			BYTE	"Hope you enjoyed Composite Numbers! Goodbye",0
EC1				BYTE	"I will align the output",0

;data for numbers
num_of_Comp		DWORD	?
currentNum		DWORD	4
testNum			DWORD	0
numRow			DWORD	0
divisor			DWORD	?
space			BYTE	" ",0
numSpace		DWORD	7

.code
main PROC

	call introduction
	call getUserData
	call showComposites
	call farewell

; (insert executable instructions here)

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

;****************************************************
;Procedure: introduction
;This procedure displays the introduction to the user
;Recieves: none
;Returns: none
;Preconditions: none
;regs:EDX
;**************************************************
introduction	PROC

	;display program and programmer name
	mov			EDX, OFFSET progTitle
	call	WriteString
	call	Crlf
	mov			EDX, OFFSET programmer
	call	WriteString
	call	Crlf

	;display instructions
	mov			EDX, OFFSET instruct1
	call	WriteString
	call	Crlf
	mov			EDX, OFFSET instruct2
	call	WriteString
	call	Crlf
	call	Crlf
	
	;EC
	mov			EDX, OFFSET EC1
	call	WriteString
	call	Crlf


	ret
introduction ENDP


;***************************************************
;Procedure: getUserData
;This procedure asks the user to enter a number
;between [1-400]. If the input is within the specified
;range return. Otherwise loop through untill the 
;user enters a value within the range
;Recieves: none
;Returns: none
;Preconditions: none
;regs: EDX, EAX
;*****************************************************
getUserData	PROC

	;Prompt user for input
	mov			EDX, OFFSET inputPrompt
	call	WriteString
	call	ReadInt
	mov			num_of_comp, EAX
	call	validate

	ret
getUserData ENDP



;********************************************************
;Procedure: validate
;This procedure checks the input value against the set 
;range. If the value is out of range the user is 
;prompted to re-enter a value
;Otherwise return
;Recieves: None
;Returns: none
;PreConditions: None
;Regs: EAX, EDX, ECX
;********************************************************
validate	PROC

	;compare value against limits 
	mov			EAX, num_of_comp
	cmp		EAX, UPPER_LIMIT
	jg		ERROR_MESSAGE
	cmp		EAX, LOWER_LIMIT
	jl		ERROR_MESSAGE
	jae		VALID_INPUT

	;This function prints that the number is not within range and to try again
	;The program jumps to getUserData
	ERROR_MESSAGE:
		
		;Display error message
		mov			EDX, OFFSET invalid
		call	WriteString
		call	Crlf
		call	getUserData

	VALID_INPUT:
		;mov		num_of_comp, EAX
		mov		ECX, num_of_comp
		ret

validate ENDP




;********************************************************
;Procedure: showComposites
;DESC:This procedure displays n number of composites based
;on the user's input. A loop counter is set to the ecx
;from the num_of_comp value.The output is aligned with 10 spaces
;between each number. That is including the numbers
;Recieves: None
;Returns: None
;PreConditions: THe number of composites must be in range
;Regs: ECX, EDX, EAX
;EX:
;1     1     1     1
;11    11    11    11
;111   111   111   111
;************************************************************
showComposites PROC

	;Initialize counter
	;mov			ECX, num_of_comp
	
	;Determine next composite number
	FINDCOMP:
		call isComposite

	PRINT:
		mov		EAX, currentNum
		call	WriteDec

		
		inc			numRow
		mov			num_of_comp, ECX		;Save the counter(need new counter for spaces)
		cmp		numRow, MAX_ROWS
		jae		NEWROW
		jmp		SPACING

		;Adds to row after 10 composites are printed
	NEWROW:
		call	Crlf
		mov		numRow, 0
		loop	FINDCOMP

	SPACING:
		mov		ECX, numSpace
		cmp		currentNum, 10
		jl		addSpaces
		dec		ECX
		cmp		currentNum,100
		jl		addSpaces
		dec		ECX
		cmp		currentNum,1000
		jl		addSpaces
		dec		ECX


	addSpaces:
		
		;loop through based on ecx printing a space for each loop
		;this aligns the output
		mov			EDX, OFFSET space
		call	WriteString
		loop	addSpaces

	;This functions resets the count for the loop
	resetCount:
		mov			ECX, num_of_comp
		inc			currentNum
		loop	FINDCOMP
		

ret
showComposites ENDP

;**************************************************
;procedure: isComposite
;This procedure checks to see if the number is 
; a compostie number. It works by dividing the num
;by 2 to start. Then if that does not work the divisor
;is increased by 1 untill the divisor and the number 
;are equal. If the divisor and number are equal then
;the number is not a composite. The number is incrimented
;by one and the divisor starts at 2 again.
;Recieves: none
;Return: none
;PreConditions: None
;Regs: EBX, EAX, EDX, ECX
;********************************************************
isComposite PROC

	;This functions sets up the varaibels to test for composite numbers
	SETUP:

		;first set the divisor to 2
		mov			divisor, 2
		mov			EBX, divisor

		;move the number to the eax
		mov			EAX, currentNum
		mov			testNum, EAX

	TESTING:
		
		;first divide by divisor and check for remainder
		mov			EAX, testNum
		mov			EDX, 0
		cdq
		div			divisor
		cmp			EDX,0 ;if there is a remainder then the number is not a composite
		je			FOUND

		;if the remainder is not zero we need to try a different divisor
		inc			divisor
		mov			EAX, testNum
		cmp			EAX, divisor
		jg			TESTING
		inc			currentNum
		jmp			SETUP


	FOUND:
		;mov		ECX, num_of_comp
		ret

isComposite ENDP


;*********************************************************************
;Procedure: Farewell
;This procedure prints a goodbye message to the user
;Recieves: None
;Returns: None
;PreConditions: None
;Regs: EDX
;***************************************************************
farewell PROC

	mov			EDX,OFFSET goodbye
	call	Crlf
	call	WriteString
	call	Crlf

	ret
farewell ENDP


END main

