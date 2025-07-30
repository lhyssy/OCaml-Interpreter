.globl main
.text
factorial:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	addi s1, a0, 0
	addi s2, x0, 1
	slt s3, s2, s1
	sub s4, s3, x0
	sltiu s4, s4, 1
	beq s4, x0, else_0
	addi a0, x0, 1
	jal x0, factorial_return
else_0:
endif_1:
	addi s4, x0, 1
	sub s3, s1, s4
	addi a0, s3, 0
	jal ra, factorial
	addi t0, a0, 0
	mul t1, s1, t0
	addi a0, t1, 0
	jal x0, factorial_return

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
	addi s1, a0, 0
	addi s2, x0, 0
	slt s3, s2, s1
	sub s4, s3, x0
	sltiu s4, s4, 1
	beq s4, x0, else_2
	addi a0, x0, 0
	jal x0, fibonacci_return
else_2:
endif_3:
	addi s4, x0, 1
	sub s3, s1, s4
	sub s2, s3, x0
	sltiu s2, s2, 1
	beq s2, x0, else_4
	addi a0, x0, 1
	jal x0, fibonacci_return
else_4:
endif_5:
	addi s2, x0, 1
	sub s3, s1, s2
	addi a0, s3, 0
	jal ra, fibonacci
	addi t0, a0, 0
	addi s3, x0, 2
	sub s2, s1, s3
	addi a0, s2, 0
	jal ra, fibonacci
	addi t1, a0, 0
	add t2, t0, t1
	addi a0, t2, 0
	jal x0, fibonacci_return

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
	addi s1, a0, 0
	addi s2, a1, 0
	addi s3, x0, 0
	sub s4, s2, s3
	sub s5, s4, x0
	sltiu s5, s5, 1
	beq s5, x0, else_6
	addi a0, s1, 0
	jal x0, gcd_return
else_6:
endif_7:
	rem s5, s1, s2
	addi a0, s2, 0
	addi a1, s5, 0
	jal ra, gcd
	addi t0, a0, 0
	addi a0, t0, 0
	jal x0, gcd_return

gcd_return:
	lw ra, 12(sp)
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
	sub t3, t2, x0
	sltiu t3, t3, 1
	beq t3, x0, else_8
	addi a0, x0, 0
	jal x0, is_prime_return
else_8:
endif_9:
	addi t3, x0, 3
	slt t2, t3, t0
	sub t1, t2, x0
	sltiu t1, t1, 1
	beq t1, x0, else_10
	addi a0, x0, 1
	jal x0, is_prime_return
else_10:
endif_11:
	addi t1, x0, 2
	rem t2, t0, t1
	addi t3, x0, 0
	sub t1, t2, t3
	sub t4, t1, x0
	sltiu t4, t4, 1
	addi t2, x0, 3
	rem t1, t0, t2
	addi t3, x0, 0
	sub t2, t1, t3
	sub s1, t2, x0
	sltiu s1, s1, 1
	bne t4, x0, or_true_12
	bne s1, x0, or_true_12
	addi t4, x0, 0
	jal x0, or_end_13
or_true_12:
	addi t4, x0, 1
or_end_13:
	beq t4, x0, else_14
	addi a0, x0, 0
	jal x0, is_prime_return
else_14:
endif_15:
	addi t4, x0, 5
while_start_16:
	mul t2, t4, t4
	slt t1, t0, t2
	sub t3, t1, x0
	sltiu t3, t3, 1
	beq t3, x0, while_end_18
	rem t1, t0, t4
	addi t3, x0, 0
	sub t2, t1, t3
	sub s1, t2, x0
	sltiu s1, s1, 1
	addi t1, x0, 2
	add t2, t4, t1
	rem t3, t0, t2
	addi t1, x0, 0
	sub t0, t3, t1
	sub t2, t0, x0
	sltiu t2, t2, 1
	bne s1, x0, or_true_19
	bne t2, x0, or_true_19
	addi t0, x0, 0
	jal x0, or_end_20
or_true_19:
	addi t0, x0, 1
or_end_20:
	beq t0, x0, else_21
	addi a0, x0, 0
	jal x0, is_prime_return
else_21:
endif_22:
	addi t0, x0, 6
	add t2, t4, t0
	addi t4, t2, 0
while_continue_17:
	jal x0, while_start_16
while_end_18:
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
	addi s1, x0, 1
	addi t2, s1, 0
	addi t3, x0, 0
	addi s1, x0, 1
	addi t3, s1, 0
	addi s2, x0, 42
	addi s1, x0, 56
	addi s3, x0, 87
	addi s4, x0, 56
	addi s5, x0, 87
	addi a0, s4, 0
	addi a1, s5, 0
	jal ra, gcd
	addi s5, a0, 0
	addi a0, s5, 0
	jal ra, factorial
	addi s5, a0, 0
	addi s4, x0, 8
	addi a0, s4, 0
	jal ra, fibonacci
	addi s4, a0, 0
	add t4, s5, s4
	addi s6, x0, 0
	addi s5, x0, 87
	addi s6, s5, 0
	addi s4, x0, 0
	addi s5, x0, 1
