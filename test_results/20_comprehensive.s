.globl main
.text
fibonacci:
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
	addi a0, s1, 0
	jal x0, fibonacci_return
else_0:
	addi s4, x0, 1
	sub s3, s1, s4
	addi a0, s3, 0
	jal ra, fibonacci
	addi t0, a0, 0
	addi s3, x0, 2
	sub s4, s1, s3
	addi a0, s4, 0
	jal ra, fibonacci
	addi t1, a0, 0
	add t2, t0, t1
	addi a0, t2, 0
	jal x0, fibonacci_return
endif_1:

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
	beq s5, x0, else_2
	addi a0, s1, 0
	jal x0, gcd_return
else_2:
endif_3:
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

isPrime:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, x0, 1
	slt t2, t1, t0
	sub t3, t2, x0
	sltiu t3, t3, 1
	beq t3, x0, else_4
	addi a0, x0, 0
	jal x0, isPrime_return
else_4:
endif_5:
	addi t3, x0, 3
	slt t2, t3, t0
	sub t1, t2, x0
	sltiu t1, t1, 1
	beq t1, x0, else_6
	addi a0, x0, 1
	jal x0, isPrime_return
else_6:
endif_7:
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
	bne t4, x0, or_true_8
	bne s1, x0, or_true_8
	addi t4, x0, 0
	jal x0, or_end_9
or_true_8:
	addi t4, x0, 1
or_end_9:
	beq t4, x0, else_10
	addi a0, x0, 0
	jal x0, isPrime_return
else_10:
endif_11:
	addi t4, x0, 5
while_start_12:
	mul t2, t4, t4
	slt t1, t0, t2
	sub t3, t1, x0
	sltiu t3, t3, 1
	beq t3, x0, while_end_14
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
	bne s1, x0, or_true_15
	bne t2, x0, or_true_15
	addi t0, x0, 0
	jal x0, or_end_16
or_true_15:
	addi t0, x0, 1
or_end_16:
	beq t0, x0, else_17
	addi a0, x0, 0
	jal x0, isPrime_return
else_17:
endif_18:
	addi t0, x0, 6
	add t2, t4, t0
	addi t4, t2, 0
while_continue_13:
	jal x0, while_start_12
while_end_14:
	addi a0, x0, 1
	jal x0, isPrime_return

isPrime_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

factorial:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, x0, 1
while_start_19:
	addi t2, x0, 0
	slt t3, t2, t0
	beq t3, x0, while_end_21
	mul t2, t1, t0
	addi t1, t2, 0
	addi t3, x0, 1
	sub t2, t0, t3
	addi t0, t2, 0
while_continue_20:
	jal x0, while_start_19
while_end_21:
	addi a0, t1, 0
	jal x0, factorial_return

factorial_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

combination:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	addi s1, a0, 0
	addi s2, a1, 0
	slt s3, s1, s2
	beq s3, x0, else_22
	addi a0, x0, 0
	jal x0, combination_return
else_22:
endif_23:
	addi s3, x0, 0
	sub s4, s2, s3
	sub s5, s4, x0
	sltiu s5, s5, 1
	sub s3, s2, s1
	sub s4, s3, x0
	sltiu s4, s4, 1
	bne s5, x0, or_true_24
	bne s4, x0, or_true_24
	addi s5, x0, 0
	jal x0, or_end_25
or_true_24:
	addi s5, x0, 1
or_end_25:
	beq s5, x0, else_26
	addi a0, x0, 1
	jal x0, combination_return
else_26:
endif_27:
	addi a0, s1, 0
	jal ra, factorial
	addi t0, a0, 0
	addi a0, s2, 0
	jal ra, factorial
	addi t1, a0, 0
	sub s5, s1, s2
	addi a0, s5, 0
	jal ra, factorial
	addi t2, a0, 0
	mul t3, t1, t2
	div t4, t0, t3
	addi a0, t4, 0
	jal x0, combination_return

