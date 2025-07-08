.globl main
.text
fibonacci:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi s0, a0, 0
	addi a0, x0, 1
	slt t2, a0, s0
	sub t3, t2, x0
	sltiu t3, t3, 1
	beq t3, x0, else_0
	addi a0, s0, 0
	jal x0, fibonacci_return
else_0:
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
endif_1:

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

isPrime:
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
	jal x0, isPrime_return
else_0:
endif_1:
	addi t1, x0, 3
	slt t2, t1, s0
	sub t1, t2, x0
	sltiu t1, t1, 1
	beq t1, x0, else_2
	addi a0, x0, 1
	jal x0, isPrime_return
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
	jal x0, isPrime_return
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
	jal x0, isPrime_return
else_12:
endif_13:
	jal x0, while_start_8
while_end_9:
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
	addi s0, a0, 0
while_start_0:
	addi a0, x0, 0
	slt t2, a0, s0
	beq t2, x0, while_end_1
	addi t2, x0, 1
	sub t1, s0, t2
	addi s0, t1, 0
	jal x0, while_start_0
while_end_1:
	addi a0, x0, 1
	jal x0, factorial_return

factorial_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

combination:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi s0, a0, 0
	addi a0, t2, 0
	slt t2, s0, a0
	beq t2, x0, else_0
	addi a0, x0, 0
	jal x0, combination_return
else_0:
endif_1:
	addi t2, x0, 0
	sub t3, a0, t2
	sub t2, t3, x0
	sltiu t2, t2, 1
	sub t3, a0, s0
	sub t4, t3, x0
	sltiu t4, t4, 1
	bne t2, x0, or_true_2
	bne t4, x0, or_true_2
	addi t4, x0, 0
	jal x0, or_end_3
or_true_2:
	addi t4, x0, 1
or_end_3:
	beq t4, x0, else_4
	addi a0, x0, 1
	jal x0, combination_return
else_4:
endif_5:
	addi a0, s0, 0
	jal ra, factorial
	addi t4, a0, 0
	addi a0, a0, 0
	jal ra, factorial
	addi t2, a0, 0
	sub t3, s0, a0
	addi a0, t3, 0
	jal ra, factorial
	addi t3, a0, 0
	mul t1, t2, t3
	div t2, t4, t1
	addi a0, t2, 0
	jal x0, combination_return

combination_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

power:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi s0, a0, 0
	addi a0, t2, 0
while_start_0:
	addi t2, x0, 0
	slt t3, t2, a0
	beq t3, x0, while_end_1
	addi t3, x0, 2
	rem t2, a0, t3
	addi t3, x0, 1
	sub t4, t2, t3
	sub t2, t4, x0
	sltiu t2, t2, 1
	beq t2, x0, else_2
	jal x0, endif_3
else_2:
endif_3:
	mul t2, s0, s0
	addi s0, t2, 0
	srli t2, a0, 1
	addi a0, t2, 0
	jal x0, while_start_0
while_end_1:
	addi a0, x0, 1
	jal x0, power_return

power_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

complexFunction:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi s0, a0, 0
	addi a0, t2, 0
	addi t2, t3, 0
	slt t3, a0, s0
	slt t4, t2, a0
	beq t3, x0, and_false_0
	beq t4, x0, and_false_0
	addi t4, x0, 1
	jal x0, and_end_1
and_false_0:
	addi t4, x0, 0
and_end_1:
	sub t3, t4, x0
	sltiu t3, t3, 1
	beq t3, x0, else_2
	jal x0, endif_3
else_2:
	slt t3, s0, t2
	sub t4, t3, x0
	sltiu t4, t4, 1
	slt t3, t2, a0
	bne t4, x0, or_true_4
	bne t3, x0, or_true_4
	addi t3, x0, 0
	jal x0, or_end_5
or_true_4:
	addi t3, x0, 1
or_end_5:
	beq t3, x0, else_6
	jal x0, endif_7
else_6:
	slt t3, a0, s0
	sub t4, t3, x0
	sltiu t4, t4, 1
	slt t3, s0, t2
	sub s0, t3, x0
	sltiu s0, s0, 1
	beq t4, x0, and_false_8
	beq s0, x0, and_false_8
	addi s0, x0, 1
	jal x0, and_end_9
and_false_8:
	addi s0, x0, 0
and_end_9:
	slt t4, t2, a0
	sub t3, t4, x0
	sltiu t3, t3, 1
	bne s0, x0, or_true_10
	bne t3, x0, or_true_10
	addi t3, x0, 0
	jal x0, or_end_11
or_true_10:
	addi t3, x0, 1
or_end_11:
	beq t3, x0, else_12
	jal x0, endif_13
else_12:
	slt t3, t2, a0
	slt s0, s0, t2
	slt t4, a0, s0
	sub s1, t4, x0
	sltiu s1, s1, 1
	beq s0, x0, and_false_14
	beq s1, x0, and_false_14
	addi s1, x0, 1
	jal x0, and_end_15
and_false_14:
	addi s1, x0, 0
and_end_15:
	bne t3, x0, or_true_16
	bne s1, x0, or_true_16
	addi s1, x0, 0
	jal x0, or_end_17
or_true_16:
	addi s1, x0, 1
or_end_17:
	beq s1, x0, else_18
	jal x0, endif_19
else_18:
	slt s1, s0, t2
	sub t2, a0, s0
	sub t3, t2, x0
	sltu t3, x0, t3
	bne s1, x0, or_true_20
	bne t3, x0, or_true_20
	addi t3, x0, 0
	jal x0, or_end_21
or_true_20:
	addi t3, x0, 1
or_end_21:
	sub s1, t3, x0
	sltiu s1, s1, 1
	sub t3, s0, a0
	sub t0, t3, x0
	sltiu t0, t0, 1
	beq s1, x0, and_false_22
	beq t0, x0, and_false_22
	addi t0, x0, 1
	jal x0, and_end_23
and_false_22:
	addi t0, x0, 0
and_end_23:
	beq t0, x0, else_24
	jal x0, endif_25
else_24:
endif_25:
endif_19:
endif_13:
endif_7:
endif_3:
while_start_26:
	addi t0, x0, 1
	beq t0, x0, while_end_27
	jal x0, while_start_26
while_end_27:
	addi a0, x0, 0
	jal x0, complexFunction_return

complexFunction_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

shortCircuit:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi s0, a0, 0
	addi a0, t2, 0
	addi t2, x0, 0
	slt t3, t2, s0
	div t2, a0, s0
	addi t4, x0, 2
	slt s0, t4, t2
	beq t3, x0, and_false_0
	beq s0, x0, and_false_0
	addi s0, x0, 1
	jal x0, and_end_1
and_false_0:
	addi s0, x0, 0
and_end_1:
	beq s0, x0, else_2
	jal x0, endif_3
else_2:
endif_3:
	addi s0, x0, 0
	slt t3, s0, s0
	addi t0, x0, 0
	slt s0, a0, t0
	bne t3, x0, or_true_4
	bne s0, x0, or_true_4
	addi s0, x0, 0
	jal x0, or_end_5
or_true_4:
	addi s0, x0, 1
or_end_5:
	beq s0, x0, else_6
	jal x0, endif_7
else_6:
endif_7:
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
	addi s0, a0, 0
while_start_0:
	addi a0, x0, 0
	slt t2, a0, s0
	beq t2, x0, while_end_1
	jal x0, while_start_0
while_end_1:
	addi a0, x0, 0
	jal x0, nestedLoopsAndConditions_return

nestedLoopsAndConditions_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

func1:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi s0, a0, 0
	addi a0, t2, 0
	addi t2, t3, 0
	addi t3, x0, 0
	sub t4, t2, t3
	sub t3, t4, x0
	sltiu t3, t3, 1
	beq t3, x0, else_0
	mul t3, s0, a0
	addi a0, t3, 0
	jal x0, func1_return
else_0:
	sub t3, a0, t2
	addi t2, x0, 0
	addi a0, s0, 0
	addi t2, t3, 0
	addi t3, t2, 0
	jal ra, func1
	addi t2, a0, 0
	addi a0, t2, 0
	jal x0, func1_return
endif_1:

func1_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

func2:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi s0, a0, 0
	addi a0, t2, 0
	beq a0, x0, else_0
	rem t2, s0, a0
	addi t3, x0, 0
	addi a0, t2, 0
	addi t2, t3, 0
	jal ra, func2
	addi t3, a0, 0
	addi a0, t3, 0
	jal x0, func2_return
