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
	rem t1, t0, t1
	addi t2, x0, 0
	sub t1, t1, t2
	sub t1, t1, x0
	sltiu t1, t1, 1
	bne t1, x0, or_true_14
	addi t1, x0, 3
	rem t1, t0, t1
	bne t1, x0, else_12
or_true_14:
	addi a0, x0, 0
	jal x0, is_prime_return
else_12:
	addi t1, x0, 5
while_start_15:
	mul t2, t1, t1
	blt t0, t2, while_end_17
	rem t2, t0, t1
	addi t3, x0, 0
	sub t2, t2, t3
	sub t2, t2, x0
	sltiu t2, t2, 1
	bne t2, x0, or_true_20
	addi t2, x0, 2
	add t2, t1, t2
	rem t2, t0, t2
	bne t2, x0, else_18
or_true_20:
	addi a0, x0, 0
	jal x0, is_prime_return
else_18:
	addi t1, t1, 6
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
	addi s1, x0, 1
	addi s2, x0, 2
	addi s3, x0, 3
	addi s4, x0, 4
	add s5, s1, s2
	mul s5, s5, s3
	mul s6, s4, s1
	add s5, s5, s6
	add s6, s2, s3
	addi s7, x0, 0
	sub s7, s7, s4
	add s7, s1, s7
	li s8, 2048
	add s7, s7, s8
	rem s6, s6, s7
	addi s7, x0, 1
	add s6, s6, s7
	div s5, s5, s6
	mul s1, s1, s2
	mul s1, s1, s3
	addi s2, x0, 2
	sub s4, s4, s2
	sub s3, s4, s3
	mul s1, s1, s3
	add t0, s5, s1
	addi s5, x0, 0
	addi s1, x0, 1
	addi s3, x0, 2
	addi t1, x0, 0
	bge s1, s5, else_21
	addi s4, x0, 1
	add s4, s3, s4
	addi s2, x0, 1
	bne s4, s2, else_21
	addi t1, x0, 1
	jal x0, endif_22
else_21:
endif_22:
	addi t2, x0, 0
	slt s4, s5, s1
	bne s4, x0, or_true_25
	addi s4, x0, 2
	add s4, s3, s4
	addi s2, x0, 2
	bne s4, s2, else_23
or_true_25:
	addi t2, x0, 1
	jal x0, endif_24
else_23:
endif_24:
	addi t3, x0, 0
	addi s4, x0, 0
	slt s4, s4, s5
	addi s2, x0, 0
	slt s2, s1, s2
	beq s4, x0, and_false_28
	beq s2, x0, and_false_28
	addi s2, x0, 1
	jal x0, and_end_29
and_false_28:
	addi s2, x0, 0
and_end_29:
	addi s4, x0, 0
	slt s3, s4, s3
	addi s4, x0, 0
	slt s4, s5, s4
	beq s3, x0, and_false_30
	beq s4, x0, and_false_30
	addi s4, x0, 1
	jal x0, and_end_31
and_false_30:
	addi s4, x0, 0
and_end_31:
	bne s2, x0, or_true_32
	bne s4, x0, or_true_32
	addi s4, x0, 0
	jal x0, or_end_33
or_true_32:
	addi s4, x0, 1
or_end_33:
	bne s4, x0, else_26
	addi s4, x0, 0
	slt s1, s4, s1
	bne s1, x0, or_true_34
	bge s5, zero, else_26
or_true_34:
	addi t3, x0, 1
	jal x0, endif_27
else_26:
endif_27:
	addi s5, x0, 42
	addi s1, x0, 56
	addi s4, x0, 87
	addi sp, sp, -16
	sw t0, 0(sp)
	sw t1, 4(sp)
	sw t2, 8(sp)
	sw t3, 12(sp)
	addi a0, s1, 0
	addi a1, s4, 0
	jal ra, gcd
	lw t0, 0(sp)
	lw t1, 4(sp)
	lw t2, 8(sp)
	lw t3, 12(sp)
	addi sp, sp, 16
	addi s2, a0, 0
	addi sp, sp, -16
	sw t0, 0(sp)
	sw t1, 4(sp)
	sw t2, 8(sp)
	sw t3, 12(sp)
	addi a0, s2, 0
	jal ra, factorial
	lw t0, 0(sp)
	lw t1, 4(sp)
	lw t2, 8(sp)
	lw t3, 12(sp)
	addi sp, sp, 16
	addi s2, a0, 0
	addi s3, x0, 5
	div s3, s5, s3
	addi sp, sp, -16
	sw t0, 0(sp)
	sw t1, 4(sp)
	sw t2, 8(sp)
	sw t3, 12(sp)
	addi a0, s3, 0
	jal ra, fibonacci
	lw t0, 0(sp)
	lw t1, 4(sp)
	lw t2, 8(sp)
	lw t3, 12(sp)
	addi sp, sp, 16
	addi s3, a0, 0
	add t4, s2, s3
	addi s2, x0, 0
	bge s1, s5, else_35
	bge s4, s5, else_35
	addi s2, s5, 0
	jal x0, endif_36
else_35:
	bge s5, s1, else_37
	bge s4, s1, else_37
	addi s2, s1, 0
	jal x0, endif_38
else_37:
	addi s2, s4, 0
endif_38:
endif_36:
	addi s3, x0, 0
	addi s6, x0, 1
