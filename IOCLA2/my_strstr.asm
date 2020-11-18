%include "io.mac"

section .text
    global my_strstr
    extern printf

my_strstr:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edi, [ebp + 8]      ; substr_index
    mov     esi, [ebp + 12]     ; haystack
    mov     ebx, [ebp + 16]     ; needle
    mov     ecx, [ebp + 20]     ; haystack_len
    mov     edx, [ebp + 24]     ; needle_len
    ;; DO NOT MODIFY

; Load haystack_len + 1 into return parameter
    mov dword [edi], ecx
    inc dword [edi]

; Loop for parsing characters in haystack from back to front

haystack_loop:
; Reset length of needle
    mov edx, [ebp + 24]

; Loop for parsing characters in needle from back to front

needle_loop:
; Get current characters in both needle and haystack
    mov al, [ebx + edx - 1]
    mov ah, [esi + ecx - 1]
; Compare characters and move on in haystack if not equal
    cmp al, ah
    jne continue_loop 

; If characters are equal decrease both indices if possible
    dec ecx
; No more characters in haystack, jump to end loop
    cmp ecx, 0
    jle continue_loop
    dec edx
; No more characters in needle, found needle in haystack
    cmp edx, 0
    jg needle_loop

; Record start position of needle sequence
    mov dword [edi], ecx
; Readjust ecx to accomodate two consecutive sequences
    inc ecx

; Keep looping through haystack chars if possible

continue_loop:
    loop haystack_loop

    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY

