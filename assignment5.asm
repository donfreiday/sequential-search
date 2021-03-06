;-----------------------------------------------------------------------------------------------------
; assignment5.asm - CISC225 Assignment 5 (Sequential Search)
; Don Freiday
; 3/7/2017
;-----------------------------------------------------------------------------------------------------

INCLUDE Irvine32.inc

ExitProcess proto,dwExitCode:dword

.data
array SDWORD 2,3,-10,0,0FFh,-20,0,50,42
prompt BYTE "Please enter an dword value to search for: ",0
valNotFound BYTE "Value was not found.",0
valFound BYTE "Value found at index ",0

.code
main proc
	; Set up parameters for Search and PrintArray procedures
	mov esi,offset array ; Procedures expect esi to contain the address of the array
	mov ecx,lengthof array ; Procedures expect ecx to contain the number of elements in the array
	
	call PrintArray

	; Prompt the user to input a value to search for
	mov edx,offset prompt
	call WriteString
	call ReadInt

	call Search

	; Print message if value is not found, otherwise print index at which it was found
	jnz notfound 
	mov edx,offset valFound
	call WriteString
	mov eax,ecx ; Index of found value should be in ecx; move to eax for WriteInt procedure
	call WriteInt
	jmp quit
notfound:
	mov edx,offset valNotFound
	call WriteString
quit:
	call CrLf
	call CrLf
	call WaitMsg
	invoke ExitProcess,0 
main endp

;-----------------------------------------------------------------------------------------------------
; Search:  procedure to carry out a sequential search on a double-word array.
; Expects:
;	ESI � The base address of the array to be search.
;	EAX � The target value for the search.
;	ECX � The length of the array.
; Returns:
;	EDI � The address of the array element in which the target value was found. If the target value
;		was not found, return the address of the double-word that immediately follows the last element
;		of the array.
;	ECX � The position (array-based index) in which the target value was found. If the target value
;		was not found, return the original length of the array that was given.
;	ZF - If the target was found, Zero Flag will be set. If not found, the Zero Flag will be clear.
;-----------------------------------------------------------------------------------------------------
Search proc uses eax esi
	push ecx ; Preserve length of the array
L1:
	; Loop through array, checking each index position for desired value
	cmp eax,[esi] ; Compare target value to value at current address in array
	je found ; If value is found, handle it
	add esi,type array ; Increment address in esi by the size of one array element
	loop L1	
notfound:
	; Clear ZF, return length of array in ecx. Label is for clarity, not neccessary.
	inc ecx ; Clear the zero flag, ecx was just used as counter for the loop instruction and should be >= 0
	pop ecx ; Return the length of the array that was given initially in ecx
	ret ; 'Uses' directive will cause the assembler to insert pop eax and pop esi before ret, preserving their values
found: 
	; Return address of found value in edi, index in ecx, and set ZF
	mov edi,esi ; Move address of found value to edi
	pop eax ; Pop size of array into eax
	sub eax,ecx ; Calculate index of found value
	mov ecx,eax ; Move index of found value into ecx
	xor eax,eax ; Set zero flag
	ret ; 'Uses' directive will cause the assembler to insert pop eax and pop esi before ret, preserving their values
Search endp

;-----------------------------------------------------------------------------------------------------
; PrintArray: Prints an array of integers
; Expects:
;	ESI � The base address of the array
;	ECX � The length of the array
; Returns:
;	Nothing
;-----------------------------------------------------------------------------------------------------
PrintArray proc uses eax esi ecx
L1:
	mov eax,[esi] ; Move the value at address contained in esi to eax
	call WriteInt ; Display the value in eax
	mov eax,' ' ; Separate each value displayed with a ' ' character
	call WriteChar
	add esi,type array ; Point esi at the next array element's address
	loop L1
	call CrLf
	ret
PrintArray endp

end main