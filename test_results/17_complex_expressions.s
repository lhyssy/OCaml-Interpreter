.globl main
.text
factorial:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi s0, a0, 0
	addi a0, x0, 1
	slt t2, a0, s0
	sub t3, t2, x0
	sltiu t3, t3, 1
	beq t3, x0, else_0
	addi a0, x0, 1
	jal x0, factorial_return
else_0:
endif_1:
	addi t3, x0, 1
	sub t2, s0, t3
	addi a0, t2, 0
	jal ra, factorial
	addi t2, a0, 0
	mul t1, s0, t2
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
	addi s0, a0, 0
	addi a0, x0, 0
	slt t2, a0, s0
	sub t3, t2, x0
	sltiu t3, t3, 1
	beq t3, x0, else_0
	addi a0, x0, 0
	jal x0, fibonacci_return
else_0:
endif_1:
	addi t3, x0, 1
	sub t2, s0, t3
	sub t3, t2, x0
	sltiu t3, t3, 1
	beq t3, x0, else_2
	addi a0, x0, 1
	jal x0, fibonacci_return
else_2:
endif_3:
	addi t3, x0, 1
	sub t2, s0, t3
	addi a0, t2, 0
	jal ra, fibonacci
	addi t2, a0, 0
	addi t3, x0, 2
	sub t4, s0, t3
	addi a0, t4, 0
	jal ra, fibonacci
	addi t4, a0, 0
	add t1, t2, t4
	addi a0, t1, 0
	jal x0, fibonacci_return

fibonacci_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

gcd:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi s0, a0, 0
	addi a0, t2, 0
	addi t2, x0, 0
	sub t3, a0, t2
	sub t2, t3, x0
	sltiu t2, t2, 1
	beq t2, x0, else_0
	addi a0, s0, 0
	jal x0, gcd_return
else_0:
endif_1:
	rem t2, s0, a0
	addi a0, a0, 0
	addi t2, t2, 0
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
	addi s0, a0, 0
	addi a0, x0, 1
	slt t2, a0, s0
	sub t1, t2, x0
	sltiu t1, t1, 1
	beq t1, x0, else_0
	addi a0, x0, 0
	jal x0, is_prime_return
else_0:
endif_1:
	addi t1, x0, 3
	slt t2, t1, s0
	sub t1, t2, x0
	sltiu t1, t1, 1
	beq t1, x0, else_2
	addi a0, x0, 1
	jal x0, is_prime_return
else_2:
endif_3:
	addi t1, x0, 2
	rem t2, s0, t1
	addi t1, x0, 0
	sub t3, t2, t1
	sub t2, t3, x0
	sltiu t2, t2, 1
	addi t3, x0, 3
	rem t1, s0, t3
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
while_start_8:
	addi t1, x0, 25
	slt t2, s0, t1
	sub t1, t2, x0
	sltiu t1, t1, 1
	beq t1, x0, while_end_9
	addi t1, x0, 5
	rem t2, s0, t1
	addi t1, x0, 0
	sub t4, t2, t1
	sub t2, t4, x0
	sltiu t2, t2, 1
	addi t4, x0, 7
	rem t1, s0, t4
	addi t0, x0, 0
	sub t4, t1, t0
	sub t1, t4, x0
	sltiu t1, t1, 1
	bne t2, x0, or_true_10
	bne t1, x0, or_true_10
	addi t1, x0, 0
	jal x0, or_end_11
or_true_10:
	addi t1, x0, 1
or_end_11:
	beq t1, x0, else_12
	addi a0, x0, 0
	jal x0, is_prime_return
else_12:
endif_13:
	jal x0, while_start_8
while_end_9:
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
	addi s0, x0, 56
	addi a0, x0, 87
	addi a0, s0, 0
	addi t0, a0, 0
	jal ra, gcd
	addi t0, a0, 0
	addi a0, t0, 0
	jal ra, factorial
	addi t0, a0, 0
	addi t2, x0, 8
	addi a0, t2, 0
	jal ra, fibonacci
	addi t2, a0, 0
	add t3, t0, t2
while_start_0:
	addi t0, x0, 1
	beq t0, x0, while_end_1
	jal x0, while_start_0
while_end_1:
while_start_2:
	addi t0, x0, 1
	beq t0, x0, while_end_3
while_start_4:
	addi t0, x0, 1
	beq t0, x0, while_end_5
	jal x0, while_start_4
while_end_5:
	jal x0, while_start_2
while_end_3:
	addi t0, x0, 42
	addi a0, t0, 0
	jal ra, is_prime
	addi t0, a0, 0
	beq t0, x0, else_6
	addi t0, x0, 56
	addi a0, t0, 0
	jal ra, is_prime
	addi t0, a0, 0
	beq t0, x0, else_8
	jal x0, endif_9
else_8:
	addi t0, x0, 87
	addi a0, t0, 0
	jal ra, is_prime
	addi t0, a0, 0
	beq t0, x0, else_10
	jal x0, endif_11
else_10:
endif_11:
endif_9:
	jal x0, endif_7
else_6:
	addi t0, x0, 56
	addi a0, t0, 0
	jal ra, is_prime
	addi t0, a0, 0
	beq t0, x0, else_12
	addi t0, x0, 87
	addi a0, t0, 0
	jal ra, is_prime
	addi t0, a0, 0
	beq t0, x0, else_14
	jal x0, endif_15
else_14:
endif_15:
	jal x0, endif_13
else_12:
	addi t0, x0, 87
	addi a0, t0, 0
	jal ra, is_prime
	addi t0, a0, 0
	beq t0, x0, else_16
	jal x0, endif_17
else_16:
endif_17:
endif_13:
endif_7:
while_start_18:
	addi t0, x0, 1
	beq t0, x0, while_end_19
	jal x0, while_start_18
while_end_19:
	addi t0, x0, -2
	add t1, t0, t3
	addi t3, x0, 87
	add t0, t1, t3
	addi t1, x0, 256
	rem t3, t0, t1
	addi a0, t3, 0
	jal x0, main_return

main_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

