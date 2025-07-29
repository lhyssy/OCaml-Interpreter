.globl main
.text
factorial:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, x0, 1
	slt t2, t1, t0
	sub t3, t2, x0
	sltiu t3, t3, 1
	beq t3, x0, else_27
	addi a0, x0, 1
	jal x0, factorial_return
else_27:
endif_28:
	addi t3, x0, 1
	sub t2, t0, t3
	addi a0, t2, 0
	jal ra, factorial
	addi t2, a0, 0
	mul t3, t0, t2
	addi a0, t3, 0
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
	sub t3, t2, x0
	sltiu t3, t3, 1
	beq t3, x0, else_29
	addi a0, x0, 0
	jal x0, fibonacci_return
else_29:
endif_30:
	addi t3, x0, 1
	sub t2, t0, t3
	sub t1, t2, x0
	sltiu t1, t1, 1
	beq t1, x0, else_31
	addi a0, x0, 1
	jal x0, fibonacci_return
else_31:
endif_32:
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
	sub t4, t3, x0
	sltiu t4, t4, 1
	beq t4, x0, else_33
	addi a0, t0, 0
	jal x0, gcd_return
else_33:
endif_34:
	rem t4, t0, t1
	addi a0, t1, 0
	addi a1, t4, 0
	jal ra, gcd
	addi t4, a0, 0
	addi a0, t4, 0
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
	sub t3, t2, x0
	sltiu t3, t3, 1
	beq t3, x0, else_35
	addi a0, x0, 0
	jal x0, is_prime_return
else_35:
endif_36:
	addi t3, x0, 3
	slt t2, t3, t0
	sub t1, t2, x0
	sltiu t1, t1, 1
	beq t1, x0, else_37
	addi a0, x0, 1
	jal x0, is_prime_return
else_37:
endif_38:
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
	bne t4, x0, or_true_39
	bne s1, x0, or_true_39
	addi t4, x0, 0
	jal x0, or_end_40
or_true_39:
	addi t4, x0, 1
or_end_40:
	beq t4, x0, else_41
	addi a0, x0, 0
	jal x0, is_prime_return
else_41:
endif_42:
	addi t4, x0, 5
while_start_43:
	mul s1, t4, t4
	slt t2, t0, s1
	sub t1, t2, x0
	sltiu t1, t1, 1
	beq t1, x0, while_end_45
	rem t2, t0, t4
	addi t1, x0, 0
	sub s1, t2, t1
	sub t3, s1, x0
	sltiu t3, t3, 1
	addi t2, x0, 2
	add s1, t4, t2
	rem t1, t0, s1
	addi t2, x0, 0
	sub t0, t1, t2
	sub s1, t0, x0
	sltiu s1, s1, 1
	bne t3, x0, or_true_46
	bne s1, x0, or_true_46
	addi t3, x0, 0
	jal x0, or_end_47
or_true_46:
	addi t3, x0, 1
or_end_47:
	beq t3, x0, else_48
	addi a0, x0, 0
	jal x0, is_prime_return
else_48:
endif_49:
	addi t3, x0, 6
	add s1, t4, t3
	addi t4, s1, 0
while_continue_44:
	jal x0, while_start_43
while_end_45:
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
	addi t4, x0, 0
	addi t3, x0, 1
	addi t4, t3, 0
	addi s1, x0, 42
	addi t3, x0, 56
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
	addi s6, x0, 0
	addi s4, x0, 87
	addi s6, s4, 0
	addi s3, x0, 0
	addi s4, x0, 1
while_start_50:
	addi s7, x0, 10
	slt s8, s7, s4
	sub s9, s8, x0
	sltiu s9, s9, 1
	beq s9, x0, while_end_52
	addi s8, x0, 2
	rem s9, s4, s8
	addi s7, x0, 0
	sub s8, s9, s7
	sub s10, s8, x0
	sltiu s10, s10, 1
	beq s10, x0, else_53
	mul s8, s4, s4
	add s10, s3, s8
	addi s3, s10, 0
	jal x0, endif_54
else_53:
	addi s10, x0, 3
	rem s8, s4, s10
	addi s9, x0, 0
	sub s10, s8, s9
	sub s7, s10, x0
	sltiu s7, s7, 1
	beq s7, x0, else_55
	mul s10, s4, s4
	mul s7, s10, s4
	add s8, s3, s7
	addi s3, s8, 0
	jal x0, endif_56
else_55:
	add s8, s3, s4
	addi s3, s8, 0
endif_56:
endif_54:
	addi s8, x0, 1
	add s7, s4, s8
	addi s4, s7, 0
while_continue_51:
	jal x0, while_start_50
while_end_52:
	addi s7, x0, 0
	addi s8, x0, 1
	addi s4, s8, 0
while_start_57:
	addi s8, x0, 5
	slt s10, s8, s4
	sub s9, s10, x0
	sltiu s9, s9, 1
	beq s9, x0, while_end_59
	addi s10, x0, 1
	addi s9, x0, 1
while_start_60:
	slt s8, s4, s10
	sub s11, s8, x0
	sltiu s11, s11, 1
	beq s11, x0, while_end_62
	mul s8, s9, s10
	addi s9, s8, 0
	addi s11, x0, 1
	add s8, s10, s11
	addi s10, s8, 0
while_continue_61:
	jal x0, while_start_60
while_end_62:
	add s8, s7, s9
	addi s7, s8, 0
	addi s9, x0, 1
	add s8, s4, s9
	addi s4, s8, 0
while_continue_58:
	jal x0, while_start_57
while_end_59:
	addi s8, x0, 0
	addi a0, s1, 0
	jal ra, is_prime
	addi s4, a0, 0
	beq s4, x0, else_63
	addi a0, t3, 0
	jal ra, is_prime
	addi s4, a0, 0
	beq s4, x0, else_65
	mul s9, s1, t3
	addi s8, s9, 0
	jal x0, endif_66
else_65:
	addi a0, s2, 0
	jal ra, is_prime
	addi s9, a0, 0
	beq s9, x0, else_67
	mul s4, s1, s2
	addi s8, s4, 0
	jal x0, endif_68
else_67:
	addi s8, s1, 0
endif_68:
endif_66:
	jal x0, endif_64
else_63:
	addi a0, t3, 0
	jal ra, is_prime
	addi s4, a0, 0
	beq s4, x0, else_69
	addi a0, s2, 0
	jal ra, is_prime
	addi s4, a0, 0
	beq s4, x0, else_71
	mul s9, t3, s2
	addi s8, s9, 0
	jal x0, endif_72
else_71:
	addi s8, t3, 0
endif_72:
	jal x0, endif_70
else_69:
	addi a0, s2, 0
	jal ra, is_prime
	addi s9, a0, 0
	beq s9, x0, else_73
	addi s8, s2, 0
	jal x0, endif_74
else_73:
	add s9, s1, t3
	add s4, s9, s2
	addi s8, s4, 0
endif_74:
endif_70:
endif_64:
	li s4, 2345
	addi s2, x0, 0
while_start_75:
	addi s9, x0, 0
	slt s1, s9, s4
	beq s1, x0, while_end_77
	addi s9, x0, 2
	rem s1, s4, s9
	addi t3, x0, 1
	sub s9, s1, t3
	sub s10, s9, x0
	sltiu s10, s10, 1
	beq s10, x0, else_78
	addi s9, x0, 1
	add s10, s2, s9
	addi s2, s10, 0
	jal x0, endif_79
else_78:
endif_79:
	srli s10, s4, 1
	addi s4, s10, 0
while_continue_76:
	jal x0, while_start_75
while_end_77:
	add s10, t0, t1
	add s4, s10, t2
	add t0, s4, t4
	add t2, t0, s5
	add t4, t2, s6
	add s5, t4, s3
	add s6, s5, s7
	add s3, s6, s8
	add s7, s3, s2
	addi s8, x0, 256
	rem s2, s7, s8
	addi a0, s2, 0
	jal x0, main_return

main_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

