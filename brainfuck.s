.bss

counter:    .skip 8

buffer:     .skip 30000

.text

usage:      .asciz "USAGE: ./brainfuck <filename>\n"
failed:     .asciz "Can't open file '%s'\n"


.global     main

main:
    pushq   %rbp
    movq    %rsp, %rbp

    cmpq    $2, %rdi
    jne     wrong_args 

    movq    8(%rsi), %rdi
	call    read_file

    cmpq    $0, %rax
    jle     fail

    movq    %rax, %rdi
    call    brainfuck

end_main:
    movq    %rbp, %rsp
    popq    %rbp

    movq    $0, %rdi
    call    exit

brainfuck:
    pushq   %rbp
    movq    %rsp, %rbp

    movq    $buffer, %rsi
    addq    $15000, %rsi

start_loop:
    movb    (%rdi), %cl

    test    %cl, %cl
    je      end_brainfuck       

    cmpb     $'>', %cl
    je      increment

    cmpb     $'<', %cl
    je      decrement

    cmpb     $'+', %cl
    je      increment_value

    cmpb     $'-', %cl
    je      decrement_value

    cmpb     $'.', %cl
    je      output_byte 

    cmpb     $',', %cl
    je      input_byte

    cmpb     $'[', %cl
    je      start_while

    cmpb     $']', %cl
    je      stop_while

end_loop:
    incq    %rdi

    jmp     start_loop

increment:
    incq    %rsi

    jmp     end_loop

decrement:      
    decq    %rsi

    jmp     end_loop

increment_value:
    incb    (%rsi)

    jmp     end_loop

decrement_value:
    decb    (%rsi)

    jmp     end_loop

output_byte:
    pushq   %rdi
    pushq   %rsi

    movzbq  (%rsi), %rdi
    
    call    putchar

    popq    %rsi
    popq    %rdi

    jmp     end_loop

input_byte:
    pushq   %rdi
    pushq   %rsi

    movq    $0, %rax            
    movq    $1, %rdx
    subq    $16, %rsp        
    movq    $0, %rdi
    leaq    (%rsp), %rsi

    syscall

    movb    (%rsp), %cl
    addq    $16, %rsp

    popq    %rsi
    popq    %rdi

    movb    %cl, (%rsi)

    jmp     end_loop

start_while:
    movb    (%rsi), %cl

    test    %cl, %cl
    je      skip_while

    pushq   %rdi
    subq    $8, %rsp

    jmp     end_loop

skip_while:
    movq    $0, counter

start_count_loop:
    movb    (%rdi), %cl

    cmpb    $'[', %cl
    je      increase_counter

    cmpb    $']', %cl
    je     decrease_counter

end_count_loop:
    cmpq    $0, counter
    je      end_loop

    incq    %rdi

    jmp     start_count_loop

increase_counter:
    incq    counter

    jmp     end_count_loop

decrease_counter:
    decq    counter

    jmp     end_count_loop

stop_while:
    movb    (%rsi), %cl

    test    %cl, %cl
    jne     return_while

    addq    $16, %rsp

    jmp     end_loop

return_while:
    movq    8(%rsp), %rdi

    jmp     end_loop    

end_brainfuck:
    movq    %rbp, %rsp
    popq    %rbp

    movq    $0, %rax
    ret


wrong_args:
    movq    $0, %rax
    movq    $usage, %rdi
    call    printf

    jmp     end_main

fail:
    movq    $0, %rax
    movq    %rdi, %rsi
    movq    $failed, %rdi
    call    printf

    jmp     end_main

read_file:
    pushq   %rbp
    movq    %rsp, %rbp

    pushq   %r12
    pushq   %r13

    movq    $2, %rax
    movq    $0, %rsi
    syscall

    movq    %rax, %r12

    cmpq    $0, %rax
    jl      end_read_file

    movq    $200, %rdi
    call    malloc 

    movq    %r12, %rdi
    movq    %rax, %r13
    movq    %rax, %rsi
    movq    $5, %rax
    syscall

    movq    %r13, %rax
    movq    48(%rax), %rdi
    movq    %rdi, %r13

    movq    %rax, %rdi
    call    free

    movq    %r13, %rdi
    addq    $64, %rdi
    call    malloc

    movq    %r13, %rdi
    addq    %rax, %rdi
    addq    $1, %rdi
    movq    $0, (%rdi)

    movq    %r12, %rdi
    movq    %rax, %rsi
    movq    $0, %rax
    movq    %r13, %rdx
    movq    %rsi, %r13
    syscall

    movq    %r13, %rax

end_read_file:
    popq    %r13
    popq    %r12

    movq    %rbp, %rsp
    popq    %rbp

    ret
