%include "io.mac"

section .text
    global vigenere
    extern printf

section .data
    key_len: dd 0
    plaintext_len: dd 0

vigenere:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]      ; ciphertext
    mov     esi, [ebp + 12]     ; plaintext
    mov     ecx, [ebp + 16]     ; plaintext_len
    mov     edi, [ebp + 20]     ; key
    mov     ebx, [ebp + 24]     ; key_len
    ;; DO NOT MODIFY

; Make sure eax is 0 before using it
    xor eax, eax

; Subtract 'A' from each char in key to get add value

convert_key:
    sub byte [edi + eax], 'A'
    inc eax
    cmp eax, ebx
    jl convert_key

; Copy key and plaintext lengths to use ecx and ebx as counters
    mov [key_len], ebx
    mov ebx, 0
    mov [plaintext_len], ecx
    mov ecx, 0

; Loop to encrypt plaintext

encrypt:
    mov al, byte [esi + ecx] 

; Check if char is upper-case letter
    cmp al, 'A'
    jl bad_char
    cmp al, 'Z'
    jle good_upper_char

; Char is not upper-case, check if it is lower-case letter
    cmp al, 'a'
    jl bad_char
    cmp al, 'z'
    jg bad_char

; Char is lower-case letter so encrypt

good_lower_char:
    add al, byte [edi + ebx]
; Move to next char in key or back to first if needed
    inc ebx
    cmp ebx, [key_len]
    jl check_overflow_lower
    mov ebx, 0

; Check if char goes outside a-z range 

check_overflow_lower:
    cmp ax, 'z'
    jg overflow
    mov byte [edx + ecx], al
; Everything is fine, move on
    jmp next_char
   
; Char is upper-case letter so encrypt 

good_upper_char:
    add al, byte [edi + ebx]
    inc ebx
    cmp ebx, [key_len]
    jl check_overflow_upper
    mov ebx, 0

; Check if char goes outside A-Z range

check_overflow_upper:
    cmp ax, 'Z'
    jg overflow
    mov byte [edx + ecx], al
; Everything is fine, move on
    jmp next_char

; Reduce char back to a-z/A-Z range

overflow:
    sub ax, 26
    mov byte [edx + ecx], al
    jmp next_char

; Char is not letter so no need to modify

bad_char:
    mov byte [edx + ecx], al

; Move on to next char if possible

next_char:
    inc ecx
    cmp ecx, [plaintext_len]
    jl encrypt

    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY

