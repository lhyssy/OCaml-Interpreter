.globl main
.text
fibonacci:
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
	addi a0, s1, 0
	jal x0, fibonacci_return
else_0:
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
endif_1:
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
	bne s2, s3, else_2
	addi a0, s1, 0
	jal x0, gcd_return
else_2:
endif_3:
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

isPrime:
	addi sp, sp, -16
	sw s0, 8(sp)
	sw s1, 4(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, x0, 1
	blt t1, t0, else_4
	addi a0, x0, 0
	jal x0, isPrime_return
else_4:
endif_5:
	addi t1, x0, 3
	blt t1, t0, else_6
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
	bne t4, x0, or_true_10
	addi t1, x0, 3
	rem t4, t0, t1
	addi t2, x0, 0
	bne t4, t2, else_8
or_true_10:
	addi a0, x0, 0
	jal x0, isPrime_return
else_8:
endif_9:
	addi t4, x0, 5
while_start_11:
	mul t2, t4, t4
	blt t0, t2, while_end_13
	rem t1, t0, t4
	addi t2, x0, 0
	sub t3, t1, t2
	sub s1, t3, x0
	sltiu s1, s1, 1
	bne s1, x0, or_true_16
	addi t3, x0, 2
	add t1, t4, t3
	rem t2, t0, t1
	addi t3, x0, 0
	bne t2, t3, else_14
or_true_16:
	addi a0, x0, 0
	jal x0, isPrime_return
else_14:
endif_15:
	addi t2, x0, 6
	add t3, t4, t2
	addi t4, t3, 0
while_continue_12:
	jal x0, while_start_11
while_end_13:
	addi a0, x0, 1
	jal x0, isPrime_return
isPrime_return:
	lw s0, 8(sp)
	lw s1, 4(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

factorial:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, x0, 1
while_start_17:
	addi t2, x0, 0
	bge t2, t0, while_end_19
	mul t3, t1, t0
	addi t1, t3, 0
	addi t2, x0, 1
	sub t3, t0, t2
	addi t0, t3, 0
while_continue_18:
	jal x0, while_start_17
while_end_19:
	addi a0, t1, 0
	jal x0, factorial_return
factorial_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

combination:
	addi sp, sp, -32
	sw ra, 28(sp)
	sw s0, 24(sp)
	sw s1, 20(sp)
	sw s2, 16(sp)
	sw s3, 12(sp)
	sw s4, 8(sp)
	sw s5, 4(sp)
	addi s0, sp, 32
	addi s1, a0, 0
	addi s2, a1, 0
	bge s1, s2, else_20
	addi a0, x0, 0
	jal x0, combination_return
else_20:
endif_21:
	addi s3, x0, 0
	sub s4, s2, s3
	sub s5, s4, x0
	sltiu s5, s5, 1
	bne s5, x0, or_true_24
	bne s2, s1, else_22
or_true_24:
	addi a0, x0, 1
	jal x0, combination_return
else_22:
endif_23:
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
	lw ra, 28(sp)
	lw s0, 24(sp)
	lw s1, 20(sp)
	lw s2, 16(sp)
	lw s3, 12(sp)
	lw s4, 8(sp)
	lw s5, 4(sp)
	addi sp, sp, 32
	jalr x0, ra, 0

power:
	addi sp, sp, -16
	sw s0, 8(sp)
	sw s1, 4(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, a1, 0
	addi t2, x0, 1
while_start_25:
	addi t3, x0, 0
	bge t3, t1, while_end_27
	addi t4, x0, 2
	rem t3, t1, t4
	addi s1, x0, 1
	bne t3, s1, else_28
	mul t4, t2, t0
	addi t2, t4, 0
	jal x0, endif_29
else_28:
endif_29:
	mul t4, t0, t0
	addi t0, t4, 0
	srli t0, t1, 1
	addi t1, t0, 0
while_continue_26:
	jal x0, while_start_25
while_end_27:
	addi a0, t2, 0
	jal x0, power_return
power_return:
	lw s0, 8(sp)
	lw s1, 4(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

complexFunction:
	addi sp, sp, -32
	sw s0, 24(sp)
	sw s1, 20(sp)
	sw s2, 16(sp)
	sw s3, 12(sp)
	sw s4, 8(sp)
	addi s0, sp, 32
	addi t0, a0, 0
	addi t1, a1, 0
	addi t2, a2, 0
	addi t3, x0, 0
	slt t4, t1, t0
	slt s1, t2, t1
	beq t4, x0, and_false_32
	beq s1, x0, and_false_32
	addi t4, x0, 1
	jal x0, and_end_33
and_false_32:
	addi t4, x0, 0
and_end_33:
	bne t4, x0, else_30
	mul s1, t0, t1
	addi t4, x0, -1
	add s2, t2, t4
	addi s3, x0, 0
	sub t4, s3, s2
	sub s4, s1, t4
	addi t3, s4, 0
	jal x0, endif_31
else_30:
	slt t4, t0, t2
	sub s4, t4, x0
	sltiu s4, s4, 1
	bne s4, x0, or_true_36
	bge t2, t1, else_34
or_true_36:
	sub t4, t2, t1
	addi s4, x0, -2
	sub s1, t4, s4
	mul s2, t0, s1
	addi t3, s2, 0
	jal x0, endif_35
else_34:
	slt t4, t1, t0
	sub s2, t4, x0
	sltiu s2, s2, 1
	slt s1, t0, t2
	sub t4, s1, x0
	sltiu t4, t4, 1
	beq s2, x0, and_false_40
	beq t4, x0, and_false_40
	addi s2, x0, 1
	jal x0, and_end_41
and_false_40:
	addi s2, x0, 0
and_end_41:
	bne s2, x0, or_true_39
	blt t2, t1, else_37
or_true_39:
	mul t4, t1, t0
	addi s2, x0, -3
	add s1, t2, s2
	addi s4, x0, 0
	sub s2, s4, s1
	sub s3, t4, s2
	addi t3, s3, 0
	jal x0, endif_38
else_37:
	slt t4, t2, t1
	bne t4, x0, or_true_44
	bge t0, t2, else_42
	blt t1, t0, else_42
or_true_44:
	sub t4, t2, t0
	addi s3, x0, -4
	sub s2, t4, s3
	mul s1, t1, s2
	addi t3, s1, 0
	jal x0, endif_43
else_42:
	slt t4, t0, t2
	sub s1, t1, t0
	sub s2, s1, x0
	sltu s2, x0, s2
	bne t4, x0, or_true_47
	bne s2, x0, or_true_47
	addi t4, x0, 0
	jal x0, or_end_48
or_true_47:
	addi t4, x0, 1
or_end_48:
	bne t4, x0, else_45
	bne t0, t1, else_45
	mul t4, t2, t0
	addi s2, x0, -5
	add s1, t1, s2
	sub s3, t4, s1
	addi t3, s3, 0
	jal x0, endif_46
else_45:
	addi t4, x0, 0
	sub s3, t4, t0
	sub s1, t1, s3
	addi t0, x0, -6
	sub t1, s1, t0
	mul t4, t2, t1
	addi t3, t4, 0
endif_46:
endif_43:
endif_38:
endif_35:
endif_31:
	addi t4, x0, 0
while_start_49:
	addi t2, x0, 10
	bge t4, t2, while_end_51
	addi t1, x0, 1
	add t2, t4, t1
	addi t4, t2, 0
	addi t1, x0, 3
	rem t2, t4, t1
	addi t0, x0, 0
	bne t2, t0, else_52
	add t1, t3, t4
	addi t3, t1, 0
	jal x0, endif_53
else_52:
	addi t1, x0, 3
	rem t2, t4, t1
	addi t0, x0, 1
	bne t2, t0, else_54
	sub t1, t3, t4
	addi t3, t1, 0
	jal x0, endif_55
else_54:
	slli t1, t3, 1
	addi t3, t1, 0
	addi t4, x0, 50
	bge t3, t4, else_56
	jal x0, while_continue_50
else_56:
endif_57:
	addi t4, x0, 1
	add t1, t3, t4
	addi t3, t1, 0
	addi t4, x0, 100
	bge t4, t3, else_58
	jal x0, while_end_51
else_58:
endif_59:
endif_55:
endif_53:
while_continue_50:
	jal x0, while_start_49
while_end_51:
	addi a0, t3, 0
	jal x0, complexFunction_return
complexFunction_return:
	lw s0, 24(sp)
	lw s1, 20(sp)
	lw s2, 16(sp)
	lw s3, 12(sp)
	lw s4, 8(sp)
	addi sp, sp, 32
	jalr x0, ra, 0

shortCircuit:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, a1, 0
	addi t2, x0, 0
	bge t2, t0, else_60
	div t3, t1, t0
	addi t2, x0, 2
	bge t2, t3, else_60
	jal x0, endif_61
else_60:
endif_61:
	addi t3, x0, 0
	slt t2, t0, t3
	bne t2, x0, or_true_64
	addi t0, x0, 0
	bge t1, t0, else_62
or_true_64:
	jal x0, endif_63
else_62:
endif_63:
	addi a0, x0, 0
	jal x0, shortCircuit_return
shortCircuit_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

nestedLoopsAndConditions:
	addi sp, sp, -16
	sw s0, 8(sp)
	sw s1, 4(sp)
	sw s2, 0(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, x0, 0
	addi t2, x0, 0
while_start_65:
	bge t2, t0, while_end_67
	addi t3, x0, 0
while_start_68:
	bge t3, t2, while_end_70
	add t0, t2, t3
	addi t4, x0, 2
	rem s1, t0, t4
	addi s2, x0, 0
	bne s1, s2, else_71
	mul t0, t2, t3
	sub t4, t1, t0
	addi t1, t4, 0
	jal x0, endif_72
else_71:
	mul t4, t2, t3
	add t0, t1, t4
	addi t1, t0, 0
	addi t4, x0, 0
	bge t1, t4, else_73
	addi t0, x0, 0
	addi t1, t0, 0
	jal x0, while_continue_69
else_73:
endif_74:
endif_72:
	addi t0, x0, 1053
	bge t0, t1, else_75
	jal x0, while_end_70
else_75:
endif_76:
	addi t0, x0, 1
	add t4, t3, t0
	addi t3, t4, 0
while_continue_69:
	jal x0, while_start_68
while_end_70:
	addi t4, x0, 913
	bge t4, t1, else_77
	jal x0, while_end_67
else_77:
endif_78:
	addi t4, x0, 1
	add t3, t2, t4
	addi t2, t3, 0
while_continue_66:
	jal x0, while_start_65
while_end_67:
	addi a0, t1, 0
	jal x0, nestedLoopsAndConditions_return
nestedLoopsAndConditions_return:
	lw s0, 8(sp)
	lw s1, 4(sp)
	lw s2, 0(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

func1:
	addi sp, sp, -32
	sw ra, 28(sp)
	sw s0, 24(sp)
	sw s1, 20(sp)
	sw s2, 16(sp)
	sw s3, 12(sp)
	sw s4, 8(sp)
	sw s5, 4(sp)
	addi s0, sp, 32
	addi s1, a0, 0
	addi s2, a1, 0
	addi s3, a2, 0
	addi s4, x0, 0
	bne s3, s4, else_79
	mul s5, s1, s2
	addi a0, s5, 0
	jal x0, func1_return
else_79:
	sub s5, s2, s3
	addi s4, x0, 0
	addi a0, s1, 0
	addi a1, s5, 0
	addi a2, s4, 0
	jal ra, func1
	addi t0, a0, 0
	addi a0, t0, 0
	jal x0, func1_return
endif_80:
func1_return:
	lw ra, 28(sp)
	lw s0, 24(sp)
	lw s1, 20(sp)
	lw s2, 16(sp)
	lw s3, 12(sp)
	lw s4, 8(sp)
	lw s5, 4(sp)
	addi sp, sp, 32
	jalr x0, ra, 0

func2:
	addi sp, sp, -32
	sw ra, 28(sp)
	sw s0, 24(sp)
	sw s1, 20(sp)
	sw s2, 16(sp)
	sw s3, 12(sp)
	sw s4, 8(sp)
	addi s0, sp, 32
	addi s1, a0, 0
	addi s2, a1, 0
	beq s2, x0, else_81
	rem s3, s1, s2
	addi s4, x0, 0
	addi a0, s3, 0
	addi a1, s4, 0
	jal ra, func2
	addi t0, a0, 0
	addi a0, t0, 0
	jal x0, func2_return
else_81:
	addi a0, s1, 0
	jal x0, func2_return
endif_82:
func2_return:
	lw ra, 28(sp)
	lw s0, 24(sp)
	lw s1, 20(sp)
	lw s2, 16(sp)
	lw s3, 12(sp)
	lw s4, 8(sp)
	addi sp, sp, 32
	jalr x0, ra, 0

func3:
	addi sp, sp, -32
	sw ra, 28(sp)
	sw s0, 24(sp)
	sw s1, 20(sp)
	sw s2, 16(sp)
	sw s3, 12(sp)
	sw s4, 8(sp)
	addi s0, sp, 32
	addi s1, a0, 0
	addi s2, a1, 0
	addi s3, x0, 0
	bne s2, s3, else_83
	addi s4, x0, 1
	add s3, s1, s4
	addi a0, s3, 0
	jal x0, func3_return
else_83:
	add s3, s1, s2
	addi s4, x0, 0
	addi a0, s3, 0
	addi a1, s4, 0
	jal ra, func3
	addi t0, a0, 0
	addi a0, t0, 0
	jal x0, func3_return
endif_84:
func3_return:
	lw ra, 28(sp)
	lw s0, 24(sp)
	lw s1, 20(sp)
	lw s2, 16(sp)
	lw s3, 12(sp)
	lw s4, 8(sp)
	addi sp, sp, 32
	jalr x0, ra, 0

func4:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, a1, 0
	addi t2, a2, 0
	beq t0, x0, else_85
	addi a0, t1, 0
	jal x0, func4_return
else_85:
	addi a0, t2, 0
	jal x0, func4_return
endif_86:
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
	beq t0, x0, else_87
	beq t1, x0, else_87
	addi a0, x0, 1
	jal x0, func6_return
else_87:
	addi a0, x0, 0
	jal x0, func6_return
endif_88:
func6_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

func7:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	bne t0, x0, else_89
	addi a0, x0, 1
	jal x0, func7_return
else_89:
	addi a0, x0, 0
	jal x0, func7_return
endif_90:
func7_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

nestedCalls:
	addi sp, sp, -64
	sw ra, 60(sp)
	sw s0, 56(sp)
	sw s1, 52(sp)
	sw s10, 48(sp)
	sw s11, 44(sp)
	sw s2, 40(sp)
	sw s3, 36(sp)
	sw s4, 32(sp)
	sw s5, 28(sp)
	sw s6, 24(sp)
	sw s7, 20(sp)
	sw s8, 16(sp)
	sw s9, 12(sp)
	addi s0, sp, 64
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
	lw ra, 60(sp)
	lw s0, 56(sp)
	lw s1, 52(sp)
	lw s10, 48(sp)
	lw s11, 44(sp)
	lw s2, 40(sp)
	lw s3, 36(sp)
	lw s4, 32(sp)
	lw s5, 28(sp)
	lw s6, 24(sp)
	lw s7, 20(sp)
	lw s8, 16(sp)
	lw s9, 12(sp)
	addi sp, sp, 64
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
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, fibonacci
	lw t5, 4(sp)
	addi sp, sp, 4
	addi t1, a0, 0
	addi s1, x0, 22
	addi s2, x0, 15
	addi a0, s1, 0
	addi a1, s2, 0
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, gcd
	lw t5, 4(sp)
	addi sp, sp, 4
	addi t2, a0, 0
	addi s2, x0, 17
	addi a0, s2, 0
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, isPrime
	lw t5, 4(sp)
	addi sp, sp, 4
	addi t3, a0, 0
	addi s2, x0, 8
	addi a0, s2, 0
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, factorial
	lw t5, 4(sp)
	addi sp, sp, 4
	addi t4, a0, 0
	addi s2, x0, 7
	addi s1, x0, 3
	addi a0, s2, 0
	addi a1, s1, 0
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, combination
	lw t5, 4(sp)
	addi sp, sp, 4
	addi s1, a0, 0
	addi s2, x0, 3
	addi s3, x0, 11
	addi a0, s2, 0
	addi a1, s3, 0
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, power
	lw t5, 4(sp)
	addi sp, sp, 4
	addi s3, a0, 0
	addi s2, x0, 3
	addi s4, x0, 5
	addi s5, x0, 1
	addi a0, s2, 0
	addi a1, s4, 0
	addi a2, s5, 0
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, complexFunction
	lw t5, 4(sp)
	addi sp, sp, 4
	addi s5, a0, 0
	addi s5, x0, -5
	addi s4, x0, 10
	addi a0, s5, 0
	addi a1, s4, 0
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, shortCircuit
	lw t5, 4(sp)
	addi sp, sp, 4
	addi s4, a0, 0
	addi s4, x0, 10
	addi a0, s4, 0
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, nestedLoopsAndConditions
	lw t5, 4(sp)
	addi sp, sp, 4
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
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, nestedCalls
	lw t5, 4(sp)
	addi sp, sp, 4
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

