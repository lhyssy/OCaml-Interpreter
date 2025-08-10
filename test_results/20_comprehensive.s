.globl main
.text
fibonacci:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	blt t0, a0, else_0
	addi t0, x0, 1
	jal x0, fibonacci_return
	addi a0, t0, 0
	add t0, a0, a0
	jal ra, fibonacci
	addi a0, t0, 0
	addi t0, a0, -2
	jal ra, fibonacci
	addi a0, t0, 0
	addi t0, a0, -1
else_0:
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
	bne t0, t0, else_2
	addi t0, x0, 0
	addi t0, a1, 0
	jal x0, gcd_return
else_2:
	jal x0, gcd_return
	jal ra, gcd
	addi a1, t0, 0
	addi a0, a1, 0
	rem t0, a0, a1
gcd_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

isPrime:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	blt t0, a0, else_4
	addi t0, x0, 1
	jal x0, isPrime_return
	addi a0, x0, 0
else_4:
	blt t0, a0, else_6
	addi t0, x0, 3
	jal x0, isPrime_return
	addi a0, x0, 1
else_6:
	bne t0, x0, or_true_10
	sub t0, t0, x0
	sltiu t0, t0, 1
	rem t0, a0, t0
	addi t0, x0, 2
	bne t0, t0, else_8
	addi t0, x0, 0
	rem t0, a0, t0
	addi t0, x0, 3
	jal x0, isPrime_return
	addi a0, x0, 0
or_true_10:
else_8:
	blt t0, t1, while_end_13
	mul t1, t1, t1
while_start_11:
	bne t2, x0, or_true_16
	sub t2, t2, x0
	sltiu t2, t2, 1
	rem t2, t0, t1
	bne t2, t2, else_14
	addi t2, x0, 0
	rem t2, t0, t2
	addi t2, t1, 2
	jal x0, isPrime_return
	addi a0, x0, 0
or_true_16:
else_14:
	jal x0, while_start_11
	jal x0, isPrime_return
	addi a0, x0, 1
while_end_13:
isPrime_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

factorial:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	bge t0, t0, while_end_19
	addi t0, x0, 0
while_start_17:
	jal x0, while_start_17
	jal x0, factorial_return
	addi a0, t0, 0
while_end_19:
factorial_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

combination:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	bge a0, a1, else_20
	jal x0, combination_return
	addi a0, x0, 0
else_20:
	bne t0, x0, or_true_24
	sub t0, a1, x0
	sltiu t0, t0, 1
	bne a1, a0, else_22
	jal x0, combination_return
	addi a0, x0, 1
or_true_24:
else_22:
	jal x0, combination_return
	addi a0, t0, 0
	div t0, a0, t0
	mul t0, a0, a0
	jal ra, factorial
	addi a0, t0, 0
	sub t0, a0, a1
	jal ra, factorial
	addi a0, a1, 0
	jal ra, factorial
combination_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

power:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	bge t1, t0, while_end_27
	addi t1, x0, 0
while_start_25:
	bne t1, t1, else_28
	addi t1, x0, 1
	rem t1, t0, t1
	addi t1, x0, 2
	jal x0, endif_29
else_28:
endif_29:
	jal x0, while_start_25
	jal x0, power_return
	addi a0, t0, 0
while_end_27:
power_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

complexFunction:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	beq t0, x0, and_false_32
	slt t0, a1, a0
	beq t0, x0, and_false_32
	jal x0, and_end_33
and_false_32:
	bne t0, x0, else_30
and_end_33:
	jal x0, endif_31
	sub t0, t0, t0
	addi t0, x0, 0
	addi t0, a2, -1
	mul t0, a0, a1
	bne t0, x0, or_true_36
	sub t0, t0, x0
	sltiu t0, t0, 1
	slt t0, a0, a2
else_30:
	bge a2, a1, else_34
	jal x0, endif_35
	addi t0, t0, 2
	sub t0, a2, a1
or_true_36:
	beq t0, x0, and_false_40
	slt t0, a0, a2
	sub t0, t0, x0
	sltiu t0, t0, 1
	slt t0, a1, a0
else_34:
	beq t0, x0, and_false_40
	jal x0, and_end_41
and_false_40:
	bne t0, x0, or_true_39
and_end_41:
	blt a2, a1, else_37
	jal x0, endif_38
	sub t0, t0, t0
	addi t0, x0, 0
	addi t0, a2, -3
	mul t0, a1, a0
or_true_39:
	bne t0, x0, or_true_44
	slt t0, a2, a1
else_37:
	bge a0, a2, else_42
	blt a1, a0, else_42
	jal x0, endif_43
	addi t0, t0, 4
	sub t0, a2, a0
