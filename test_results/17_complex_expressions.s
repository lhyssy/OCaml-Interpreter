.globl main
.text
factorial:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, x0, 1
	slt t2, t1, t0
	sub t1, t2, x0
	sltiu t1, t1, 1
	beq t1, x0, else_0
	addi a0, x0, 1
	jal x0, factorial_return
else_0:
endif_1:
	addi t1, x0, 1
	sub t2, t0, t1
	addi a0, t2, 0
	jal ra, factorial
	addi t2, a0, 0
	mul t1, t0, t2
	addi a0, t1, 0
	jal x0, factorial_return

factorial_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

fibonacci:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, x0, 0
	slt t2, t1, t0
	sub t1, t2, x0
	sltiu t1, t1, 1
	beq t1, x0, else_0
	addi a0, x0, 0
	jal x0, fibonacci_return
else_0:
endif_1:
	addi t1, x0, 1
	sub t2, t0, t1
	sub t1, t2, x0
	sltiu t1, t1, 1
	beq t1, x0, else_2
	addi a0, x0, 1
	jal x0, fibonacci_return
else_2:
endif_3:
	addi t1, x0, 1
	sub t2, t0, t1
	addi a0, t2, 0
	jal ra, fibonacci
	addi t2, a0, 0
	addi t1, x0, 2
	sub t3, t0, t1
	addi a0, t3, 0
	jal ra, fibonacci
	addi t3, a0, 0
	add t0, t2, t3
	addi a0, t0, 0
	jal x0, fibonacci_return

fibonacci_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

gcd:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, a1, 0
	addi t2, x0, 0
	sub t3, t1, t2
	sub t2, t3, x0
	sltiu t2, t2, 1
	beq t2, x0, else_0
	addi a0, t0, 0
	jal x0, gcd_return
else_0:
endif_1:
	rem t2, t0, t1
	addi a0, t1, 0
	addi a1, t2, 0
	jal ra, gcd
	addi t2, a0, 0
	addi a0, t2, 0
	jal x0, gcd_return

gcd_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

is_prime:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, x0, 1
	slt t2, t1, t0
	sub t1, t2, x0
	sltiu t1, t1, 1
	beq t1, x0, else_0
	addi a0, x0, 0
	jal x0, is_prime_return
else_0:
endif_1:
	addi t1, x0, 3
	slt t2, t1, t0
	sub t1, t2, x0
	sltiu t1, t1, 1
	beq t1, x0, else_2
	addi a0, x0, 1
	jal x0, is_prime_return
else_2:
endif_3:
	addi t1, x0, 2
	rem t2, t0, t1
	addi t1, x0, 0
	sub t3, t2, t1
	sub t2, t3, x0
	sltiu t2, t2, 1
	addi t3, x0, 3
	rem t1, t0, t3
	addi t3, x0, 0
	sub t4, t1, t3
	sub t1, t4, x0
	sltiu t1, t1, 1
	bne t2, x0, or_true_4
	bne t1, x0, or_true_4
	addi t1, x0, 0
	jal x0, or_end_5
or_true_4:
	addi t1, x0, 1
or_end_5:
	beq t1, x0, else_6
	addi a0, x0, 0
	jal x0, is_prime_return
else_6:
endif_7:
	addi t1, x0, 5
while_start_8:
	mul t2, t1, t1
	slt t4, t0, t2
	sub t2, t4, x0
	sltiu t2, t2, 1
	beq t2, x0, while_end_10
	rem t2, t0, t1
	addi t4, x0, 0
	sub t3, t2, t4
	sub t2, t3, x0
	sltiu t2, t2, 1
	addi t3, x0, 2
	add t4, t1, t3
	rem t3, t0, t4
	addi t0, x0, 0
	sub t4, t3, t0
	sub t3, t4, x0
	sltiu t3, t3, 1
	bne t2, x0, or_true_11
	bne t3, x0, or_true_11
	addi t3, x0, 0
	jal x0, or_end_12
or_true_11:
	addi t3, x0, 1
or_end_12:
	beq t3, x0, else_13
	addi a0, x0, 0
	jal x0, is_prime_return
else_13:
endif_14:
	addi t3, x0, 6
	add t2, t1, t3
	addi t1, t2, 0
while_continue_9:
	jal x0, while_start_8
while_end_10:
	addi a0, x0, 1
	jal x0, is_prime_return

is_prime_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

main:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t0, x0, -4
	addi t1, x0, 0
	addi t2, x0, 0
	addi t3, x0, 1
	addi t2, t3, 0
	addi t3, x0, 0
	addi t4, x0, 1
	addi t3, t4, 0
	addi t4, x0, 42
	addi s1, x0, 56
	addi s2, x0, 87
	addi s3, x0, 56
	addi s4, x0, 87
	addi a0, s3, 0
	addi a1, s4, 0
	jal ra, gcd
	addi s4, a0, 0
	addi a0, s4, 0
	jal ra, factorial
	addi s4, a0, 0
	addi s3, x0, 8
	addi a0, s3, 0
	jal ra, fibonacci
	addi s3, a0, 0
	add s5, s4, s3
	addi s4, x0, 0
	addi s3, x0, 87
	addi s4, s3, 0
	addi s3, x0, 0
	addi s6, x0, 1
