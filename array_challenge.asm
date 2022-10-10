%include "/usr/local/share/csc314/asm_io.inc"

; Memory like a pointer
; [L1] is the same as *L1 in C // basically grabbing the memory address

segment .data

	str1	db		"I<3CSC314",0
	str2	db		"Winner winner!",10,0
	str3	db		"Nope :(",10,0

segment .bss

	buff1	resd	10
	buff2	resb	10

segment .text
	global  asm_main

asm_main:
	push	ebp
	mov		ebp, esp
	; ********** CODE STARTS HERE **********

	mov		edi, buff1			; sets buff1 to destination
	mov		ecx, 10				; sets length to ten
	cld
	loop_1:
		call	read_int
		cmp		eax, 1000
		jl		fail
		stosd					; stores dword from EAX and puts it in [EDI]
		dec		ecx
	cmp		ecx, 0
	jg		loop_1

	mov		ebx, 256
	mov		esi, buff1			; sets buff1 to source
	mov		edi, buff2			; sets buff2 to desination
	mov		ecx, 10				; sets length to ten
	cld							; sets flag for incrementing esi/edi
	loop_2:
		lodsd					; takes the dword from [ESI] and puts it in EAX
		cdq						; conv dword to qword - ext sign bit of EAX into the EDX reg
		idiv	ebx
		mov		al, dl
		stosb					; take the byte from AL, put it in [EDI]
		dec		ecx
	cmp		ecx, 0
	jg		loop_2

	; I<3CSC314 seems to be important
	; in hexadecimal is 
	; I is 49, < is 3C, 3 is 33, C is 43, S is 53, 1 is 31, 4 is 34
	; option number 1 could be: 493C435343333134
	; option number 2 could be: 431333343534C394
	
	; possibly binary options
	; in decimal is 
	; I is 73, < is 60, 3 is 51, C is 67, S is 83, 1 is 49, 4 is 52
	
	; I<3CSC314 in binary:
	; 01001001 00111100 00110011 01000011 01010011 01000011 00110011 00110001 00110100

	mov		esi, buff2			; sets buff2 to source
	mov		edi, str1			; sets destination to str1
	mov		ecx, 10				; sets length to 10
	cld							; sets flag
	repe	cmpsb				; cmpsb compares byte address at DS:(E)SI with ES:(E)DI and sets flags
	jne		fail
		mov		eax, str2
		jmp		end
	fail:
		mov		eax, str3
	end:
	call	print_string

	; *********** CODE ENDS HERE ***********
	mov		eax, 0
	mov		esp, ebp
	pop		ebp
	ret