combination_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

power:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, a1, 0
	addi t2, x0, 1
while_start_28:
	addi t3, x0, 0
	slt t4, t3, t1
	beq t4, x0, while_end_30
	addi t3, x0, 2
	rem t4, t1, t3
	addi s1, x0, 1
	sub t3, t4, s1
	sub s2, t3, x0
	sltiu s2, s2, 1
	beq s2, x0, else_31
	mul t3, t2, t0
	addi t2, t3, 0
	jal x0, endif_32
else_31:
endif_32:
	mul t3, t0, t0
	addi t0, t3, 0
	srli t0, t1, 1
	addi t1, t0, 0
while_continue_29:
	jal x0, while_start_28
while_end_30:
	addi a0, t2, 0
	jal x0, power_return

power_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

complexFunction:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, a1, 0
	addi t2, a2, 0
	addi t3, x0, 0
	slt t4, t1, t0
	slt s1, t2, t1
	beq t4, x0, and_false_33
	beq s1, x0, and_false_33
	addi t4, x0, 1
	jal x0, and_end_34
and_false_33:
	addi t4, x0, 0
and_end_34:
	sub s1, t4, x0
	sltiu s1, s1, 1
	beq s1, x0, else_35
	mul t4, t0, t1
	addi s1, x0, -1
	add s2, t2, s1
	addi s3, x0, 0
	sub s1, s3, s2
	sub s4, t4, s1
	addi t3, s4, 0
	jal x0, endif_36
else_35:
	slt t4, t0, t2
	sub s4, t4, x0
	sltiu s4, s4, 1
	slt s1, t2, t1
	bne s4, x0, or_true_37
	bne s1, x0, or_true_37
	addi t4, x0, 0
	jal x0, or_end_38
or_true_37:
	addi t4, x0, 1
or_end_38:
	beq t4, x0, else_39
	sub s1, t2, t1
	addi t4, x0, -2
	sub s4, s1, t4
	mul s2, t0, s4
	addi t3, s2, 0
	jal x0, endif_40
else_39:
	slt t4, t1, t0
	sub s2, t4, x0
	sltiu s2, s2, 1
	slt s4, t0, t2
	sub t4, s4, x0
	sltiu t4, t4, 1
	beq s2, x0, and_false_41
	beq t4, x0, and_false_41
	addi s2, x0, 1
	jal x0, and_end_42
and_false_41:
	addi s2, x0, 0
and_end_42:
	slt t4, t2, t1
	sub s4, t4, x0
	sltiu s4, s4, 1
	bne s2, x0, or_true_43
	bne s4, x0, or_true_43
	addi t4, x0, 0
	jal x0, or_end_44
or_true_43:
	addi t4, x0, 1
or_end_44:
	beq t4, x0, else_45
	mul s4, t1, t0
	addi t4, x0, -3
	add s2, t2, t4
	addi s1, x0, 0
	sub t4, s1, s2
	sub s3, s4, t4
	addi t3, s3, 0
	jal x0, endif_46
else_45:
	slt t4, t2, t1
	slt s3, t0, t2
	slt s4, t1, t0
	sub s2, s4, x0
	sltiu s2, s2, 1
	beq s3, x0, and_false_47
	beq s2, x0, and_false_47
	addi s3, x0, 1
	jal x0, and_end_48
and_false_47:
	addi s3, x0, 0
and_end_48:
	bne t4, x0, or_true_49
	bne s3, x0, or_true_49
	addi t4, x0, 0
	jal x0, or_end_50
or_true_49:
	addi t4, x0, 1
or_end_50:
	beq t4, x0, else_51
	sub s3, t2, t0
	addi t4, x0, -4
	sub s2, s3, t4
	mul s4, t1, s2
	addi t3, s4, 0
	jal x0, endif_52