or_true_44:
	bne t0, x0, or_true_47
	sub t0, a1, a0
	slt t0, a0, a2
else_42:
	bne t0, x0, or_true_47
	jal x0, or_end_48
or_true_47:
	bne t0, x0, else_45
or_end_48:
	bne a0, a1, else_45
	jal x0, endif_46
	addi t0, a1, -5
	mul t0, a2, a0
	addi t0, t0, 6
	sub t0, a1, t0
	sub t0, t0, a0
	addi t0, x0, 0
else_45:
endif_46:
endif_43:
endif_38:
endif_35:
endif_31:
	bge t0, t0, while_end_51
	addi t0, x0, 10
while_start_49:
	jal x0, while_start_49
	jal x0, complexFunction_return
	addi a0, t0, 0
while_end_51:
complexFunction_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

shortCircuit:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	bge t0, a0, else_52
	addi t0, x0, 0
	bge t0, t0, else_52
	addi t0, x0, 2
	div t0, a1, a0
	jal x0, endif_53
else_52:
	bne t0, x0, or_true_56
	slt t0, a0, t0
	addi t0, x0, 0
endif_53:
	bge a1, t0, else_54
	addi t0, x0, 0
	jal x0, endif_55
or_true_56:
else_54:
	jal x0, shortCircuit_return
	addi a0, t0, 0
endif_55:
shortCircuit_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

nestedLoopsAndConditions:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	bge t0, t0, while_end_59
while_start_57:
	bge t1, t0, while_end_62
while_start_60:
	bne t2, t2, else_63
	addi t2, x0, 0
	rem t2, t2, t2
	addi t2, x0, 2
	add t2, t0, t1
	jal x0, endif_64
	mul t2, t0, t1
	bge t2, t3, else_65
	addi t3, x0, 0
	add t2, t2, t3
	mul t3, t0, t1
else_63:
	jal x0, while_start_60
else_65:
	bge t3, t2, else_67
	addi t3, x0, 952
endif_64:
	jal x0, while_end_62
else_67:
	jal x0, while_start_60
	bge t1, t2, else_69
	addi t1, x0, 1007
while_end_62:
	jal x0, while_end_59
else_69:
	jal x0, while_start_57
	jal x0, nestedLoopsAndConditions_return
	addi a0, t2, 0
while_end_59:
nestedLoopsAndConditions_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

func1:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	bne t0, t0, else_71
	addi t0, x0, 0
	addi t0, a2, 0
	jal x0, func1_return
	addi a0, t0, 0
	mul t0, a0, a1
	jal x0, func1_return
	jal ra, func1
	addi a2, x0, 0
	addi a1, t0, 0
	sub t0, a1, a2
else_71:
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
	beq a1, x0, else_73
	jal x0, func2_return
	jal ra, func2
	addi a1, x0, 0
	addi a0, t0, 0
	rem t0, a0, a1
	jal x0, func2_return
else_73:
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
	bne t0, t0, else_75
	addi t0, x0, 0
	addi t0, a1, 0
	jal x0, func3_return
	addi a0, t0, 0
	addi t0, a0, 1
	jal x0, func3_return
	jal ra, func3
	addi a1, x0, 0
	addi a0, t0, 0
	add t0, a0, a1
else_75:
func3_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

func4:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	beq a0, x0, else_77
	jal x0, func4_return
	addi a0, a1, 0
	jal x0, func4_return
	addi a0, a2, 0
else_77:
func4_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

func5:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	jal x0, func5_return
	addi a0, t0, 0
	sub t0, t0, a0
	addi t0, x0, 0
func5_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

func6:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	beq a0, x0, else_79
	beq a1, x0, else_79
	jal x0, func6_return
	addi a0, x0, 1
	jal x0, func6_return
	addi a0, x0, 0
else_79:
func6_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

func7:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	bne a0, x0, else_81
	jal x0, func7_return
	addi a0, x0, 1
	jal x0, func7_return
	addi a0, x0, 0
else_81:
func7_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

