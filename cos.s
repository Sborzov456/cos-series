    .arch   armv8-a
    .data
    .align  3
in_msg:
    .string "Enter x: "
in_format:
    .string "%lf"
lib_out:
    .string "[LIB] tan(x) = %.8g\n"
accur_msg:
    .string "Enter accuracy: "
accur_format:
    .string "%lf"
my_out:
    .string "[MY] tan(x) = %.8g\n"
file_name:
    .string "bernoulli_nums.txt"
open_format:
    .string "r"
read_format:
    .string "%lf"

const_0:
    .double 0
const_1:
    .double 1
const_4:
    .double 4
const_neg4:
    .double -4
    
    .text
    .align  2
    .global main
    .type   main, %function
    .equ    x, 16
    .equ    y, 24 //float == 32bit [offset 32+32=64]
main:
    stp     x29, x30, [sp, -32]!
    mov     x29, sp
//INPUT----------------
    adr     x0, in_msg
    bl      printf
    adr     x0, in_format
    add     x1, x29, x
    bl      scanf
//---------------------

//LIB OUT--------------
    ldr     d0, [x29, x]
    bl      tan
    str     d0, [x29, y]

    adr     x0, lib_out
    ldr     d0, [x29, y]
    bl      printf
//--------------------

//MY OUT--------------
    ldr     d0, [x29, x]
    bl      my_tan
    str     d0, [x29, y]

    adr     x0, my_out
    bl      printf
//-------------------
    ldp     x29, x30, [sp], 32
    ret
    .size   main, .-main

    .type   my_tan, %function
    .equ    accuracy, 16
    .equ    file_ptr, 24
    .equ    ber_num, 32
    .equ    series_member, 40
    .equ    iterator, 48
    .equ    x, 56
    .equ    sum, 64
my_tan:
/*
    d0 - input
    d0 - output
*/

0:
    stp     x29, x30, [sp, -72]! //offset 16[x, y] + 16[x29, x30] = 32
    mov     x29, sp
    str     d0, [x29, x]

1:
//GET ACCURACY-----------------
    adr     x0, accur_msg
    bl      printf
    adr     x0, accur_format
    add     x1, x29, accuracy
    bl      scanf
    ldr     d6, [x29, accuracy]
//-----------------------------

//OPEN BERNOULLI NUMS FILE------
    adr     x0, file_name
    adr     x1, open_format
    bl      fopen
    str     x0, [x29, file_ptr]
//-----------------------------

//INITIAL DATA----------------
    adr     x0, const_0
    adr     x1, const_1
    adr     x2, const_4
    adr     x3, const_neg4
    ldr     d1, [x1]
    ldr     d7, [x2]
    ldr     d8, [x3]
    ldr     d11, [x0]
    str     d11, [x29, sum]
    mov     x0, #1
//--------------------------
    b       2f
/*
    x10 - iterator
    d1 - series member
    d2 - bernoulli nums
    d3 - (-4)^n
    d4 - 1 - (4^n)
    d5 - (2n)!
    d6 - accuracy
    d7 - 4 const
    d8 - -4 const
    d9 - 1 const
    d10 - factorial iterator
    d11 - sum
    d12 - x^(2n-1)
*/

2:
    fcmp    d1, d6 //member < accuracy
    b.le    4f
    adr     x1, const_1
    ldr     d1, [x1]
    b       3f
3:
    str     x0, [x29, iterator]
    str     d1, [x29, series_member]
    adr     x1, const_0
    ldr     d2, [x1]
    bl      get_bernoulli_num
    ldr     d1, [x29, series_member]
    ldr     x0, [x29, iterator]
    fmul    d1, d1, d2

    adr     x1, const_1
    ldr     d3, [x1]
    bl      pow
    fmul    d1, d1, d3

    adr     x1, const_1
    ldr     d4, [x1]
    bl      sub_and_pow
    fmul    d1, d1, d4

    adr     x1, const_1
    ldr     d5, [x1]
    adr     x1, const_1
    ldr     d9, [x1]
    adr     x1, const_1
    ldr     d10, [x1]
    bl      factorial
    fdiv    d1, d1, d5

    ldr     d0, [x29, x]
    adr     x1, const_1
    ldr     d12, [x1]
    bl      pow_x
    fmul    d1, d1, d12

    ldr     d11, [x29, sum]
    fadd    d11, d11, d1
    str     d11, [x29, sum]

    add     x0, x0, #1
    b       2b

4:
    fmov    d0, d11
    ldp     x29, x30,[sp], 72
    ret
    .size   my_tan, .-my_tan

    .type get_bernoulli_num, %function
get_bernoulli_num:
    str     x30, [sp, -8]!
    ldr     x0, [x29, file_ptr]
    adr     x1, read_format
    add     x2, x29, ber_num
    bl      fscanf
    ldr     d2, [x29, ber_num]
    ldr     x30, [sp], 8
    ret
    .size   get_bernoulli_num, .-get_bernoulli_num

    .type   pow, %function
pow:
    mov     x2, #0
0:
    cmp     x2, x0
    b.ge    1f
    fmul    d3, d3, d8
    add     x2, x2, #1
    b       0b
1:
    ret
    .size   pow, .-pow

    .type   sub_and_pow, %function
sub_and_pow:
    mov     x2, #0
    fmov    d9, d4
0:
    cmp     x2, x0
    b.ge    1f
    fmul    d4, d4, d7
    add     x2, x2, #1
    b       0b
1:
    fneg    d4, d4
    fadd    d4, d4, d9
    ret
    .size   sub_and_pow, .-sub_and_pow

    .type   factorial, %function
factorial:
    mov     x2, #1
    mov     x3, #2
    mul     x3, x0, x3
0:
    cmp     x2, x3
    b.gt    1f
    fmul    d5, d5, d10
    fadd    d10, d10, d9
    add     x2, x2, #1
    b       0b
1:
    ret
    .size   factorial, .-factorial
pow_x:
    mov     x3, #2
    mul     x3, x0, x3
    sub     x3, x3, #1
    mov     x2, #0
0:
    cmp     x2, x3
    b.ge    1f
    fmul    d12, d12, d0
    add     x2, x2, #1
    b       0b
1:
    ret
    .size   pow_x, .-pow_x










