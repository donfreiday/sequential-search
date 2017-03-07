; assignment5.asm - CISC225 Assignment 5 (Sequential Search)
; Don Freiday
; 3/7/2017

; Also include a test program that demonstrates that the function works. The test program should output
; all values in the test array, prompt for a target value, then display either the array position in which the
; target value was found, or a message saying that the value was not found


INCLUDE Irvine32.inc

ExitProcess proto,dwExitCode:dword

.data
array SDWORD 1,2,3,4
prompt BYTE "Please enter an dword value to search for: ",0
valueNotFound BYTE "Value was not found.",0
valueFound BYTE "The value was found at index ",0

.code
main proc
	; Setup parameters for Search and PrintArray procedures
	mov esi,offset array ; search expects esi to contain the address of the array
	mov ecx,lengthof array ; search expects ecx to contain the number of elements in the array
	
	; Print the array
	call PrintArray

	; Prompt the user to input a value to search for
	mov edx,offset prompt
	call WriteString
	call ReadInt

	
	
	call Search
	jnz notfound ; Print message if value is not found, otherwise print index at which it was found
	mov edx,offset valueFound
	call WriteString
	mov eax,ecx
	call WriteInt
	jmp done
notfound:
	mov edx,offset valueNotFound
	call WriteString
done:
	call CrLf
	call CrLf
	call WaitMsg

	invoke ExitProcess,0 
main endp


; search:  procedure to carry out a sequential search on a double-word array.
;
; Expects:
; ESI – The base address of the array to be search.
; EAX – The target value for the search.
; ECX – The length of the array.
;
; Returns:
; EDI – The address of the array element in which the target value was found. If the target value
; was not found, return the address of the double-word that immediately follows the last element
; of the array.
; ECX – The position (array-based index) in which the target value was found. If the target value
; was not found, return the original length of the array that was given.
; 
; In addition, if the target was found, the procedure should set the Zero Flag. If not found, the Zero Flag
; should be clear.
Search proc
	push eax
	push esi
	push ecx
	L1:
		cmp eax,[esi]
		je found
		add esi,type array
		loop L1

	; Not found, clear zero flag and return length of array in ecx
	mov eax,1
	cmp eax,0
	pop ecx ; return the original length of the array that was given in ecx
	jmp preserve 

	; Found, return address in edi, index in ecx, and set the zero flag
found:
	mov edi,esi ; Address of found value in edi

	pop eax ; Pop size of array into eax
	sub eax,ecx ; Calculate index of found value
	mov ecx,eax ; Index of found value in ecx
	
	; Set zero flag
	mov eax,0
	cmp eax,0
	
	; Preserve registers
preserve:	
	pop esi
	pop eax
	ret
Search endp

; Takes offset of array in esi, length of array in ecx
PrintArray proc
	push eax
	push esi
	push ecx
L1:
	mov eax,' '
	call WriteChar
	mov eax,[esi]
	call WriteInt
	add esi,type array
	loop L1
	
	call CrLf

	pop ecx
	pop esi
	pop eax
	ret
PrintArray endp

end main