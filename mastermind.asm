;Angeline Vu 

;external C functions
extern scanf
extern printf

;generate random number
extern genrand_int31
extern init_genrand
extern time

extern strcpy

;initialized variables
SECTION .data
	intro:	db 10, 9, 9, "- M A S T E R M I N D -", 10, 10, "Using hex digits [0-9a-f], deduce the 6 digit password.", 10, 10, "    X: a digit entered is in the correct position", 10, "    0: a digit entered is in the wrong position", 10, 10, "Ensure only 6 digits per guess. You have 20 attempts.", 0
	win:	db 10, "Good job, Mastermind. You entered the correct password.", 10, 0
	lose:	db 10, "You are no Mastermind. Better luck next time. Password: %s", 10, 0
	try:	db 10, 10, "Attempt #%d: ", 0
	alpha:	db "0123456789abcdef", 0

	c_str:	db " %c", 0
	f_str:	db "%s", 0

	X:	db "X", 0
	zero:	db "0", 0
	
	pw:	db "      ", 0
	guess:	db "      ", 0

;uninitialized variables
SECTION .bss
	input:	resb 1
	p_flag:	resb 7 * 8	;flags for password
	g_flag: resb 7 * 8	;flags for guess

SECTION .text
	global main
	
;	main function 
	main:
		push ebp		;set up stack frame
		mov ebp, esp

		push dword 0		;seed rand
		call time
		add esp, 4
		push eax
		call init_genrand	;init_genrand(time(0))
		add esp, 4

		push intro
		call printf
		add esp, 4

		xor ebx, ebx		;counter

	.gen_key:
		cmp ebx, 6
		jge .guess

		call genrand_int31	;rand num in eax
		xor edx, edx		;clear edx
		mov ecx, 16		;ecx = 16
		cdq
		idiv ecx		;remainder in edx

		movzx eax, byte [alpha + edx]	;address + remainder * 8

		mov [pw + ebx], al	;insert char into pw array

		inc ebx
		jmp .gen_key	

	.guess:
		;push pw
		;push f_str
		;call printf
		;add esp, 8

		xor edi, edi

	.loop:
		cmp edi, 20		;20 attempts
		jge .lose

		inc edi

		push edi
		push try
		call printf
		add esp, 8
		
		xor ebx, ebx
		jmp .input

	.input:				;take in input, account for whitespace
		cmp ebx, 6		;6 characters
		jge .check

		lea eax, [input]
		push eax
		push c_str
		call scanf		;scanf(" %c", &input)
		add esp, 8

		movzx eax, byte [input]	;mov character into guess array 
		mov [guess + ebx], al	;charaacter is in small reg al

		inc ebx
		jmp .input


	.check:
		call resetflags

		call rightposi
		cmp eax, 1
		je .win

		call wrongposi
		jmp .loop

	.win:
		push win
		call printf
		add esp, 4
		jmp .end

	.lose:
		push pw
		push lose
		call printf
		add esp, 4

	.end:
		mov esp, ebp
		pop ebp

		mov eax, 0
		ret

	;reset p_flags and g_flags
	resetflags:	
		xor ebx, ebx

	.loop:
		cmp ebx, 6
		jge .end

		mov dword [p_flag + ebx], 0		;set each index to 0
		mov dword [g_flag + ebx], 0

		inc ebx
		jmp .loop

	.end:	
		mov eax, 0
		ret

;	check for right digit, right position
	rightposi:		
		xor ebx, ebx	;counter
		xor edx, edx	;count
	
	.loop:
		cmp ebx, 6
		je .print

		mov al, byte [pw + ebx]		;compare chars
		cmp al, byte [guess + ebx]
		je .case
	.ret:
		inc ebx		;++counter
		jmp .loop
		
	.case:
		inc edx		;++count
		mov byte [p_flag + ebx], 1	;set flags to true
		mov byte [g_flag + ebx], 1
		jmp .ret

	.print:
		cmp edx, 6
		je .same

		mov ebx, edx

	.ploop:
		cmp ebx, 0	;print the count of X
		jle .end

		push X
		push f_str
		call printf
		add esp, 8

		dec ebx
		jmp .ploop

	.end:	
		mov eax, 0
		ret
	.same:
		mov eax, 1
		ret

;	check for right digit, wrong position
	wrongposi:
		xor ebx, ebx	;outer loop counter

	.loop1:
		cmp ebx, 6
		jge .end

		cmp byte [p_flag + ebx], 0	;flag not set?
		je .wloop2

	.ret1:
		inc ebx		;++big_counter
		jmp .loop1

	.wloop2:
		xor edx, edx	;inner loop counter

	.loop2:
		cmp edx, 6	
		jge .ret1

		mov al, byte [pw + ebx]		;check if same char
		cmp al, [guess + edx]
		je .print

	.ret2:
		inc edx		;++small_counter
		jmp .loop2

	.print:
		cmp byte [g_flag + edx], 0	;flag not set?
		jne .ret2

		mov dword [g_flag + edx], 1	;set g_flag[j] to 1

		push zero	;print the zero
		push f_str
		call printf
		add esp, 8

		jmp .ret1

	.end:	
		mov eax, 0
		ret

