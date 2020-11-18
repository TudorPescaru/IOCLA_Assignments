%include "io.mac"

section .text
    global otp
    extern printf

otp:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov edx, [ebp + 8]   ; ciphertext
    mov esi, [ebp + 12]  ; plaintext
    mov edi, [ebp + 16]  ; key
    mov ecx, [ebp + 20]  ; length
    ;; DO NOT MODIFY

    ;; Loop through string from back to front using ecx

encrypt:
    ;; Copy chars at ecx - 1 to registers
    mov al, byte [edi + ecx - 1]
    mov bl, byte [esi + ecx - 1]

    ;; XOR the two registers
    xor al, bl

    ;; Copy the resulting char to the coresponding position in edx
    mov byte [edx + ecx - 1], al
    loop encrypt

    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY

