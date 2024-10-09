; Для 64-бітної версії Windows

extern ExitProcess
extern GetStdHandle
extern WriteConsoleA

section .data
	message db 'KI-232 Semenets', 0Ah, 0

section .bss
	written resq 1

section .text
global main

main:
	; Отримуємо дескриптор стандартного виводу
	mov rcx, -11 		; STD_OUTPUT_HANDLE
	call GetStdHandle 	; Зберігаємо результат
	mov r12, rax 		; Зберігаємо результат GetStdHandle в r12

	; Підготовка параметрів для WriteConsoleA
	mov rcx, r12 		; hConsoleOutput
	lea rdx, [message] 	; lpBuffer
	mov r8, 15 			; nNumberOfCharsToWrite (виправлено, додано розмір)
	lea r9, [written] 	; lpNumberOfCharsWritten
	xor eax, eax 		; Обнуляємо верхню частину rax
	push rax			; lpReserved (must be 0)
	sub rsp, 40 		; Виділяємо 32 байти для тіньового простору + 8 для push rax (виправлено)

	; Виводимо повідомлення
	call WriteConsoleA
	
	; Відновлюємо стек
	add rsp, 40 		; Відновлюємо стек (32 + 8 байтів)

	; Виходимо з програми
	xor ecx, ecx 		; exit code 0
	call ExitProcess

