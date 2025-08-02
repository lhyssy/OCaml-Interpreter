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
	bne s2, s3, else_2
	addi a0, s1, 0
	jal x0, gcd_return
else_2:
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
	sw s0, 12(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, x0, 1
	blt t1, t0, else_4
	addi a0, x0, 0
	jal x0, isPrime_return
else_4:
	addi t1, x0, 3
	blt t1, t0, else_6
	addi a0, x0, 1
	jal x0, isPrime_return
else_6:
	addi t1, x0, 2
	rem t2, t0, t1
	addi t1, x0, 0
	sub t3, t2, t1
	sub t2, t3, x0
	sltiu t2, t2, 1
	bne t2, x0, or_true_10
	addi t2, x0, 3
	rem t3, t0, t2
	addi t2, x0, 0
	bne t3, t2, else_8
or_true_10:
	addi a0, x0, 0
	jal x0, isPrime_return
else_8:
	addi t3, x0, 5
while_start_11:
	mul t2, t3, t3
	blt t0, t2, while_end_13
	rem t2, t0, t3
	addi t1, x0, 0
	sub t4, t2, t1
	sub t2, t4, x0
	sltiu t2, t2, 1
	bne t2, x0, or_true_16
	addi t2, x0, 2
	add t4, t3, t2
	rem t2, t0, t4
	addi t4, x0, 0
	bne t2, t4, else_14
or_true_16:
	addi a0, x0, 0
	jal x0, isPrime_return
else_14:
	addi t2, x0, 6
	add t4, t3, t2
	addi t3, t4, 0
	jal x0, while_start_11
while_end_13:
	addi a0, x0, 1
	jal x0, isPrime_return
isPrime_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

factorial:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, x0, 1
while_start_17:
	addi t2, x0, 0
	bge t2, t0, while_end_19
	mul t2, t1, t0
	addi t1, t2, 0
	addi t2, x0, 1
	sub t3, t0, t2
	addi t0, t3, 0
	jal x0, while_start_17
while_end_19:
	addi a0, t1, 0
	jal x0, factorial_return
factorial_return:
	lw s0, 12(sp)
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
	addi s0, sp, 32
	addi s1, a0, 0
	addi s2, a1, 0
	bge s1, s2, else_20
	addi a0, x0, 0
	jal x0, combination_return
else_20:
	addi s3, x0, 0
	sub s4, s2, s3
	sub s3, s4, x0
	sltiu s3, s3, 1
	bne s3, x0, or_true_24
	bne s2, s1, else_22
or_true_24:
	addi a0, x0, 1
	jal x0, combination_return
else_22:
	addi a0, s1, 0
	jal ra, factorial
	addi t0, a0, 0
	addi a0, s2, 0
	addi sp, sp, -4
	sw t0, 4(sp)
	jal ra, factorial
	lw t0, 4(sp)
	addi sp, sp, 4
	addi t1, a0, 0
	sub s3, s1, s2
	addi a0, s3, 0
	addi sp, sp, -8
	sw t0, 4(sp)
	sw t1, 8(sp)
	jal ra, factorial
	lw t0, 4(sp)
	lw t1, 8(sp)
	addi sp, sp, 8
	addi t2, a0, 0
	mul t3, t1, t2
	div t1, t0, t3
	addi a0, t1, 0
	jal x0, combination_return
combination_return:
	lw ra, 28(sp)
	lw s0, 24(sp)
	lw s1, 20(sp)
	lw s2, 16(sp)
	lw s3, 12(sp)
	lw s4, 8(sp)
	addi sp, sp, 32
	jalr x0, ra, 0

power:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, a1, 0
	addi t2, x0, 1
while_start_25:
	addi t3, x0, 0
	bge t3, t1, while_end_27
	addi t3, x0, 2
	rem t4, t1, t3
	addi t3, x0, 1
	bne t4, t3, else_28
	mul t4, t2, t0
	addi t2, t4, 0
	jal x0, endif_29
else_28:
endif_29:
	mul t4, t0, t0
	addi t0, t4, 0
	srli t4, t1, 1
	addi t1, t4, 0
	jal x0, while_start_25
while_end_27:
	addi a0, t2, 0
	jal x0, power_return
power_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

complexFunction:
	addi sp, sp, -16
	sw s0, 12(sp)
	sw s1, 8(sp)
	sw s2, 4(sp)
	sw s3, 0(sp)
	addi s0, sp, 16
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
	mul t4, t0, t1
	addi s1, x0, -1
	add s2, t2, s1
	addi s1, x0, 0
	sub s3, s1, s2
	sub s2, t4, s3
	addi t3, s2, 0
	jal x0, endif_31
else_30:
	slt t4, t0, t2
	sub s2, t4, x0
	sltiu s2, s2, 1
	bne s2, x0, or_true_36
	bge t2, t1, else_34
or_true_36:
	sub t4, t2, t1
	addi s2, x0, -2
	sub s3, t4, s2
	mul t4, t0, s3
	addi t3, t4, 0
	jal x0, endif_35
else_34:
	slt t4, t1, t0
	sub s3, t4, x0
	sltiu s3, s3, 1
	slt t4, t0, t2
	sub s2, t4, x0
	sltiu s2, s2, 1
	beq s3, x0, and_false_40
	beq s2, x0, and_false_40
	addi t4, x0, 1
	jal x0, and_end_41
and_false_40:
	addi t4, x0, 0
and_end_41:
	bne t4, x0, or_true_39
	blt t2, t1, else_37
or_true_39:
	mul t4, t1, t0
	addi s2, x0, -3
	add s3, t2, s2
	addi s2, x0, 0
	sub s1, s2, s3
	sub s3, t4, s1
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
	sub s1, t4, s3
	mul t4, t1, s1
	addi t3, t4, 0
	jal x0, endif_43
else_42:
	slt t4, t0, t2
	sub s1, t1, t0
	sub s3, s1, x0
	sltu s3, x0, s3
	bne t4, x0, or_true_47
	bne s3, x0, or_true_47
	addi t4, x0, 0
	jal x0, or_end_48
or_true_47:
	addi t4, x0, 1
or_end_48:
	bne t4, x0, else_45
	bne t0, t1, else_45
	mul t4, t2, t0
	addi s3, x0, -5
	add s1, t1, s3
	sub s3, t4, s1
	addi t3, s3, 0
	jal x0, endif_46
else_45:
	addi t4, x0, 0
	sub s3, t4, t0
	sub t0, t1, s3
	addi t1, x0, -6
	sub t4, t0, t1
	mul t0, t2, t4
	addi t3, t0, 0
endif_46:
endif_43:
endif_38:
endif_35:
endif_31:
	addi t0, x0, 0
while_start_49:
	addi t2, x0, 10
	bge t0, t2, while_end_51
	addi t2, x0, 1
	add t4, t0, t2
	addi t0, t4, 0
	addi t4, x0, 0
	jal x0, while_start_49
while_end_51:
	addi a0, t3, 0
	jal x0, complexFunction_return
complexFunction_return:
	lw s0, 12(sp)
	lw s1, 8(sp)
	lw s2, 4(sp)
	lw s3, 0(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

shortCircuit:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, a1, 0
	addi t2, x0, 0
	addi t3, x0, 0
	bge t3, t0, else_52
	div t3, t1, t0
	addi t4, x0, 2
	bge t4, t3, else_52
	addi t3, x0, 22
	add t4, t2, t3
	addi t2, t4, 0
	jal x0, endif_53
else_52:
endif_53:
	addi t4, x0, 0
	slt t3, t0, t4
	bne t3, x0, or_true_56
	addi t3, x0, 0
	bge t1, t3, else_54
or_true_56:
	addi t1, x0, 32
	add t3, t2, t1
	addi t2, t3, 0
	jal x0, endif_55
else_54:
endif_55:
	addi a0, t2, 0
	jal x0, shortCircuit_return
shortCircuit_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

nestedLoopsAndConditions:
	addi sp, sp, -16
	sw s0, 12(sp)
	sw s1, 8(sp)
	sw s2, 4(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, x0, 0
	addi t2, x0, 0
while_start_57:
	bge t2, t0, while_end_59
	addi t3, x0, 0
while_start_60:
	bge t3, t2, while_end_62
	add t4, t2, t3
	addi s1, x0, 2
	rem s2, t4, s1
	addi t4, x0, 0
	bne s2, t4, else_63
	mul t4, t2, t3
	sub s2, t1, t4
	addi t1, s2, 0
	jal x0, endif_64
else_63:
	mul t4, t2, t3
	add s2, t1, t4
	addi t1, s2, 0
	addi t4, x0, 0
	bge t1, t4, else_65
	addi t4, x0, 0
	addi t1, t4, 0
	jal x0, while_continue_61
else_65:
endif_64:
	addi t4, x0, 952
	bge t4, t1, else_67
	jal x0, while_end_62
else_67:
	addi t4, x0, 1
	add s2, t3, t4
	addi t3, s2, 0
while_continue_61:
	jal x0, while_start_60
while_end_62:
	addi t4, x0, 1007
	bge t4, t1, else_69
	jal x0, while_end_59
else_69:
	addi t3, x0, 1
	add t4, t2, t3
	addi t2, t4, 0
	jal x0, while_start_57
while_end_59:
	addi a0, t1, 0
	jal x0, nestedLoopsAndConditions_return
nestedLoopsAndConditions_return:
	lw s0, 12(sp)
	lw s1, 8(sp)
	lw s2, 4(sp)
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
	addi s0, sp, 32
	addi s1, a0, 0
	addi s2, a1, 0
	addi s3, a2, 0
	addi s4, x0, 0
	bne s3, s4, else_71
	mul s4, s1, s2
	addi a0, s4, 0
	jal x0, func1_return
else_71:
	sub s4, s2, s3
	addi s2, x0, 0
	addi a0, s1, 0
	addi a1, s4, 0
	addi a2, s2, 0
	jal ra, func1
	addi t0, a0, 0
	addi a0, t0, 0
	jal x0, func1_return
func1_return:
	lw ra, 28(sp)
	lw s0, 24(sp)
	lw s1, 20(sp)
	lw s2, 16(sp)
	lw s3, 12(sp)
	lw s4, 8(sp)
	addi sp, sp, 32
	jalr x0, ra, 0

func2:
	addi sp, sp, -32
	sw ra, 28(sp)
	sw s0, 24(sp)
	sw s1, 20(sp)
	sw s2, 16(sp)
	sw s3, 12(sp)
	addi s0, sp, 32
	addi s1, a0, 0
	addi s2, a1, 0
	beq s2, x0, else_73
	rem s3, s1, s2
	addi s2, x0, 0
	addi a0, s3, 0
	addi a1, s2, 0
	jal ra, func2
	addi t0, a0, 0
	addi a0, t0, 0
	jal x0, func2_return
else_73:
	addi a0, s1, 0
	jal x0, func2_return
func2_return:
	lw ra, 28(sp)
	lw s0, 24(sp)
	lw s1, 20(sp)
	lw s2, 16(sp)
	lw s3, 12(sp)
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
	bne s2, s3, else_75
	addi s3, x0, 1
	add s4, s1, s3
	addi a0, s4, 0
	jal x0, func3_return
else_75:
	add s4, s1, s2
	addi s1, x0, 0
	addi a0, s4, 0
	addi a1, s1, 0
	jal ra, func3
	addi t0, a0, 0
	addi a0, t0, 0
	jal x0, func3_return
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
	sw s0, 12(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, a1, 0
	addi t2, a2, 0
	beq t0, x0, else_77
	addi a0, t1, 0
	jal x0, func4_return
else_77:
	addi a0, t2, 0
	jal x0, func4_return
func4_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

func5:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, x0, 0
	sub t2, t1, t0
	addi a0, t2, 0
	jal x0, func5_return
func5_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

func6:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, a1, 0
	beq t0, x0, else_79
	beq t1, x0, else_79
	addi a0, x0, 1
	jal x0, func6_return
else_79:
	addi a0, x0, 0
	jal x0, func6_return
func6_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

func7:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	bne t0, x0, else_81
	addi a0, x0, 1
	jal x0, func7_return
else_81:
	addi a0, x0, 0
	jal x0, func7_return
func7_return:
	lw s0, 12(sp)
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
	addi s11, x0, 9
	addi a0, s11, 0
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, func7
	lw t5, 4(sp)
	addi sp, sp, 4
	addi s11, a0, 0
	addi s4, x0, 1
	addi a0, s4, 0
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, func5
	lw t5, 4(sp)
	addi sp, sp, 4
	addi s4, a0, 0
	addi a0, s11, 0
	addi a1, s4, 0
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, func6
	lw t5, 4(sp)
	addi sp, sp, 4
	addi s4, a0, 0
	addi s11, x0, 7
	addi a0, s4, 0
	addi a1, s11, 0
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, func2
	lw t5, 4(sp)
	addi sp, sp, 4
	addi s11, a0, 0
	addi s4, x0, 14
	addi a0, s11, 0
	addi a1, s4, 0
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, func3
	lw t5, 4(sp)
	addi sp, sp, 4
	addi s4, a0, 0
	addi a0, s4, 0
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, func5
	lw t5, 4(sp)
	addi sp, sp, 4
	addi s4, a0, 0
	addi a0, s2, 0
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, func5
	lw t5, 4(sp)
	addi sp, sp, 4
	addi s11, a0, 0
	lw t5, -12(s0)
	addi a0, t5, 0
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, func7
	lw t5, 4(sp)
	addi sp, sp, 4
	addi s10, a0, 0
	addi a0, s3, 0
	addi a1, s10, 0
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, func6
	lw t5, 4(sp)
	addi sp, sp, 4
	addi s10, a0, 0
	addi a0, s6, 0
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, func7
	lw t5, 4(sp)
	addi sp, sp, 4
	addi s8, a0, 0
	addi a0, s5, 0
	addi a1, s8, 0
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, func2
	lw t5, 4(sp)
	addi sp, sp, 4
	addi s8, a0, 0
	addi a0, s11, 0
	addi a1, s10, 0
	addi a2, s8, 0
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, func4
	lw t5, 4(sp)
	addi sp, sp, 4
	addi s8, a0, 0
	addi a0, s8, 0
	addi a1, s7, 0
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, func3
	lw t5, 4(sp)
	addi sp, sp, 4
	addi s8, a0, 0
	addi a0, s8, 0
	lw t5, -4(s0)
	addi a1, t5, 0
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, func2
	lw t5, 4(sp)
	addi sp, sp, 4
	addi s8, a0, 0
	lw t5, -8(s0)
	addi a0, t5, 0
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, func7
	lw t5, 4(sp)
	addi sp, sp, 4
	addi s10, a0, 0
	addi a0, s9, 0
	addi a1, s10, 0
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, func3
	lw t5, 4(sp)
	addi sp, sp, 4
	addi s10, a0, 0
	addi s11, x0, 9
	addi a0, s8, 0
	addi a1, s10, 0
	addi a2, s11, 0
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, func1
	lw t5, 4(sp)
	addi sp, sp, 4
	addi s11, a0, 0
	addi a0, s4, 0
	addi a1, s1, 0
	addi a2, s11, 0
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, func4
	lw t5, 4(sp)
	addi sp, sp, 4
	addi s11, a0, 0
	addi s4, x0, 1
	addi s10, x0, 7
	addi a0, s10, 0
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, func7
	lw t5, 4(sp)
	addi sp, sp, 4
	addi s10, a0, 0
	addi s8, x0, 14
	addi a0, s10, 0
	addi a1, s8, 0
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, func3
	lw t5, 4(sp)
	addi sp, sp, 4
	addi s8, a0, 0
	addi a0, s4, 0
	addi a1, s8, 0
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, func2
	lw t5, 4(sp)
	addi sp, sp, 4
	addi s8, a0, 0
	addi a0, s11, 0
	addi a1, s8, 0
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, func3
	lw t5, 4(sp)
	addi sp, sp, 4
	addi s8, a0, 0
	addi a0, s8, 0
	addi a1, s1, 0
	addi a2, s2, 0
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, func1
	lw t5, 4(sp)
	addi sp, sp, 4
	addi s2, a0, 0
	addi a0, s2, 0
	addi a1, s3, 0
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, func2
	lw t5, 4(sp)
	addi sp, sp, 4
	addi s3, a0, 0
	addi a0, s6, 0
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, func5
	lw t5, 4(sp)
	addi sp, sp, 4
	addi s6, a0, 0
	addi a0, s5, 0
	addi a1, s6, 0
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, func3
	lw t5, 4(sp)
	addi sp, sp, 4
	addi s6, a0, 0
	addi a0, s7, 0
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, func5
	lw t5, 4(sp)
	addi sp, sp, 4
	addi s7, a0, 0
	addi a0, s6, 0
	addi a1, s7, 0
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, func2
	lw t5, 4(sp)
	addi sp, sp, 4
	addi s7, a0, 0
	addi a0, s9, 0
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, func7
	lw t5, 4(sp)
	addi sp, sp, 4
	addi s9, a0, 0
	addi a0, s7, 0
	lw t5, -4(s0)
	addi a1, t5, 0
	addi a2, s9, 0
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, func1
	lw t5, 4(sp)
	addi sp, sp, 4
	addi s9, a0, 0
	lw t5, -8(s0)
	addi a0, t5, 0
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, func5
	lw t5, 4(sp)
	addi sp, sp, 4
	addi s7, a0, 0
	addi a0, s9, 0
	addi a1, s7, 0
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, func2
	lw t5, 4(sp)
	addi sp, sp, 4
	addi s7, a0, 0
	addi s9, x0, 9
	addi a0, s7, 0
	addi a1, s9, 0
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, func3
	lw t5, 4(sp)
	addi sp, sp, 4
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
	addi sp, sp, -32
	sw ra, 28(sp)
	sw s0, 24(sp)
	addi s0, sp, 32
	addi t5, x0, 0
	sw t5, -20(s0)
	addi s1, x0, 12
	addi a0, s1, 0
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, fibonacci
	lw t5, 4(sp)
	addi sp, sp, 4
	addi s1, a0, 0
	addi s2, x0, 144
	beq s1, s2, else_83
	addi a0, x0, 0
	jal x0, main_return
else_83:
	addi s2, x0, 39
	addi s3, x0, 31
	addi a0, s2, 0
	addi a1, s3, 0
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, gcd
	lw t5, 4(sp)
	addi sp, sp, 4
	addi s3, a0, 0
	addi s2, x0, 1
	beq s3, s2, else_85
	addi a0, x0, 0
	jal x0, main_return
else_85:
	addi s2, x0, 18
	addi a0, s2, 0
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, isPrime
	lw t5, 4(sp)
	addi sp, sp, 4
	addi s2, a0, 0
	addi s4, x0, 0
	beq s2, s4, else_87
	addi a0, x0, 0
	jal x0, main_return
else_87:
	addi s4, x0, 6
	addi a0, s4, 0
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, factorial
	lw t5, 4(sp)
	addi sp, sp, 4
	addi t5, a0, 0
	sw t5, -8(s0)
	addi s5, x0, 720
	lw t5, -8(s0)
	beq t5, s5, else_89
	addi a0, x0, 0
	jal x0, main_return
else_89:
	addi s5, x0, 9
	addi s6, x0, 9
	addi a0, s5, 0
	addi a1, s6, 0
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, combination
	lw t5, 4(sp)
	addi sp, sp, 4
	addi t5, a0, 0
	sw t5, -12(s0)
	addi s5, x0, 1
	lw t5, -12(s0)
	beq t5, s5, else_91
	addi a0, x0, 0
	jal x0, main_return
else_91:
	addi s5, x0, 3
	addi s7, x0, 10
	addi a0, s5, 0
	addi a1, s7, 0
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, power
	lw t5, 4(sp)
	addi sp, sp, 4
	addi t5, a0, 0
	sw t5, -16(s0)
	li s5, 59049
	lw t5, -16(s0)
	beq t5, s5, else_93
	addi a0, x0, 0
	jal x0, main_return
else_93:
	addi s5, x0, 8
	addi s8, x0, 3
	addi s9, x0, 8
	addi a0, s5, 0
	addi a1, s8, 0
	addi a2, s9, 0
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, complexFunction
	lw t5, 4(sp)
	addi sp, sp, 4
	addi t1, a0, 0
	addi s9, x0, -2
	addi s8, x0, 10
	addi a0, s9, 0
	addi a1, s8, 0
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, shortCircuit
	lw t5, 4(sp)
	addi sp, sp, 4
	addi t1, a0, 0
	addi s8, x0, 10
	addi a0, s8, 0
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, nestedLoopsAndConditions
	lw t5, 4(sp)
	addi sp, sp, 4
	addi t5, a0, 0
	sw t5, -4(s0)
	addi s8, x0, 539
	addi s9, x0, 908
	addi s5, x0, 686
	addi s10, x0, 45
	addi s11, x0, 801
	addi t0, x0, 944
	addi t1, x0, 196
	addi s7, x0, 985
	addi s6, x0, 835
	addi s4, x0, 649
	addi sp, sp, -8
	sw s4, 0(sp)
	sw s6, 4(sp)
	addi a0, s8, 0
	addi a1, s9, 0
	addi a2, s5, 0
	addi a3, s10, 0
	addi a4, s11, 0
	addi a5, t0, 0
	addi a6, t1, 0
	addi a7, s7, 0
	addi sp, sp, -4
	sw t5, 4(sp)
	jal ra, nestedCalls
	lw t5, 4(sp)
	addi sp, sp, 4
	addi t1, a0, 0
	addi sp, sp, 8
	addi t1, x0, 1
	li t0, 37633
	rem t2, s1, t0
	li t0, 37633
	rem t3, s3, t0
	add t0, t2, t3
	li t2, 37633
	rem t3, s2, t2
	sub t2, t0, t3
	li t0, 37633
	lw t5, -8(s0)
	rem t3, t5, t0
	add t0, t2, t3
	lw t5, -12(s0)
	slli t2, t5, 1
	li t3, 37633
	rem t4, t2, t3
	sub t2, t0, t4
	lw t5, -16(s0)
	slli t0, t5, 1
	li t4, 37633
	rem t3, t0, t4
	add t0, t2, t3
	lw t5, -4(s0)
	slli t2, t5, 1
	sub t3, t0, t2
	addi t0, x0, 254
	rem t2, t3, t0
	add t3, t1, t2
	addi t5, t3, 0
	sw t5, -20(s0)
	lw t5, -20(s0)
	addi a0, t5, 0
	jal x0, main_return
main_return:
	lw ra, 28(sp)
	lw s0, 24(sp)
	addi sp, sp, 32
	jalr x0, ra, 0