else_51:
	slt t4, t0, t2
	sub s4, t1, t0
	sub s2, s4, x0
	sltu s2, x0, s2
	bne t4, x0, or_true_53
	bne s2, x0, or_true_53
	addi t4, x0, 0
	jal x0, or_end_54
or_true_53:
	addi t4, x0, 1
or_end_54:
	sub s2, t4, x0
	sltiu s2, s2, 1
	sub s4, t0, t1
	sub t4, s4, x0
	sltiu t4, t4, 1
	beq s2, x0, and_false_55
	beq t4, x0, and_false_55
	addi s2, x0, 1
	jal x0, and_end_56
and_false_55:
	addi s2, x0, 0
and_end_56:
	beq s2, x0, else_57
	mul t4, t2, t0
	addi s2, x0, -5
	add s4, t1, s2
	sub s3, t4, s4
	addi t3, s3, 0
	jal x0, endif_58
else_57:
	addi t4, x0, 0
	sub s3, t4, t0
	sub s4, t1, s3
	addi t0, x0, -6
	sub t1, s4, t0
	mul t4, t2, t1
	addi t3, t4, 0
endif_58:
endif_52:
endif_46:
endif_40:
endif_36:
	addi t4, x0, 0
while_start_59:
	addi t2, x0, 10
	slt t1, t4, t2
	beq t1, x0, while_end_61
	addi t2, x0, 1
	add t1, t4, t2
	addi t4, t1, 0
	addi t2, x0, 3
	rem t1, t4, t2
	addi t0, x0, 0
	sub t2, t1, t0
	sub s4, t2, x0
	sltiu s4, s4, 1
	beq s4, x0, else_62
	add t2, t3, t4
	addi t3, t2, 0
	jal x0, endif_63
else_62:
	addi t2, x0, 3
	rem t1, t4, t2
	addi t0, x0, 1
	sub t2, t1, t0
	sub s4, t2, x0
	sltiu s4, s4, 1
	beq s4, x0, else_64
	sub t2, t3, t4
	addi t3, t2, 0
	jal x0, endif_65
else_64:
	slli t2, t3, 1
	addi t3, t2, 0
	addi t4, x0, 50
	slt t2, t3, t4
	beq t2, x0, else_66
	jal x0, while_continue_60
else_66:
endif_67:
	addi t2, x0, 1
	add t4, t3, t2
	addi t3, t4, 0
	addi t2, x0, 100
	slt t4, t2, t3
	beq t4, x0, else_68
	jal x0, while_end_61
else_68:
endif_69:
endif_65:
endif_63:
while_continue_60:
	jal x0, while_start_59
while_end_61:
	addi a0, t3, 0
	jal x0, complexFunction_return

complexFunction_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

shortCircuit:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, a1, 0
	addi t2, x0, 0
	slt t3, t2, t0
	div t4, t1, t0
	addi t2, x0, 2
	slt s1, t2, t4
	beq t3, x0, and_false_70
	beq s1, x0, and_false_70
	addi t3, x0, 1
	jal x0, and_end_71
and_false_70:
	addi t3, x0, 0
and_end_71:
	beq t3, x0, else_72
	jal x0, endif_73
else_72:
endif_73:
	addi t3, x0, 0
	slt t4, t0, t3
	addi t2, x0, 0
	slt t0, t1, t2
	bne t4, x0, or_true_74
	bne t0, x0, or_true_74
	addi t4, x0, 0
	jal x0, or_end_75
or_true_74:
	addi t4, x0, 1
or_end_75:
	beq t4, x0, else_76
	jal x0, endif_77
else_76:
endif_77:
	addi a0, x0, 0
	jal x0, shortCircuit_return

shortCircuit_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

nestedLoopsAndConditions:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, x0, 0
	addi t2, x0, 0
while_start_78:
	slt t3, t2, t0
	beq t3, x0, while_end_80
	addi t0, x0, 0
