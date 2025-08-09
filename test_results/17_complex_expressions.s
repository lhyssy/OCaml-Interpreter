.globl main
.text
factorial:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	jal x0, factorial_return
endif_1:
	jal x0, endif_1
factorial_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

fibonacci:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	jal x0, fibonacci_return
endif_5:
	jal x0, endif_5
endif_3:
	jal x0, endif_3
fibonacci_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

gcd:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	jal x0, gcd_return
endif_7:
	jal x0, endif_7
gcd_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

is_prime:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	jal x0, is_prime_return
while_end_17:
	jal x0, while_start_15
	addi t0, t0, 6
endif_19:
else_18:
	jal x0, endif_19
or_true_20:
	bne t1, t1, else_18
	addi t1, x0, 0
	rem t1, t1, t2
	add t2, t0, t2
	addi t2, x0, 2
	bne t2, x0, or_true_20
	sub t2, t2, x0
	sltiu t2, t2, 1
	sub t2, t2, t2
	addi t2, x0, 0
	rem t2, t1, t0
	blt t1, t2, while_end_17
	mul t2, t0, t0
while_start_15:
	addi t0, x0, 5
endif_13:
else_12:
	jal x0, endif_13
or_true_14:
	bne t0, t0, else_12
	addi t0, x0, 0
	rem t0, t1, t0
	addi t0, x0, 3
	bne t0, x0, or_true_14
	sub t0, t0, x0
	sltiu t0, t0, 1
	sub t0, t0, t0
	addi t0, x0, 0
	rem t0, t1, t1
	addi t1, x0, 2
endif_11:
	jal x0, endif_11
endif_9:
	jal x0, endif_9
is_prime_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

main:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	jal x0, main_return
	jal x0, while_start_46
	srli t0, t0, 1
endif_50:
	jal x0, endif_50
while_start_46:
	addi t0, x0, 0
	li t0, 2345
endif_35:
endif_41:
endif_45:
	addi t0, x0, 185
	jal x0, endif_45
	jal x0, endif_41
endif_43:
	addi t0, x0, 56
	jal x0, endif_43
	jal x0, endif_35
endif_37:
endif_39:
	addi t0, x0, 42
	jal x0, endif_39
	jal x0, endif_37
while_end_30:
	jal x0, while_start_28
	addi t0, t0, 1
	add t1, t1, t1
while_end_33:
	jal x0, while_start_31
	addi t2, t2, 1
	mul t1, t1, t2
	blt t0, t2, while_end_33
while_start_31:
	addi t1, x0, 1
	addi t2, x0, 1
	blt t2, t0, while_end_30
	addi t2, x0, 5
while_start_28:
	addi t0, x0, 1
	addi t1, x0, 0
	jal x0, while_start_21
	addi t0, t0, 1
endif_25:
endif_27:
	add t2, t2, t0
	jal x0, endif_27
	jal x0, endif_25
while_start_21:
	addi t0, x0, 1
	addi t2, x0, 0
	add t0, s1, t0
	addi t0, a0, 0
	jal ra, fibonacci
	addi a0, t0, 0
	addi t0, x0, 8
	addi s1, a0, 0
	jal ra, factorial
	addi a0, t0, 0
	addi t0, a0, 0
	jal ra, gcd
	addi a1, t0, 0
	addi a0, t0, 0
	addi t0, x0, 87
	addi t0, x0, 56
main_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

