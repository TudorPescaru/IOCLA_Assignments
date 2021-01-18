section .text
    global i_vector_op
    global i_vector_op_avx

i_vector_op:
    push rbp
    mov rbp, rsp

    ; I'll use rdx below, so I copy its value in r9
    ; Also, loop changes the value of rcx, so I make a copy in r10
    mov r9, rdx
    mov r10, rcx

; I square each element of A and place the result in C
square_loop:
    mov eax, [rdi + 4 * rcx - 4]
    mov edx, eax
    mul edx
    mov [r9 + 4 * rcx - 4], eax
    loop square_loop

    mov rcx, r10

; I multiply each element of B with 2, and add it to C
x2_loop:
    mov eax, [rsi + 4 * rcx - 4]
    mov edx, 2
    mul edx
    add [r9 + 4 * rcx - 4], eax
    loop x2_loop

    leave
    ret

i_vector_op_avx:
    ; Optimize the code above
    push rbp
    mov rbp, rsp

    ; Save values stored in rdx and rcx for later use
    mov r9, rdx
    mov r10, rcx

    ; Multiply the number of integers by 4 to get number of bytes
    mov rax, r10
    mov rdx, 4
    mul rdx
    mov r10, rax

    ; Start from processing from 0
    mov rcx, 0

; Compute 8 elements from C at a time
compute_loop:
	; Load into rax start address of A and move pointer by rcx bytes
	mov rax, rdi
	add rax, rcx

	; Load 8 elements from A into a __m256i vector
	vmovdqu ymm0, [rax]
	; Convert the vector of integers to float vector to perform multiplication
	vcvtdq2ps ymm1, ymm0
	; Multiply the vector by itself to get it's squared version
	vmulps ymm2, ymm1, ymm1
	; Convert the resulting vector back to vector of ints
	vcvtps2dq ymm2, ymm2

	; Load into rax start address of B and move pointer by rcx bytes
	mov rax, rsi
	add rax, rcx

	; Load 8 elements from A into a __m256i vector
	vmovdqu ymm0, [rax]
	; Add the vector to itself to multiply it by 2
	vpaddd ymm1, ymm0, ymm0

	; Add the squared vector and times two vector
	vpaddd ymm3, ymm2, ymm1

	; Load into rax start address of C and move pointer by rcx bytes
	mov rax, r9
	add rax, rcx

	; Store the final result vector into C
	vmovdqu [rax], ymm3

	; Increment rcx by 32 to process next 8 elements
	add rcx, 32
	cmp rcx, r10
	jl compute_loop	

    leave
    ret