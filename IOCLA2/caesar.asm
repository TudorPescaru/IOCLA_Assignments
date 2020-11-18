%include "io.mac"

section .text
    global caesar
    extern printf

caesar:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]      ; ciphertext
    mov     esi, [ebp + 12]     ; plaintext
    mov     edi, [ebp + 16]     ; key
    mov     ecx, [ebp + 20]     ; length
    ;; DO NOT MODIFY
    
; Copy key from edi to ebx to convert to lower number
    mov ebx, edi
    cmp ebx, 26
    jg decrease_key
    jmp encrypt

; Decrement key with 26 to simulate key % 26     

decrease_key:
    sub ebx, 26
    cmp ebx, 26
    jg decrease_key
	
; Main encryption loop

encrypt:
; Copy char at ecx - 1 from plaintext
    mov al, byte [esi + ecx - 1]
    
; Check if char is upper-case letter
    cmp al, 'A'
    jl next_char
    cmp al, 'Z'
    jle good_upper_char

; Char is not upper-case, check if it is lower-case letter
    cmp al, 'a'
    jl next_char
    cmp al, 'z'
    jg next_char

; Char is lower-case letter so encrypt

good_lower_char:
; Increment using converted key
    add al, bl
; Check if char goes outside a-z range
    cmp ax, 'z'
    jg overflow
; Everything is fine, move on
    jmp next_char
	
; Char is upper-case letter so encrypt 

good_upper_char:
; Increment using converted key
    add al, bl
; Check if char goes outside A-Z range
    cmp ax, 'Z'
    jle next_char

; Reduce char back to a-z/A-Z range

overflow:
    sub ax, 26
	
; Current char was processed, add to return string

next_char:
    mov byte [edx + ecx - 1], al
    loop encrypt

    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY

