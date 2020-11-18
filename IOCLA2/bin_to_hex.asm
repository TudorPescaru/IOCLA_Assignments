%include "io.mac"

section .text
    global bin_to_hex
    extern printf

section .data
    hex_digits: db '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'
    hex_index: dd 0
    len: dd 0
    remainder: dd 0
    counter: db 0
    keep_index: dd 0

bin_to_hex:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]      ; hexa_value
    mov     esi, [ebp + 12]     ; bin_sequence
    mov     ecx, [ebp + 16]     ; length
    ;; DO NOT MODIFY

    mov dword [len], ecx
    xor eax, eax
    xor ebx, ebx
    mov dword [hex_index], 0

divide_len:
    sub ecx, 4
    cmp ecx, 4
    jge divide_len

    mov dword [remainder], ecx
    mov ecx, 0

    cmp dword [remainder], 0
    je multiple_four

complete_remainder:
    mov al, byte [esi + ecx]

    sub al, 48
    shl bl, 1
    add bl, al

    inc ecx
    cmp ecx, dword [remainder]
    jne complete_remainder

    mov dword [keep_index], ecx
    mov ecx, dword [hex_index]
    mov al, byte [hex_digits + ebx]
    mov byte [edx + ecx], al
    mov ecx, dword [keep_index]
    inc dword [hex_index]
    xor bl, bl

multiple_four:
    mov al, byte [esi + ecx]

    sub al, 48
    shl bl, 1
    add bl, al

    inc byte [counter]
    cmp byte [counter], 4
    jne continue_loop

    mov byte [counter], 0

    mov dword [keep_index], ecx
    mov ecx, dword [hex_index]
    mov al, byte [hex_digits + ebx]
    mov byte [edx + ecx], al
    mov ecx, [keep_index]
    inc dword [hex_index]
    xor bl, bl

continue_loop:
    inc ecx
    cmp ecx, dword [len]
    jl multiple_four

    mov ecx, dword [hex_index]
    mov byte [edx + ecx], 10

    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY

