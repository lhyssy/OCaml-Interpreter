.globl main
.text
factorial:
	addi sp, sp, -32
	sw ra, 28(sp)
	sw s0, 24(sp)
	sw s1, 20(sp)
	sw s2, 16(sp)
	sw s3, 12(sp)
	addi s0, sp, 32
	addi s1, a0, 0
	addi s2, x0, 1
	blt s2, s1, else_0
	addi a0, x0, 1
	jal x0, factorial_return
else_0:
	addi s2, x0, 1
	sub s3, s1, s2
	addi a0, s3, 0
	jal ra, factorial
	addi t0, a0, 0
	mul t1, s1, t0
	addi a0, t1, 0
	jal x0, factorial_return
factorial_return:
	lw ra, 28(sp)
	lw s0, 24(sp)
	lw s1, 20(sp)
	lw s2, 16(sp)
	lw s3, 12(sp)
	addi sp, sp, 32
	jalr x0, ra, 0

fibonacci:
	addi sp, sp, -32
	sw ra, 28(sp)
	sw s0, 24(sp)
	sw s1, 20(sp)
	sw s2, 16(sp)
	sw s3, 12(sp)
	addi s0, sp, 32
	addi s1, a0, 0
	addi s2, x0, 0
	blt s2, s1, else_2
	addi a0, x0, 0
	jal x0, fibonacci_return
else_2:
	addi s2, x0, 1
	bne s1, s2, else_4
	addi a0, x0, 1
	jal x0, fibonacci_return
else_4:
	addi s2, x0, 1
	sub s3, s1, s2
	addi a0, s3, 0
	jal ra, fibonacci
	addi t0, a0, 0
	addi s3, x0, 2
	sub s2, s1, s3
	addi a0, s2, 0
	addi sp, sp, -4
	sw t0, 4(sp)
	jal ra, fibonacci
	lw t0, 4(sp)
	addi sp, sp, 4
	addi t1, a0, 0
	add t2, t0, t1
	addi a0, t2, 0
	jal x0, fibonacci_return
fibonacci_return:
	lw ra, 28(sp)
	lw s0, 24(sp)
	lw s1, 20(sp)
	lw s2, 16(sp)
	lw s3, 12(sp)
	addi sp, sp, 32
	jalr x0, ra, 0

gcd:
	addi sp, sp, -32
	sw ra, 28(sp)
	sw s0, 24(sp)
	sw s1, 20(sp)
	sw s2, 16(sp)
	sw s3, 12(sp)
	addi s0, sp, 32
	addi s1, a0, 0
	addi s2, a1, 0
	addi s3, x0, 0
	bne s2, s3, else_6
	addi a0, s1, 0
	jal x0, gcd_return
else_6:
	rem s3, s1, s2
	addi a0, s2, 0
	addi a1, s3, 0
	jal ra, gcd
	addi t0, a0, 0
	addi a0, t0, 0
	jal x0, gcd_return
gcd_return:
	lw ra, 28(sp)
	lw s0, 24(sp)
	lw s1, 20(sp)
	lw s2, 16(sp)
	lw s3, 12(sp)
	addi sp, sp, 32
	jalr x0, ra, 0

is_prime:
	addi sp, sp, -16
	sw s0, 8(sp)
	sw s1, 4(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, x0, 1
	blt t1, t0, else_8
	addi a0, x0, 0
	jal x0, is_prime_return
else_8:
	addi t1, x0, 3
	blt t1, t0, else_10
	addi a0, x0, 1
	jal x0, is_prime_return
else_10:
	addi t1, x0, 2
	rem t2, t0, t1
	addi t3, x0, 0
	sub t1, t2, t3
	sub t4, t1, x0
	sltiu t4, t4, 1
	bne t4, x0, or_true_14
	addi t1, x0, 3
	rem t4, t0, t1
	addi t2, x0, 0
	bne t4, t2, else_12
or_true_14:
	addi a0, x0, 0
	jal x0, is_prime_return
else_12:
	addi t4, x0, 5
while_start_15:
	mul t2, t4, t4
	blt t0, t2, while_end_17
	rem t1, t0, t4
	addi t2, x0, 0
	sub t3, t1, t2
	sub s1, t3, x0
	sltiu s1, s1, 1
	bne s1, x0, or_true_20
	addi t3, x0, 2
	add t1, t4, t3
	rem t2, t0, t1
	addi t3, x0, 0
	bne t2, t3, else_18
or_true_20:
	addi a0, x0, 0
	jal x0, is_prime_return
else_18:
	addi t2, x0, 6
	add t3, t4, t2
	addi t4, t3, 0
	jal x0, while_start_15
while_end_17:
	addi a0, x0, 1
	jal x0, is_prime_return
is_prime_return:
	lw s0, 8(sp)
	lw s1, 4(sp)
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
	addi sp, sp, -16
	sw t0, 4(sp)
	sw t1, 8(sp)
	sw t2, 12(sp)
	sw t3, 16(sp)
	jal ra, gcd
	lw t0, 4(sp)
	lw t1, 8(sp)
	lw t2, 12(sp)
	lw t3, 16(sp)
	addi sp, sp, 16
	addi s5, a0, 0
	addi a0, s5, 0
	addi sp, sp, -16
	sw t0, 4(sp)
	sw t1, 8(sp)
	sw t2, 12(sp)
	sw t3, 16(sp)
	jal ra, factorial
	lw t0, 4(sp)
	lw t1, 8(sp)
	lw t2, 12(sp)
	lw t3, 16(sp)
	addi sp, sp, 16
	addi s5, a0, 0
	addi s4, x0, 8
	addi a0, s4, 0
	addi sp, sp, -16
	sw t0, 4(sp)
	sw t1, 8(sp)
	sw t2, 12(sp)
	sw t3, 16(sp)
	jal ra, fibonacci
	lw t0, 4(sp)
	lw t1, 8(sp)
	lw t2, 12(sp)
	lw t3, 16(sp)
	addi sp, sp, 16
	addi s4, a0, 0
	add t4, s5, s4
	addi s6, x0, 0
	addi s5, x0, 87
	addi s6, s5, 0
	addi s4, x0, 0
	addi s5, x0, 1
while_start_21:
	addi s7, x0, 10
	blt s7, s5, while_end_23
	addi s8, x0, 2
	rem s7, s5, s8
	addi s9, x0, 0
	bne s7, s9, else_24
	mul s8, s5, s5
	add s7, s4, s8
	addi s4, s7, 0
	jal x0, endif_25
else_24:
	addi s7, x0, 3
	rem s8, s5, s7
	addi s9, x0, 0
	bne s8, s9, else_26
	mul s7, s5, s5
	mul s8, s7, s5
	add s9, s4, s8
	addi s4, s9, 0
	jal x0, endif_27
else_26:
	add s9, s4, s5
	addi s4, s9, 0
endif_27:
endif_25:
	addi s9, x0, 1
	add s8, s5, s9
	addi s5, s8, 0
	jal x0, while_start_21
while_end_23:
	addi s8, x0, 0
	addi s9, x0, 1
	addi s5, s9, 0
while_start_28:
	addi s9, x0, 5
	blt s9, s5, while_end_30
	addi s7, x0, 1
	addi s9, x0, 1
while_start_31:
	blt s5, s7, while_end_33
	mul s10, s9, s7
	addi s9, s10, 0
	addi s11, x0, 1
	add s10, s7, s11
	addi s7, s10, 0
	jal x0, while_start_31
while_end_33:
	add s10, s8, s9
	addi s8, s10, 0
	addi s9, x0, 1
	add s10, s5, s9
	addi s5, s10, 0
	jal x0, while_start_28
while_end_30:
	addi s10, x0, 0
	addi a0, s2, 0
	addi sp, sp, -20
	sw t0, 4(sp)
	sw t1, 8(sp)
	sw t2, 12(sp)
	sw t3, 16(sp)
	sw t4, 20(sp)
	jal ra, is_prime
	lw t0, 4(sp)
	lw t1, 8(sp)
	lw t2, 12(sp)
	lw t3, 16(sp)
	lw t4, 20(sp)
	addi sp, sp, 20
	addi s5, a0, 0
	beq s5, x0, else_34
	addi a0, s1, 0
	addi sp, sp, -20
	sw t0, 4(sp)
	sw t1, 8(sp)
	sw t2, 12(sp)
	sw t3, 16(sp)
	sw t4, 20(sp)
	jal ra, is_prime
	lw t0, 4(sp)
	lw t1, 8(sp)
	lw t2, 12(sp)
	lw t3, 16(sp)
	lw t4, 20(sp)
	addi sp, sp, 20
	addi s5, a0, 0
	beq s5, x0, else_36
	mul s9, s2, s1
	addi s10, s9, 0
	jal x0, endif_37
else_36:
	addi a0, s3, 0
	addi sp, sp, -20
	sw t0, 4(sp)
	sw t1, 8(sp)
	sw t2, 12(sp)
	sw t3, 16(sp)
	sw t4, 20(sp)
	jal ra, is_prime
	lw t0, 4(sp)
	lw t1, 8(sp)
	lw t2, 12(sp)
	lw t3, 16(sp)
	lw t4, 20(sp)
	addi sp, sp, 20
	addi s9, a0, 0
	beq s9, x0, else_38
	mul s5, s2, s3
	addi s10, s5, 0
	jal x0, endif_39
else_38:
	addi s10, s2, 0
endif_39:
endif_37:
	jal x0, endif_35
else_34:
	addi a0, s1, 0
	addi sp, sp, -20
	sw t0, 4(sp)
	sw t1, 8(sp)
	sw t2, 12(sp)
	sw t3, 16(sp)
	sw t4, 20(sp)
	jal ra, is_prime
	lw t0, 4(sp)
	lw t1, 8(sp)
	lw t2, 12(sp)
	lw t3, 16(sp)
	lw t4, 20(sp)
	addi sp, sp, 20
	addi s5, a0, 0
	beq s5, x0, else_40
	addi a0, s3, 0
	addi sp, sp, -20
	sw t0, 4(sp)
	sw t1, 8(sp)
	sw t2, 12(sp)
	sw t3, 16(sp)
	sw t4, 20(sp)
	jal ra, is_prime
	lw t0, 4(sp)
	lw t1, 8(sp)
	lw t2, 12(sp)
	lw t3, 16(sp)
	lw t4, 20(sp)
	addi sp, sp, 20
	addi s5, a0, 0
	beq s5, x0, else_42
	mul s9, s1, s3
	addi s10, s9, 0
	jal x0, endif_43
else_42:
	addi s10, s1, 0
endif_43:
	jal x0, endif_41
else_40:
	addi a0, s3, 0
	addi sp, sp, -20
	sw t0, 4(sp)
	sw t1, 8(sp)
	sw t2, 12(sp)
	sw t3, 16(sp)
	sw t4, 20(sp)
	jal ra, is_prime
	lw t0, 4(sp)
	lw t1, 8(sp)
	lw t2, 12(sp)
	lw t3, 16(sp)
	lw t4, 20(sp)
	addi sp, sp, 20
	addi s9, a0, 0
	beq s9, x0, else_44
	addi s10, s3, 0
	jal x0, endif_45
else_44:
	add s9, s2, s1
	add s5, s9, s3
	addi s10, s5, 0
endif_45:
endif_41:
endif_35:
	li s5, 2345
	addi s3, x0, 0
while_start_46:
	addi s9, x0, 0
	bge s9, s5, while_end_48
	addi s2, x0, 2
	rem s9, s5, s2
	addi s1, x0, 1
	bne s9, s1, else_49
	addi s2, x0, 1
	add s9, s3, s2
	addi s3, s9, 0
	jal x0, endif_50
else_49:
endif_50:
	srli s9, s5, 1
	addi s5, s9, 0
	jal x0, while_start_46
while_end_48:
	add s9, t0, t1
	add s5, s9, t2
	add t0, s5, t3
	add t2, t0, t4
	add t3, t2, s6
	add t4, t3, s4
	add t2, t4, s8
	add t3, t2, s10
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