while_start_81:
	slt t3, t0, t2
	beq t3, x0, while_end_83
	add t4, t2, t0
	addi t3, x0, 2
	rem s1, t4, t3
	addi s2, x0, 0
	sub t4, s1, s2
	sub t3, t4, x0
	sltiu t3, t3, 1
	beq t3, x0, else_84
	mul t4, t2, t0
	sub t3, t1, t4
	addi t1, t3, 0
	jal x0, endif_85
else_84:
	mul t3, t2, t0
	add t4, t1, t3
	addi t1, t4, 0
	addi t3, x0, 0
	slt t4, t1, t3
	beq t4, x0, else_86
	addi t3, x0, 0
	addi t1, t3, 0
	jal x0, while_continue_82
else_86:
endif_87:
endif_85:
	addi t3, x0, 1053
	slt t4, t3, t1
	beq t4, x0, else_88
	jal x0, while_end_83
else_88:
endif_89:
	addi t4, x0, 1
	add t3, t0, t4
	addi t0, t3, 0
while_continue_82:
	jal x0, while_start_81
while_end_83:
	addi t3, x0, 913
	slt t0, t3, t1
	beq t0, x0, else_90
	jal x0, while_end_80
else_90:
endif_91:
	addi t0, x0, 1
	add t3, t2, t0
	addi t2, t3, 0
while_continue_79:
	jal x0, while_start_78
while_end_80:
	addi a0, t1, 0
	jal x0, nestedLoopsAndConditions_return

nestedLoopsAndConditions_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

func1:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	addi s1, a0, 0
	addi s2, a1, 0
	addi s3, a2, 0
	addi s4, x0, 0
	sub s5, s3, s4
	sub s6, s5, x0
	sltiu s6, s6, 1
	beq s6, x0, else_92
	mul s5, s1, s2
	addi a0, s5, 0
	jal x0, func1_return
else_92:
	sub s5, s2, s3
	addi s6, x0, 0
	addi a0, s1, 0
	addi a1, s5, 0
	addi a2, s6, 0
	jal ra, func1
	addi t0, a0, 0
	addi a0, t0, 0
	jal x0, func1_return
endif_93:

func1_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

func2:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	addi s1, a0, 0
	addi s2, a1, 0
	beq s2, x0, else_94
	rem s3, s1, s2
	addi s4, x0, 0
	addi a0, s3, 0
	addi a1, s4, 0
	jal ra, func2
	addi t0, a0, 0
	addi a0, t0, 0
	jal x0, func2_return
else_94:
	addi a0, s1, 0
	jal x0, func2_return
endif_95:

func2_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

func3:
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
	beq s5, x0, else_96
	addi s4, x0, 1
	add s5, s1, s4
	addi a0, s5, 0
	jal x0, func3_return
else_96:
	add s5, s1, s2
	addi s4, x0, 0
	addi a0, s5, 0
	addi a1, s4, 0
	jal ra, func3
	addi t0, a0, 0
	addi a0, t0, 0
	jal x0, func3_return
endif_97:

func3_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

func4:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, a1, 0
	addi t2, a2, 0
	beq t0, x0, else_98
	addi a0, t1, 0
	jal x0, func4_return
else_98:
	addi a0, t2, 0
	jal x0, func4_return
endif_99:

func4_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

func5:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, x0, 0
	sub t2, t1, t0
	addi a0, t2, 0
	jal x0, func5_return

func5_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

func6:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, a1, 0
	beq t0, x0, and_false_100
	beq t1, x0, and_false_100
	addi t0, x0, 1
	jal x0, and_end_101
and_false_100:
	addi t0, x0, 0
and_end_101:
	beq t0, x0, else_102
	addi a0, x0, 1
	jal x0, func6_return
else_102:
	addi a0, x0, 0
	jal x0, func6_return
endif_103:

func6_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

func7:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	sub t1, t0, x0
	sltiu t1, t1, 1
	beq t1, x0, else_104
	addi a0, x0, 1
	jal x0, func7_return
