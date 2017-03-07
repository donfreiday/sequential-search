; assignment5.asm - CISC225 Assignment 5 (Sequential Search)
; Don Freiday
; 3/7/2017

; Also include a test program that demonstrates that the function works. The test program should output
; all values in the test array, prompt for a target value, then display either the array position in which the
; target value was found, or a message saying that the value was not found


INCLUDE Irvine32.inc

ExitProcess proto,dwExitCode:dword

.code
main proc

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

search proc

	ret
search endp


end main