while_start_23:
	addi s7, x0, 10
	slt s8, s7, s5
	sub s9, s8, x0
	sltiu s9, s9, 1
	beq s9, x0, while_end_25
	addi s8, x0, 2
	rem s9, s5, s8
	addi s7, x0, 0
	sub s8, s9, s7
	sub s10, s8, x0
	sltiu s10, s10, 1
	beq s10, x0, else_26
	mul s8, s5, s5
	add s10, s4, s8
	addi s4, s10, 0
	jal x0, endif_27
else_26:
	addi s10, x0, 3
	rem s8, s5, s10
	addi s9, x0, 0
	sub s10, s8, s9
	sub s7, s10, x0
	sltiu s7, s7, 1
	beq s7, x0, else_28
	mul s10, s5, s5
	mul s7, s10, s5
	add s8, s4, s7
	addi s4, s8, 0
	jal x0, endif_29
else_28:
	add s8, s4, s5
	addi s4, s8, 0
endif_29:
endif_27:
	addi s8, x0, 1
	add s7, s5, s8
	addi s5, s7, 0
while_continue_24:
	jal x0, while_start_23
while_end_25:
	addi s7, x0, 0
	addi s8, x0, 1
	addi s5, s8, 0
while_start_30:
	addi s8, x0, 5
	slt s10, s8, s5
	sub s9, s10, x0
	sltiu s9, s9, 1
	beq s9, x0, while_end_32
	addi s10, x0, 1
	addi s9, x0, 1
while_start_33:
	slt s8, s5, s10
	sub s11, s8, x0
	sltiu s11, s11, 1
	beq s11, x0, while_end_35
	mul s8, s9, s10
	addi s9, s8, 0
	addi s11, x0, 1
	add s8, s10, s11
	addi s10, s8, 0
while_continue_34:
	jal x0, while_start_33
while_end_35:
	add s8, s7, s9
	addi s7, s8, 0
	addi s9, x0, 1
	add s8, s5, s9
	addi s5, s8, 0
while_continue_31:
	jal x0, while_start_30
while_end_32:
	addi s8, x0, 0
	addi a0, s2, 0
	jal ra, is_prime
	addi s5, a0, 0
	beq s5, x0, else_36
	addi a0, s1, 0
	jal ra, is_prime
	addi s5, a0, 0
	beq s5, x0, else_38
	mul s9, s2, s1
	addi s8, s9, 0
	jal x0, endif_39
else_38:
	addi a0, s3, 0
	jal ra, is_prime
	addi s9, a0, 0
	beq s9, x0, else_40
	mul s5, s2, s3
	addi s8, s5, 0
	jal x0, endif_41
else_40:
	addi s8, s2, 0
endif_41:
endif_39:
	jal x0, endif_37
else_36:
	addi a0, s1, 0
	jal ra, is_prime
	addi s5, a0, 0
	beq s5, x0, else_42
	addi a0, s3, 0
	jal ra, is_prime
	addi s5, a0, 0
	beq s5, x0, else_44
	mul s9, s1, s3
	addi s8, s9, 0
	jal x0, endif_45
else_44:
	addi s8, s1, 0
endif_45:
	jal x0, endif_43
else_42:
	addi a0, s3, 0
	jal ra, is_prime
	addi s9, a0, 0
	beq s9, x0, else_46
	addi s8, s3, 0
	jal x0, endif_47
else_46:
	add s9, s2, s1
	add s5, s9, s3
	addi s8, s5, 0
endif_47:
endif_43:
endif_37:
	li s5, 2345
	addi s3, x0, 0
while_start_48:
	addi s9, x0, 0
	slt s2, s9, s5
	beq s2, x0, while_end_50
	addi s9, x0, 2
	rem s2, s5, s9
	addi s1, x0, 1
	sub s9, s2, s1
	sub s10, s9, x0
	sltiu s10, s10, 1
	beq s10, x0, else_51
	addi s9, x0, 1
	add s10, s3, s9
	addi s3, s10, 0
	jal x0, endif_52
else_51:
endif_52:
	srli s10, s5, 1
	addi s5, s10, 0
while_continue_49:
	jal x0, while_start_48
while_end_50:
	add s10, t0, t1
	add s5, s10, t2
	add t0, s5, t3
	add t2, t0, t4
	add t3, t2, s6
	add t4, t3, s4
	add t2, t4, s7
	add t3, t2, s8
	add t4, t3, s3
	addi t2, x0, 256
	rem t3, t4, t2
	addi a0, t3, 0
	jal x0, main_return

main_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

