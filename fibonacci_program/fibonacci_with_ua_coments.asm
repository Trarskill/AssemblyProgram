section .data
; рядок для введення числа
.LC0 db "Enter the Fibonacci number you want to calculate(0-93):", 0
; формат для scanf
.LC1 db "%d", 0
; повідомлення про помилку введення
.LC2 db "%s", 10, 0
; рядок для виведення результату
.LC3 db "The %dth Fibonacci number is %llu", 10, 0

section .text
global main
extern printf, scanf, __isoc99_scanf

fibonacci:
        ; зберігаємо попереднє значення базового вказівника (RBP)
        push    rbp
        ; встановлюємо нове значення RBP як поточний стековий кадр
        mov     rbp, rsp       
        ; зберігаємо регістр RBX (використовуватиметься пізніше)
        push    rbx
        ; виділяємо 24 байти на стеку для локальних змінних
        sub     rsp, 24  
        ; копіюємо значення параметра n (у регістрі EDI) у стек      
        mov     DWORD PTR [rbp-20], edi

        ; порівнюємо n з 0
        cmp     DWORD PTR [rbp-20], 0
        ; якщо n не дорівнює 0, переходимо до .L2
        jne     .L2

        ; якщо n = 0, повертаємо 0
        mov     eax, 0    
        ; переходимо до завершення функції
        jmp     .L3

.L2:
        ; порівнюємо n з 1
        cmp     DWORD PTR [rbp-20], 1
        ; якщо n не дорівнює 1, переходимо до .L4
        jne     .L4 
        ; якщо n = 1, повертаємо 1
        mov     eax, 1
        ; переходимо до завершення функції
        jmp     .L3
.L4:
        ; завантажуємо n в регістр EAX
        mov     eax, DWORD PTR [rbp-20]
        ; віднімаємо 1 від n
        sub     eax, 1
        ; передаємо n - 1 у функцію fibonacci
        mov     edi, eax
        ; викликаємо рекурсивно fibonacci(n-1)
        call    fibonacci
        ; зберігаємо результат fibonacci(n-1) у RBX
        mov     rbx, rax

        ; завантажуємо n в регістр EAX
        mov     eax, DWORD PTR [rbp-20]
        ; віднімаємо 2 від n
        sub     eax, 2
        ; передаємо n - 2 у функцію fibonacci
        mov     edi, eax
        ; викликаємо рекурсивно fibonacci(n-2)
        call    fibonacci
        ; додаємо результат fibonacci(n-2) до fibonacci(n-1)
        add     rax, rbx
.L3:
        ; відновлюємо значення RBX збереженого на стеку
        mov     rbx, QWORD PTR [rbp-8] 
        ; очищуємо стек і відновлюємо базовий вказівник
        leave
        ; повертаємо результат
        ret

main:
        ; зберігаємо попередній базовий вказівник
        push    rbp
        ; встановлюємо нове значення RBP
        mov     rbp, rsp
        ; виділяємо 16 байтів на стеку для локальних змінних
        sub     rsp, 16
        ; передаємо адресу рядка для введення в printf
        mov     edi, OFFSET FLAT:.LC0
        ; чистимо регістр EAX перед викликом
        mov     eax, 0
        ; викликаємо printf для виведення запиту
        call    printf

        ; завантажуємо адресу змінної n (на стеку) в регістр RAX
        lea     rax, [rbp-4]
        ; передаємо адресу змінної n в регістр RSI
        mov     rsi, rax
        ; передаємо формат %d в регістр EDI для scanf
        mov     edi, OFFSET FLAT:.LC1
        ; чистимо регістр EAX перед викликом
        mov     eax, 0
        ; викликаємо scanf для отримання значення n  
        call    __isoc99_scanf

        ; завантажуємо n в регістр EAX
        mov     eax, DWORD PTR [rbp-4]
        ; перевіряємо, чи n >= 0
        test    eax, eax
        ; якщо n < 0, переходимо до .L6
        js      .L6
        ; завантажуємо n в регістр EAX
        mov     eax, DWORD PTR [rbp-4]
        ; порівнюємо n з 93
        cmp     eax, 93
        ; якщо n <= 93, переходимо до .L7
        jle     .L7
.L6:
        ; виводимо повідомлення про помилку, якщо n < 0 або n > 93
        mov     edi, OFFSET FLAT:.LC2
        ; викликаємо puts для виведення рядка
        call    puts
        ; встановлюємо код помилки
        mov     eax, 1
        ; переходимо до завершення програми
        jmp     .L9
.L7:
        ; завантажуємо n в регістр EAX
        mov     eax, DWORD PTR [rbp-4] 
        ; передаємо n у функцію fibonacci
        mov     edi, eax
        ; викликаємо fibonacci(n)
        call    fibonacci     
        ; зберігаємо результат fibonacci(n) в RDX
        mov     rdx, rax

        ; завантажуємо n в регістр EAX
        mov     eax, DWORD PTR [rbp-4] 
        ; передаємо n у регістр ESI для printf
        mov     esi, eax
        ; передаємо адресу рядка для виведення результату в printf
        mov     edi, OFFSET FLAT:.LC3
        ; чистимо регістр EAX перед викликом
        mov     eax, 0        
        ; викликаємо printf для виведення результату
        call    printf

        ; встановлюємо код успішного завершення
        mov     eax, 0
.L9:
        ; очищуємо стек
        leave
        ; повертаємося з функції
        ret