while_start_39:
	addi s7, x0, 10
	blt s7, s6, while_end_41
	addi s7, x0, 2
	rem s7, s6, s7
	bne s7, x0, else_42
	mul s7, s6, s6
	add s3, s3, s7
	jal x0, endif_43
else_42:
	addi s7, x0, 3
	rem s7, s6, s7
	bne s7, x0, else_44
	mul s7, s6, s6
	mul s7, s7, s6
	add s3, s3, s7
	jal x0, endif_45
else_44:
	add s3, s3, s6
endif_45:
endif_43:
	addi s6, s6, 1
	jal x0, while_start_39
while_end_41:
	addi s7, x0, 0
	addi s6, x0, 1
while_start_46:
	addi s8, x0, 5
	blt s8, s6, while_end_48
	addi s8, x0, 1
	addi s9, x0, 1
while_start_49:
	blt s6, s8, while_end_51
	mul s9, s9, s8
	addi s8, s8, 1
	jal x0, while_start_49
while_end_51:
	add s7, s7, s9
	addi s6, s6, 1
	jal x0, while_start_46
while_end_48:
	addi s6, x0, 0
	addi sp, sp, -20
	sw t0, 0(sp)
	sw t1, 4(sp)
	sw t2, 8(sp)
	sw t3, 12(sp)
	sw t4, 16(sp)
	addi a0, s5, 0
	jal ra, is_prime
	lw t0, 0(sp)
	lw t1, 4(sp)
	lw t2, 8(sp)
	lw t3, 12(sp)
	lw t4, 16(sp)
	addi sp, sp, 20
	addi s9, a0, 0
	beq s9, x0, else_52
	addi sp, sp, -20
	sw t0, 0(sp)
	sw t1, 4(sp)
	sw t2, 8(sp)
	sw t3, 12(sp)
	sw t4, 16(sp)
	addi a0, s1, 0
	jal ra, is_prime
	lw t0, 0(sp)
	lw t1, 4(sp)
	lw t2, 8(sp)
	lw t3, 12(sp)
	lw t4, 16(sp)
	addi sp, sp, 20
	addi s9, a0, 0
	beq s9, x0, else_54
	mul s6, s5, s1
	jal x0, endif_55
else_54:
	addi sp, sp, -20
	sw t0, 0(sp)
	sw t1, 4(sp)
	sw t2, 8(sp)
	sw t3, 12(sp)
	sw t4, 16(sp)
	addi a0, s4, 0
	jal ra, is_prime
	lw t0, 0(sp)
	lw t1, 4(sp)
	lw t2, 8(sp)
	lw t3, 12(sp)
	lw t4, 16(sp)
	addi sp, sp, 20
	addi s9, a0, 0
	beq s9, x0, else_56
	mul s6, s5, s4
	jal x0, endif_57
else_56:
	addi s6, s5, 0
endif_57:
endif_55:
	jal x0, endif_53
else_52:
	addi sp, sp, -20
	sw t0, 0(sp)
	sw t1, 4(sp)
	sw t2, 8(sp)
	sw t3, 12(sp)
	sw t4, 16(sp)
	addi a0, s1, 0
	jal ra, is_prime
	lw t0, 0(sp)
	lw t1, 4(sp)
	lw t2, 8(sp)
	lw t3, 12(sp)
	lw t4, 16(sp)
	addi sp, sp, 20
	addi s9, a0, 0
	beq s9, x0, else_58
	addi sp, sp, -20
	sw t0, 0(sp)
	sw t1, 4(sp)
	sw t2, 8(sp)
	sw t3, 12(sp)
	sw t4, 16(sp)
	addi a0, s4, 0
	jal ra, is_prime
	lw t0, 0(sp)
	lw t1, 4(sp)
	lw t2, 8(sp)
	lw t3, 12(sp)
	lw t4, 16(sp)
	addi sp, sp, 20
	addi s9, a0, 0
	beq s9, x0, else_60
	mul s6, s1, s4
	jal x0, endif_61
else_60:
	addi s6, s1, 0
endif_61:
	jal x0, endif_59
else_58:
	addi sp, sp, -20
	sw t0, 0(sp)
	sw t1, 4(sp)
	sw t2, 8(sp)
	sw t3, 12(sp)
	sw t4, 16(sp)
	addi a0, s4, 0
	jal ra, is_prime
	lw t0, 0(sp)
	lw t1, 4(sp)
	lw t2, 8(sp)
	lw t3, 12(sp)
	lw t4, 16(sp)
	addi sp, sp, 20
	addi s9, a0, 0
	beq s9, x0, else_62
	addi s6, s4, 0
	jal x0, endif_63
else_62:
	add s5, s5, s1
	add s6, s5, s4
endif_63:
endif_59:
endif_53:
	li s4, 2345
	addi s5, x0, 0
while_start_64:
	bge zero, s4, while_end_66
	addi s1, x0, 2
	rem s1, s4, s1
	addi s9, x0, 1
	bne s1, s9, else_67
	addi s5, s5, 1
	jal x0, endif_68
else_67:
endif_68:
	srli s4, s4, 1
	jal x0, while_start_64
while_end_66:
	add t0, t0, t1
	add t2, t0, t2
	add t3, t2, t3
	add t4, t3, t4
	add t4, t4, s2
	add t4, t4, s3
	add t4, t4, s7
	add t4, t4, s6
	add t4, t4, s5
	addi t3, x0, 256
	rem t4, t4, t3
	addi a0, t4, 0
	jal x0, main_return
main_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

