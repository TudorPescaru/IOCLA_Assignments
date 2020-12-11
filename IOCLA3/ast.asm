
section .data
    delim:  db " ", 0
    idx:    dd 0
    len:    dd 0
    neg:    db 0
    pntr:   dd 0
    added:  dd 0

section .bss
    root    resd 1
    NULL    equ 0

section .text

extern check_atoi
extern print_tree_inorder
extern print_tree_preorder
extern evaluate_tree
extern strtok
extern strlen
extern strcpy
extern calloc
extern printf

global create_tree
global iocla_atoi

iocla_atoi:
    push    ebp
    mov     ebp, esp

; Save register state
    push    ebx
    push    ecx
    push    edx

    mov     ebx, [ebp + 8]

; Calculate length of number string
    push    ebx
    call    strlen
    add     esp, 4

; Store length
    mov     [len], eax

; Initialize number value and counter and set negative indicator to 0
    mov     eax, 0
    mov     ecx, 0
    mov     dword [neg], 0
    xor     edx, edx
; Check if number is negative
    cmp     byte [ebx], '-'
    jne     poz

    mov     dword [neg], 1
    inc     ecx

poz:
; Multiply current number by 10
    xor     edx, edx
    mov     [idx], ecx
    mov     ecx, 10
    mul     ecx
    xor     edx, edx
    mov     ecx, [idx]

; Add curent digit to number
    mov     dl, byte [ebx + ecx]
    sub     dl, 48
    add     eax, edx

; Move to next digit
    inc     ecx
    cmp     ecx, [len]
    jl      poz

; Check if number needs to be converted to negative
    cmp     dword [neg], 1
    jne     atoi_end

; Subtract number from 0 to get negative
    mov     ecx, eax
    mov     eax, 0
    sub     eax, ecx

atoi_end:
; Restore register states 
    pop     edx
    pop     ecx
    pop     ebx

    leave
    ret

create_tree:
    push    ebp
    mov     ebp, esp
    push    ebx
    push    ecx
    push    edx
    
    mov     ebx, [ebp + 8]

; Get first word in string
    push    delim
    push    ebx
    call    strtok
    add     esp, 8

; Check if string is empty
    test    eax, eax
    je      tree_end
    
; Store pntr to current word
    mov     [pntr], eax

; Allocate memory for root
    push    1
    push    12
    call    calloc
    add     esp, 8
    mov     [root], eax

; Calculate len of word
    mov     eax, [pntr]
    push    eax
    call    strlen
    add     esp, 4
    
; Allocate memory for word in root
    push    1
    push    eax
    call    calloc
    add     esp, 8
    mov     edx, [root]
    mov     [edx], eax

; Copy word to root data
    mov     eax, [pntr]
    mov     edx, [edx]
    push    eax
    push    edx
    call    strcpy
    add     esp, 8

; Restore word pntr
    mov     eax, [pntr]

string_loop:
; Iterate over rest of words
    push    delim
    push    NULL
    call    strtok
    add     esp, 8

; Check if end of string has been reached
    test    eax, eax
    je      tree_end
    
; Save current word
    mov     [pntr], eax
    
; Set added state to 0
    mov     ecx, 0
    mov     [added], ecx
    
; Add node recursively
    push    eax
    push    dword [root]
    call    add_node
    add     esp, 8
    
; Restore current word
    mov     eax, [pntr]
    
    jmp     string_loop

tree_end:
    mov     eax, [root]
    pop     edx
    pop     ecx
    pop     ebx

    leave
    ret

add_node:
    push    ebp
    mov     ebp, esp
    push    ebx
    push    ecx
    push    edx

; Check if current node is null
    cmp     dword [ebp + 8], 0
    je      return

; Check if node contains number
    mov     eax, [ebp + 8]
    mov     eax, [eax]

; Check if node contains string larger than 1
    push    eax
    call    strlen
    add     esp, 4
    cmp     eax, 1
    jg      return

; If string length is 1 check if it is number
    mov     eax, [ebp + 8]
    mov     eax, [eax]
    movzx   eax, byte [eax]
    cmp     al, 48
    jge     return
    
; Call left
    mov     ebx, [ebp + 12]
    mov     eax, [ebp + 8]
    mov     eax, [eax + 4]
    push    ebx
    push    eax
    call    add_node
    add     esp, 8

; Call right
    mov     ebx, [ebp + 12]
    mov     eax, [ebp + 8]
    mov     eax, [eax + 8]
    push    ebx
    push    eax
    call    add_node
    add     esp, 8

    mov     ecx, [added]
    cmp     ecx, 1
    je      return

; Check if we can add to left
    mov     eax, [ebp + 8]
    mov     eax, [eax + 4]
    test    eax, eax
    jne     right

; Allocate memory for new node
    push    1
    push    12
    call    calloc
    add     esp, 8
    mov     ebx, [ebp + 8]
    mov     [ebx + 4], eax
    mov     ebx, [ebx + 4]

; Calculate len of word
    mov     eax, [ebp + 12]
    push    eax
    call    strlen
    add     esp, 4

; Allocate memory for word in root
    push    1
    push    eax
    call    calloc
    add     esp, 8
    mov     [ebx], eax
    
; Copy word to node data
    mov     eax, [ebp + 12]
    mov     ebx, [ebx]
    push    eax
    push    ebx
    call    strcpy
    add     esp, 8
    mov     ecx, 1
    mov     [added], ecx
    jmp     return

right:
; Check if we can add to right
    mov     eax, [ebp + 8]
    mov     eax, [eax + 8]
    test    eax, eax
    jne     return
    
; Allocate memory for new node
    push    1
    push    12
    call    calloc
    add     esp, 8
    mov     ebx, [ebp + 8]
    mov     [ebx + 8], eax
    mov     ebx, [ebx + 8]

; Calculate len of word
    mov     eax, [ebp + 12]
    push    eax
    call    strlen
    add     esp, 4

; Allocate memory for word in root
    push    1
    push    eax
    call    calloc
    add     esp, 8
    mov     [ebx], eax

; Copy word to node data
    mov     eax, [ebp + 12]
    mov     ebx, [ebx]
    push    eax
    push    ebx
    call    strcpy
    add     esp, 8
    mov     ecx, 1
    mov     [added], ecx

return:
    pop     edx
    pop     ecx
    pop     ebx
    leave
    ret