else_0:
	addi a0, s0, 0
	jal x0, func2_return
endif_1:

func2_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

func3:
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
	addi t2, x0, 1
	add t3, s0, t2
	addi a0, t3, 0
	jal x0, func3_return
else_0:
	add t3, s0, a0
	addi t0, x0, 0
	addi a0, t3, 0
	addi t2, t0, 0
	jal ra, func3
	addi t0, a0, 0
	addi a0, t0, 0
	jal x0, func3_return
endif_1:

func3_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

func4:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi s0, a0, 0
	addi a0, t2, 0
	addi t2, t3, 0
	beq s0, x0, else_0
	addi a0, a0, 0
	jal x0, func4_return
else_0:
	addi a0, t2, 0
	jal x0, func4_return
endif_1:

func4_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

func5:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi s0, a0, 0
	addi t2, x0, 0
	sub a0, t2, s0
	addi a0, a0, 0
	jal x0, func5_return

func5_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

func6:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi s0, a0, 0
	addi a0, t2, 0
	beq s0, x0, and_false_0
	beq a0, x0, and_false_0
	addi t2, x0, 1
	jal x0, and_end_1
and_false_0:
	addi t2, x0, 0
and_end_1:
	beq t2, x0, else_2
	addi a0, x0, 1
	jal x0, func6_return
else_2:
	addi a0, x0, 0
	jal x0, func6_return
endif_3:

func6_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

func7:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi s0, a0, 0
	sub a0, s0, x0
	sltiu a0, a0, 1
	beq a0, x0, else_0
	addi a0, x0, 1
	jal x0, func7_return
else_0:
	addi a0, x0, 0
	jal x0, func7_return
endif_1:

func7_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

nestedCalls:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi s0, a0, 0
	addi a0, t2, 0
	addi t2, t3, 0
	addi t3, t4, 0
	addi t4, s0, 0
	addi s0, s1, 0
	addi s1, s2, 0
	addi s2, s3, 0
	lw s3, 0(s0)
	lw s4, 4(s0)
	addi s5, x0, 2
	addi a0, s5, 0
	jal ra, func7
	addi s5, a0, 0
	addi s6, x0, 8
	addi a0, s6, 0
	jal ra, func5
	addi s6, a0, 0
	addi a0, s5, 0
	addi t2, s6, 0
	jal ra, func6
	addi s6, a0, 0
	addi s5, x0, 8
	addi a0, s6, 0
	addi t2, s5, 0
	jal ra, func2
	addi s5, a0, 0
	addi s6, x0, 9
	addi a0, s5, 0
	addi t2, s6, 0
	jal ra, func3
	addi s6, a0, 0
	addi a0, s6, 0
	jal ra, func5
	addi s6, a0, 0
	addi a0, a0, 0
	jal ra, func5
	addi s5, a0, 0
	addi a0, t3, 0
	jal ra, func7
	addi s7, a0, 0
	addi a0, t2, 0
	addi t2, s7, 0
	jal ra, func6
	addi s7, a0, 0
	addi a0, s0, 0
	jal ra, func7
	addi s8, a0, 0
	addi a0, t4, 0
	addi t2, s8, 0
	jal ra, func2
	addi s8, a0, 0
	addi a0, s5, 0
	addi t2, s7, 0
	addi t3, s8, 0
	jal ra, func4
	addi s8, a0, 0
	addi a0, s8, 0
	addi t2, s1, 0
	jal ra, func3
	addi s8, a0, 0
	addi a0, s8, 0
	addi t2, s2, 0
	jal ra, func2
	addi s8, a0, 0
	addi a0, s4, 0
	jal ra, func7
	addi s7, a0, 0
	addi a0, s3, 0
	addi t2, s7, 0
	jal ra, func3
	addi s7, a0, 0
	addi s5, x0, 2
	addi a0, s8, 0
	addi t2, s7, 0
	addi t3, s5, 0
	jal ra, func1
	addi s5, a0, 0
	addi a0, s6, 0
	addi t2, s0, 0
	addi t3, s5, 0
	jal ra, func4
	addi s5, a0, 0
	addi s6, x0, 8
	addi s7, x0, 8
	addi a0, s7, 0
	jal ra, func7
	addi s7, a0, 0
	addi s8, x0, 9
	addi a0, s7, 0
	addi t2, s8, 0
	jal ra, func3
	addi s8, a0, 0
	addi a0, s6, 0
	addi t2, s8, 0
	jal ra, func2
	addi s8, a0, 0
	addi a0, s5, 0
	addi t2, s8, 0
	jal ra, func3
	addi s8, a0, 0
	addi a0, s8, 0
	addi t2, s0, 0
	addi t3, a0, 0
	jal ra, func1
	addi t0, a0, 0
	addi a0, t0, 0
	addi t2, t2, 0
	jal ra, func2
	addi t2, a0, 0
	addi a0, s0, 0
	jal ra, func5
	addi s0, a0, 0
	addi a0, t4, 0
	addi t2, s0, 0
	jal ra, func3
	addi s0, a0, 0
	addi a0, s1, 0
	jal ra, func5
	addi s1, a0, 0
	addi a0, s0, 0
	addi t2, s1, 0
	jal ra, func2
	addi s1, a0, 0
	addi a0, s3, 0
	jal ra, func7
	addi s3, a0, 0
	addi a0, s1, 0
	addi t2, s2, 0
	addi t3, s3, 0
	jal ra, func1
	addi s3, a0, 0
	addi a0, s4, 0
	jal ra, func5
	addi s4, a0, 0
	addi a0, s3, 0
	addi t2, s4, 0
	jal ra, func2
	addi s4, a0, 0
	addi s3, x0, 2
	addi a0, s4, 0
	addi t2, s3, 0
	jal ra, func3
	addi s3, a0, 0
	addi a0, t2, 0
	addi t2, t3, 0
	addi t3, s3, 0
	jal ra, func1
	addi s3, a0, 0
	addi a0, s3, 0
	jal x0, nestedCalls_return