while_start_0:
	addi s7, x0, 10
	slt s8, s7, s6
	sub s7, s8, x0
	sltiu s7, s7, 1
	beq s7, x0, while_end_2
	addi s7, x0, 2
	rem s8, s6, s7
	addi s7, x0, 0
	sub s9, s8, s7
	sub s8, s9, x0
	sltiu s8, s8, 1
	beq s8, x0, else_3
	mul s8, s6, s6
	add s9, s3, s8
	addi s3, s9, 0
	jal x0, endif_4
else_3:
	addi s9, x0, 3
	rem s8, s6, s9
	addi s9, x0, 0
	sub s7, s8, s9
	sub s8, s7, x0
	sltiu s8, s8, 1
	beq s8, x0, else_5
	mul s8, s6, s6
	mul s7, s8, s6
	add s8, s3, s7
	addi s3, s8, 0
	jal x0, endif_6
else_5:
	add s8, s3, s6
	addi s3, s8, 0
endif_6:
endif_4:
	addi s8, x0, 1
	add s7, s6, s8
	addi s6, s7, 0
while_continue_1:
	jal x0, while_start_0
while_end_2:
	addi s7, x0, 0
	addi s8, x0, 1
	addi s6, s8, 0
while_start_7:
	addi s8, x0, 5
	slt s9, s8, s6
	sub s8, s9, x0
	sltiu s8, s8, 1
	beq s8, x0, while_end_9
	addi s8, x0, 1
	addi s9, x0, 1
while_start_10:
	slt s10, s6, s8
	sub s11, s10, x0
	sltiu s11, s11, 1
	beq s11, x0, while_end_12
	mul s11, s9, s8
	addi s9, s11, 0
	addi s11, x0, 1
	add s10, s8, s11
	addi s8, s10, 0
while_continue_11:
	jal x0, while_start_10
while_end_12:
	add s10, s7, s9
	addi s7, s10, 0
	addi s10, x0, 1
	add s9, s6, s10
	addi s6, s9, 0
while_continue_8:
	jal x0, while_start_7
while_end_9:
	addi s9, x0, 0
	addi a0, t4, 0
	jal ra, is_prime
	addi s6, a0, 0
	beq s6, x0, else_13
	addi a0, s1, 0
	jal ra, is_prime
	addi s6, a0, 0
	beq s6, x0, else_15
	mul s6, t4, s1
	addi s9, s6, 0
	jal x0, endif_16
else_15:
	addi a0, s2, 0
	jal ra, is_prime
	addi s6, a0, 0
	beq s6, x0, else_17
	mul s6, t4, s2
	addi s9, s6, 0
	jal x0, endif_18
else_17:
	addi s9, t4, 0
endif_18:
endif_16:
	jal x0, endif_14
else_13:
	addi a0, s1, 0
	jal ra, is_prime
	addi s6, a0, 0
	beq s6, x0, else_19
	addi a0, s2, 0
	jal ra, is_prime
	addi s6, a0, 0
	beq s6, x0, else_21
	mul s6, s1, s2
	addi s9, s6, 0
	jal x0, endif_22
else_21:
	addi s9, s1, 0
endif_22:
	jal x0, endif_20
else_19:
	addi a0, s2, 0
	jal ra, is_prime
	addi s6, a0, 0
	beq s6, x0, else_23
	addi s9, s2, 0
	jal x0, endif_24
else_23:
	add s6, t4, s1
	add t4, s6, s2
	addi s9, t4, 0
endif_24:
endif_20:
endif_14:
	li t4, 2345
	addi s2, x0, 0
while_start_25:
	addi s6, x0, 0
	slt s1, s6, t4
	beq s1, x0, while_end_27
	addi s1, x0, 2
	rem s6, t4, s1
	addi s1, x0, 1
	sub s10, s6, s1
	sub s6, s10, x0
	sltiu s6, s6, 1
	beq s6, x0, else_28
	addi s6, x0, 1
	add s10, s2, s6
	addi s2, s10, 0
	jal x0, endif_29
else_28:
endif_29:
	srli s10, t4, 1
	addi t4, s10, 0
while_continue_26:
	jal x0, while_start_25
while_end_27:
	add s10, t0, t1
	add t0, s10, t2
	add t2, t0, t3
	add t3, t2, s5
	add s5, t3, s4
	add s4, s5, s3
	add s3, s4, s7
	add s7, s3, s9
	add s9, s7, s2
	addi s2, x0, 256
	rem s7, s9, s2
	addi a0, s7, 0
	jal x0, main_return

main_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

