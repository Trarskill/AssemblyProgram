; запуск через Линукс
; nasm -f elf64 -o fib.o fibanachi.asm
; gcc -no-pie -o fib_program fib.o
; ./fib_program

section .data
.LC0 db "Enter the Fibonacci number you want to calculate(0-93):", 0
.LC1 db "%d", 0
.LC2 db "%s", 10, 0
.LC3 db "The %dth Fibonacci number is %llu", 10, 0

section .text
global main
extern printf, scanf, __isoc99_scanf


fibonacci:
    push    rbp
    mov     rbp, rsp
    push    rbx
    sub     rsp, 24
    mov     DWORD [rbp-20], edi

    cmp     DWORD [rbp-20], 0
    jne     .L2
    mov     eax, 0
    jmp     .L3

.L2:
    cmp     DWORD [rbp-20], 1
    jne     .L4
    mov     eax, 1
    jmp     .L3

.L4:
    mov     eax, DWORD [rbp-20]
    sub     eax, 1
    mov     edi, eax
    call    fibonacci
    mov     rbx, rax

    mov     eax, DWORD [rbp-20]
    sub     eax, 2
    mov     edi, eax
    call    fibonacci
    add     rax, rbx

.L3:
    mov     rbx, QWORD [rbp-8]
    leave
    ret

main:
    push    rbp
    mov     rbp, rsp
    sub     rsp, 16
    mov     edi, .LC0
    xor     eax, eax
    call    printf

    lea     rax, [rbp-4]
    mov     rsi, rax
    mov     edi, .LC1
    xor     eax, eax
    call    __isoc99_scanf

    mov     eax, DWORD [rbp-4]
    test    eax, eax
    js      .L6
    mov     eax, DWORD [rbp-4]
    cmp     eax, 93
    jle     .L7

.L6:
    mov     rdi, .LC2      
    xor     eax, eax
    call    printf
    mov     eax, 1
    jmp     .L9

.L7:
    mov     eax, DWORD [rbp-4]
    mov     edi, eax
    call    fibonacci
    mov     rdx, rax

    mov     eax, DWORD [rbp-4]
    mov     esi, eax
    mov     edi, .LC3
    xor     eax, eax
    call    printf

    mov     eax, 0
.L9:
    leave
    ret