nestedCalls:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	sw s1, 4(sp)
	sw s2, 0(sp)
	addi s0, sp, 16
	jal x0, nestedCalls_return
	jal ra, func1
	addi a2, a0, 0
	addi a1, a3, 0
	jal ra, func3
	addi a1, x0, 9
	jal ra, func2
	addi a1, a0, 0
	jal ra, func5
	addi a0, s1, 0
	jal ra, func1
	addi a2, a0, 0
	addi a1, a7, 0
	jal ra, func7
	addi a0, s2, 0
	jal ra, func2
	addi a1, a0, 0
	jal ra, func5
	addi a0, a6, 0
	jal ra, func3
	addi a1, a4, 0
	addi a0, a4, 0
	jal ra, func5
	addi a0, a5, 0
	jal ra, func2
	addi a1, a0, 0
	jal ra, func1
	addi a2, a0, 0
	addi a1, a0, 0
	jal ra, func3
	addi a1, a0, 0
	jal ra, func2
	addi a1, x0, 1
	addi a0, x0, 1
	jal ra, func3
	addi a1, x0, 14
	jal ra, func7
	addi a0, x0, 7
	jal ra, func4
	addi a2, a0, 0
	addi a1, a0, 0
	jal ra, func1
	addi a2, x0, 9
	addi a1, a0, 0
	jal ra, func3
	addi a1, s2, 0
	addi a0, s2, 0
	jal ra, func7
	addi a0, s1, 0
	jal ra, func2
	addi a1, a7, 0
	jal ra, func3
	addi a1, a6, 0
	jal ra, func4
	addi a2, a0, 0
	addi a1, a0, 0
	jal ra, func2
	addi a1, a4, 0
	addi a0, a4, 0
	jal ra, func7
	addi a0, a5, 0
	jal ra, func6
	addi a1, a2, 0
	addi a0, a2, 0
	jal ra, func7
	addi a0, a3, 0
	jal ra, func5
	addi a0, x0, 14
	jal ra, func5
	jal ra, func3
	addi a1, x0, 14
	jal ra, func2
	addi a1, x0, 7
	jal ra, func6
	addi a1, a0, 0
	jal ra, func5
	addi a0, x0, 1
	jal ra, func7
	addi a0, x0, 9
	lw s1, 4(s0)
	lw s2, 0(s0)
nestedCalls_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	lw s1, 4(sp)
	lw s2, 0(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

main:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	beq t0, t0, else_83
	addi t0, x0, 144
	addi t0, a0, 0
	jal ra, fibonacci
	addi a0, x0, 12
	jal x0, main_return
	addi a0, x0, 0
else_83:
	beq t0, t0, else_85
	addi t0, x0, 1
	addi t0, a0, 0
	jal ra, gcd
	addi a1, x0, 31
	addi a0, x0, 39
	jal x0, main_return
	addi a0, x0, 0
else_85:
	beq t0, t0, else_87
	addi t0, x0, 0
	addi t0, a0, 0
	jal ra, isPrime
	addi a0, x0, 18
	jal x0, main_return
	addi a0, x0, 0
else_87:
	beq t0, t0, else_89
	addi t0, x0, 720
	addi t0, a0, 0
	jal ra, factorial
	addi a0, x0, 6
	jal x0, main_return
	addi a0, x0, 0
else_89:
	beq t0, t0, else_91
	addi t0, x0, 1
	addi t0, a0, 0
	jal ra, combination
	addi a1, x0, 9
	addi a0, x0, 9
	jal x0, main_return
	addi a0, x0, 0
else_91:
	beq t0, t0, else_93
	li t0, 59049
	addi t0, a0, 0
	jal ra, power
	addi a1, x0, 10
	addi a0, x0, 3
	jal x0, main_return
	addi a0, x0, 0
else_93:
	jal x0, main_return
	addi a0, t0, 0
	add t0, t0, t0
	rem t0, t0, t0
	addi t0, x0, 254
	sub t0, t0, t0
	slli t0, a0, 1
	add t0, t0, t0
	rem t0, t0, t0
	li t0, 37633
	slli t0, a0, 1
	sub t0, t0, t0
	rem t0, t0, t0
	li t0, 37633
	slli t0, a0, 1
	add t0, t0, t0
	rem t0, a0, t0
	li t0, 37633
	sub t0, t0, t0
	rem t0, a0, t0
	li t0, 37633
	add t0, t0, t0
	rem t0, a0, t0
	li t0, 37633
	rem t0, a0, t0
	li t0, 37633
	addi t0, x0, 1
	addi sp, sp, 8
	jal ra, nestedCalls
	addi a7, x0, 985
	addi a6, x0, 196
	addi a5, x0, 944
	addi a4, x0, 801
	addi a3, x0, 45
	addi a2, x0, 686
	addi a1, x0, 908
	addi a0, x0, 539
	sw s1, 4(sp)
	sw s1, 0(sp)
	addi sp, sp, -8
	jal ra, nestedLoopsAndConditions
	addi a0, x0, 10
	jal ra, shortCircuit
	addi a1, x0, 10
	addi a0, x0, -2
	jal ra, complexFunction
	addi a2, x0, 8
	addi a1, x0, 3
	addi a0, x0, 8
main_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

