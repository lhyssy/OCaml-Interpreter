.globl main
.text
factorial:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	sw s1, 4(sp)
	sw s2, 0(sp)
	addi s0, sp, 16
	addi s1, a0, 0
	addi s2, x0, 1
	blt s2, s1, else_0
	addi a0, x0, 1
	jal x0, factorial_return
else_0:
	addi s2, x0, 1
	sub s2, s1, s2
	addi a0, s2, 0
	jal ra, factorial
	addi t0, a0, 0
	mul t0, s1, t0
	addi a0, t0, 0
	jal x0, factorial_return
factorial_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	lw s1, 4(sp)
	lw s2, 0(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

fibonacci:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	sw s1, 4(sp)
	sw s2, 0(sp)
	addi s0, sp, 16
	addi s1, a0, 0
	blt zero, s1, else_2
	addi a0, x0, 0
	jal x0, fibonacci_return
else_2:
	addi s2, x0, 1
	bne s1, s2, else_4
	addi a0, x0, 1
	jal x0, fibonacci_return
else_4:
	addi s2, x0, 1
	sub s2, s1, s2
	addi a0, s2, 0
	jal ra, fibonacci
	addi t0, a0, 0
	addi s2, x0, 2
	sub s1, s1, s2
	addi sp, sp, -4
	sw t0, 0(sp)
	addi a0, s1, 0
	jal ra, fibonacci
	lw t0, 0(sp)
	addi sp, sp, 4
	addi t1, a0, 0
	add t0, t0, t1
	addi a0, t0, 0
	jal x0, fibonacci_return
fibonacci_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	lw s1, 4(sp)
	lw s2, 0(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

gcd:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	sw s1, 4(sp)
	sw s2, 0(sp)
	addi s0, sp, 16
	addi s1, a0, 0
	addi s2, a1, 0
	bne s2, x0, else_6
	addi a0, s1, 0
	jal x0, gcd_return
else_6:
	rem s1, s1, s2
	addi a0, s2, 0
	addi a1, s1, 0
	jal ra, gcd
	addi t0, a0, 0
	addi a0, t0, 0
	jal x0, gcd_return
gcd_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	lw s1, 4(sp)
	lw s2, 0(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

is_prime:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	addi t0, x0, 1
	blt t0, a0, else_8
	addi a0, x0, 0
	jal x0, is_prime_return
else_8:
	addi t0, x0, 3
	blt t0, a0, else_10
	addi a0, x0, 1
	jal x0, is_prime_return
else_10:
	addi t0, x0, 2
	rem t0, a0, t0
	addi t1, x0, 0
	sub t0, t0, t1
	sub t0, t0, x0
	sltiu t0, t0, 1
	bne t0, x0, or_true_14
	addi t0, x0, 3
	rem t0, a0, t0
	bne t0, x0, else_12
or_true_14:
	addi a0, x0, 0
	jal x0, is_prime_return
else_12:
	addi t0, x0, 5
while_start_15:
	mul t1, t0, t0
	blt a0, t1, while_end_17
	rem t1, a0, t0
	addi t2, x0, 0
	sub t1, t1, t2
	sub t1, t1, x0
	sltiu t1, t1, 1
	bne t1, x0, or_true_20
	addi t1, x0, 2
	add t1, t0, t1
	rem t1, a0, t1
	bne t1, x0, else_18
or_true_20:
	addi a0, x0, 0
	jal x0, is_prime_return
else_18:
	addi t0, t0, 6
	jal x0, while_start_15
while_end_17:
	addi a0, x0, 1
	jal x0, is_prime_return
is_prime_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

main:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	addi s1, x0, 56
	addi s2, x0, 87
	addi a0, s1, 0
	addi a1, s2, 0
	jal ra, gcd
	addi s2, a0, 0
	addi a0, s2, 0
	jal ra, factorial
	addi s2, a0, 0
	addi s1, x0, 8
	addi a0, s1, 0
	jal ra, fibonacci
	addi s1, a0, 0
	add t0, s2, s1
	addi t1, x0, 0
	addi s2, x0, 42
	addi sp, sp, -8
	sw t0, 0(sp)
	sw t1, 4(sp)
	addi a0, s2, 0
	jal ra, is_prime
	lw t0, 0(sp)
	lw t1, 4(sp)
	addi sp, sp, 8
	addi s2, a0, 0
	beq s2, x0, else_21
	addi s2, x0, 56
	addi sp, sp, -8
	sw t0, 0(sp)
	sw t1, 4(sp)
	addi a0, s2, 0
	jal ra, is_prime
	lw t0, 0(sp)
	lw t1, 4(sp)
	addi sp, sp, 8
	addi s2, a0, 0
	beq s2, x0, else_23
	li t1, 2352
	jal x0, endif_24
else_23:
	addi s2, x0, 87
	addi sp, sp, -8
	sw t0, 0(sp)
	sw t1, 4(sp)
	addi a0, s2, 0
	jal ra, is_prime
	lw t0, 0(sp)
	lw t1, 4(sp)
	addi sp, sp, 8
	addi s2, a0, 0
	beq s2, x0, else_25
	li t1, 3654
	jal x0, endif_26
else_25:
	addi t1, x0, 42
endif_26:
endif_24:
	jal x0, endif_22
else_21:
	addi s2, x0, 56
	addi sp, sp, -8
	sw t0, 0(sp)
	sw t1, 4(sp)
	addi a0, s2, 0
	jal ra, is_prime
	lw t0, 0(sp)
	lw t1, 4(sp)
	addi sp, sp, 8
	addi s2, a0, 0
	beq s2, x0, else_27
	addi s2, x0, 87
	addi sp, sp, -8
	sw t0, 0(sp)
	sw t1, 4(sp)
	addi a0, s2, 0
	jal ra, is_prime
	lw t0, 0(sp)
	lw t1, 4(sp)
	addi sp, sp, 8
	addi s2, a0, 0
	beq s2, x0, else_29
	li t1, 4872
	jal x0, endif_30
else_29:
	addi t1, x0, 56
endif_30:
	jal x0, endif_28
else_27:
	addi s2, x0, 87
	addi sp, sp, -8
	sw t0, 0(sp)
	sw t1, 4(sp)
	addi a0, s2, 0
	jal ra, is_prime
	lw t0, 0(sp)
	lw t1, 4(sp)
	addi sp, sp, 8
	addi t2, a0, 0
	beq t2, x0, else_31
	addi t1, x0, 87
	jal x0, endif_32
else_31:
	addi t1, x0, 185
endif_32:
endif_28:
endif_22:
	addi t2, x0, -2
	add t0, t2, t0
	addi t2, x0, 87
	add t0, t0, t2
	addi t2, x0, 989
	add t0, t0, t2
	addi t2, x0, 153
	add t0, t0, t2
	add t1, t0, t1
	addi t0, x0, 5
	add t1, t1, t0
	addi t0, x0, 256
	rem t1, t1, t0
	addi a0, t1, 0
	jal x0, main_return
main_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