else_104:
	addi a0, x0, 0
	jal x0, func7_return
endif_105:

func7_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

nestedCalls:
	addi sp, sp, -32
	sw ra, 28(sp)
	sw s0, 24(sp)
	addi s0, sp, 32
	addi s1, a0, 0
	addi s2, a1, 0
	addi s3, a2, 0
	addi t5, a3, 0
	sw t5, -12(s0)
	addi s5, a4, 0
	addi s6, a5, 0
	addi s7, a6, 0
	addi t5, a7, 0
	sw t5, -4(s0)
	lw s9, 0(s0)
	lw t5, 4(s0)
	sw t5, -8(s0)
	addi s11, x0, 2
	addi a0, s11, 0
	jal ra, func7
	addi s11, a0, 0
	addi s4, x0, 8
	addi a0, s4, 0
	jal ra, func5
	addi s4, a0, 0
	addi a0, s11, 0
	addi a1, s4, 0
	jal ra, func6
	addi s4, a0, 0
	addi s11, x0, 8
	addi a0, s4, 0
	addi a1, s11, 0
	jal ra, func2
	addi s11, a0, 0
	addi s4, x0, 9
	addi a0, s11, 0
	addi a1, s4, 0
	jal ra, func3
	addi s4, a0, 0
	addi a0, s4, 0
	jal ra, func5
	addi s4, a0, 0
	addi a0, s2, 0
	jal ra, func5
	addi s11, a0, 0
	lw t5, -12(s0)
	addi a0, t5, 0
	jal ra, func7
	addi s10, a0, 0
	addi a0, s3, 0
	addi a1, s10, 0
	jal ra, func6
	addi s10, a0, 0
	addi a0, s6, 0
	jal ra, func7
	addi s8, a0, 0
	addi a0, s5, 0
	addi a1, s8, 0
	jal ra, func2
	addi s8, a0, 0
	addi a0, s11, 0
	addi a1, s10, 0
	addi a2, s8, 0
	jal ra, func4
	addi s8, a0, 0
	addi a0, s8, 0
	addi a1, s7, 0
	jal ra, func3
	addi s8, a0, 0
	addi a0, s8, 0
	lw t5, -4(s0)
	addi a1, t5, 0
	jal ra, func2
	addi s8, a0, 0
	lw t5, -8(s0)
	addi a0, t5, 0
	jal ra, func7
	addi s10, a0, 0
	addi a0, s9, 0
	addi a1, s10, 0
	jal ra, func3
	addi s10, a0, 0
	addi s11, x0, 2
	addi a0, s8, 0
	addi a1, s10, 0
	addi a2, s11, 0
	jal ra, func1
	addi s11, a0, 0
	addi a0, s4, 0
	addi a1, s1, 0
	addi a2, s11, 0
	jal ra, func4
	addi s11, a0, 0
	addi s4, x0, 8
	addi s10, x0, 8
	addi a0, s10, 0
	jal ra, func7
	addi s10, a0, 0
	addi s8, x0, 9
	addi a0, s10, 0
	addi a1, s8, 0
	jal ra, func3
	addi s8, a0, 0
	addi a0, s4, 0
	addi a1, s8, 0
	jal ra, func2
	addi s8, a0, 0
	addi a0, s11, 0
	addi a1, s8, 0
	jal ra, func3
	addi s8, a0, 0
	addi a0, s8, 0
	addi a1, s1, 0
	addi a2, s2, 0
	jal ra, func1
	addi s2, a0, 0
	addi a0, s2, 0
	addi a1, s3, 0
	jal ra, func2
	addi s3, a0, 0
	addi a0, s6, 0
	jal ra, func5
	addi s6, a0, 0
	addi a0, s5, 0
	addi a1, s6, 0
	jal ra, func3
	addi s6, a0, 0
	addi a0, s7, 0
	jal ra, func5
	addi s7, a0, 0
	addi a0, s6, 0
	addi a1, s7, 0
	jal ra, func2
	addi s7, a0, 0
	addi a0, s9, 0
	jal ra, func7
	addi s9, a0, 0
	addi a0, s7, 0
	lw t5, -4(s0)
	addi a1, t5, 0
	addi a2, s9, 0
	jal ra, func1
	addi s9, a0, 0
	lw t5, -8(s0)
	addi a0, t5, 0
	jal ra, func5
	addi s7, a0, 0
	addi a0, s9, 0
	addi a1, s7, 0
	jal ra, func2
	addi s7, a0, 0
	addi s9, x0, 2
	addi a0, s7, 0
	addi a1, s9, 0
	jal ra, func3
	addi s9, a0, 0
	addi a0, s3, 0
	lw t5, -12(s0)
	addi a1, t5, 0
	addi a2, s9, 0
	jal ra, func1
	addi t0, a0, 0
	addi a0, t0, 0
	jal x0, nestedCalls_return

