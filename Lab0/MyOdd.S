    .arch armv7-a
    .comm a, 4
    .text
    .align 2
    .section .rodata
    .align 2
input:
    .ascii "%d\0"
    .align 2
str_odd:
    .ascii "odd\n\000"
str_even:
    .ascii "even\n"

    .text
    .align 2

    .global main

main:
    push {fp, lr}
    add fp, sp, #4
    ldr r1, bridge
    ldr r0, bridge+4
    bl __isoc99_scanf
    ldr r3, bridge
    ldr r0, [r3]
    and r0, r0, #1
    cmp r0, #0
    beq even

    ldr r0, bridge+8
    bl printf
    b exit

even:
    ldr r0, bridge+12
    bl printf

exit:
    mov r0, #0
    pop {fp, pc}

bridge:
    .word a
    .word input
    .word str_odd
    .word str_even