nestedCalls_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

main:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t5, x0, 0
	sw t5, -4(s0)
	addi a0, x0, 12
	addi a0, a0, 0
	jal ra, fibonacci
	addi t2, a0, 0
	addi t3, x0, 22
	addi t4, x0, 15
	addi a0, t3, 0
	addi t2, t4, 0
	jal ra, gcd
	addi t4, a0, 0
	addi t3, x0, 17
	addi a0, t3, 0
	jal ra, isPrime
	addi t3, a0, 0
	addi s0, x0, 8
	addi a0, s0, 0
	jal ra, factorial
	addi s0, a0, 0
	addi s1, x0, 7
	addi s2, x0, 3
	addi a0, s1, 0
	addi t2, s2, 0
	jal ra, combination
	addi s2, a0, 0
	addi s1, x0, 3
	addi s3, x0, 11
	addi a0, s1, 0
	addi t2, s3, 0
	jal ra, power
	addi s3, a0, 0
	addi s1, x0, 3
	addi s4, x0, 5
	addi s5, x0, 1
	addi a0, s1, 0
	addi t2, s4, 0
	addi t3, s5, 0
	jal ra, complexFunction
	addi s5, a0, 0
	addi s5, x0, -5
	addi s4, x0, 10
	addi a0, s5, 0
	addi t2, s4, 0
	jal ra, shortCircuit
	addi s4, a0, 0
	addi s4, x0, 10
	addi a0, s4, 0
	jal ra, nestedLoopsAndConditions
	addi t5, a0, 0
	sw t5, -8(s0)
	addi s5, x0, 1
	addi s1, x0, 2
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
	addi t2, s1, 0
	addi t3, s6, 0
	addi t4, s7, 0
	addi t4, s8, 0
	addi t3, s9, 0
	addi t3, s10, 0
	addi s0, s11, 0
	jal ra, nestedCalls
	addi s11, a0, 0
	addi sp, sp, 8
	add t1, t2, t4
	add t2, t1, t3
	add t3, t2, s0
	sub s0, t3, s2
	add s2, s0, s3
	lw t5, -8(s0)
	sub s3, s2, t5
	addi s2, x0, 256
	rem s0, s3, s2
	addi t5, s0, 0
	sw t5, -4(s0)
	lw t5, -4(s0)
	addi a0, t5, 0
	jal x0, main_return

main_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