nestedCalls_return:
	lw ra, 28(sp)
	lw s0, 24(sp)
	addi sp, sp, 32
	jalr x0, ra, 0

main:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t5, x0, 0
	sw t5, -4(s0)
	addi s1, x0, 12
	addi a0, s1, 0
	jal ra, fibonacci
	addi t1, a0, 0
	addi s1, x0, 22
	addi s2, x0, 15
	addi a0, s1, 0
	addi a1, s2, 0
	jal ra, gcd
	addi t2, a0, 0
	addi s2, x0, 17
	addi a0, s2, 0
	jal ra, isPrime
	addi t3, a0, 0
	addi s2, x0, 8
	addi a0, s2, 0
	jal ra, factorial
	addi t4, a0, 0
	addi s2, x0, 7
	addi s1, x0, 3
	addi a0, s2, 0
	addi a1, s1, 0
	jal ra, combination
	addi s1, a0, 0
	addi s2, x0, 3
	addi s3, x0, 11
	addi a0, s2, 0
	addi a1, s3, 0
	jal ra, power
	addi s3, a0, 0
	addi s2, x0, 3
	addi s4, x0, 5
	addi s5, x0, 1
	addi a0, s2, 0
	addi a1, s4, 0
	addi a2, s5, 0
	jal ra, complexFunction
	addi s5, a0, 0
	addi s5, x0, -5
	addi s4, x0, 10
	addi a0, s5, 0
	addi a1, s4, 0
	jal ra, shortCircuit
	addi s4, a0, 0
	addi s4, x0, 10
	addi a0, s4, 0
	jal ra, nestedLoopsAndConditions
	addi t5, a0, 0
	sw t5, -8(s0)
	addi s5, x0, 1
	addi s2, x0, 2
	addi s6, x0, 3
	addi s7, x0, 4
	addi s8, x0, 5
	addi s9, x0, 6
	addi s10, x0, 7
	addi s11, x0, 8
	addi t0, x0, 9
	addi s4, x0, 10
	addi sp, sp, -8
	sw s4, 0(sp)
	sw t0, 4(sp)
	addi a0, s5, 0
	addi a1, s2, 0
	addi a2, s6, 0
	addi a3, s7, 0
	addi a4, s8, 0
	addi a5, s9, 0
	addi a6, s10, 0
	addi a7, s11, 0
	jal ra, nestedCalls
	addi t0, a0, 0
	addi sp, sp, 8
	add t0, t1, t2
	add s11, t0, t3
	add t1, s11, t4
	sub t3, t1, s1
	add t4, t3, s3
	lw t5, -8(s0)
	sub t1, t4, t5
	addi t3, x0, 256
	rem t4, t1, t3
	addi t5, t4, 0
	sw t5, -4(s0)
	lw t5, -4(s0)
	addi a0, t5, 0
	jal x0, main_return

main_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

