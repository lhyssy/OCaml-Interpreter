.globl main
.text
fibonacci:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
endif_1:
	jal x0, fibonacci_return
	jal x0, endif_1
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
endif_3:
	jal x0, endif_3
gcd_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

isPrime:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	jal x0, isPrime_return
while_end_13:
	jal x0, while_start_11
	addi t0, t0, 6
endif_15:
else_14:
	jal x0, endif_15
or_true_16:
	bne t1, t1, else_14
	addi t1, x0, 0
	rem t1, t1, t2
	add t2, t0, t2
	addi t2, x0, 2
	bne t2, x0, or_true_16
	sub t2, t2, x0
	sltiu t2, t2, 1
	sub t2, t2, t2
	addi t2, x0, 0
	rem t2, t1, t0
	blt t1, t2, while_end_13
	mul t2, t0, t0
while_start_11:
	addi t0, x0, 5
endif_9:
else_8:
	jal x0, endif_9
or_true_10:
	bne t0, t0, else_8
	addi t0, x0, 0
	rem t0, t1, t0
	addi t0, x0, 3
	bne t0, x0, or_true_10
	sub t0, t0, x0
	sltiu t0, t0, 1
	sub t0, t0, t0
	addi t0, x0, 0
	rem t0, t1, t1
	addi t1, x0, 2
endif_7:
	jal x0, endif_7
endif_5:
	jal x0, endif_5
isPrime_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

factorial:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	jal x0, factorial_return
while_end_19:
	jal x0, while_start_17
	addi t0, t0, -1
	mul t1, t1, t0
	bge t0, t0, while_end_19
	addi t0, x0, 0
while_start_17:
	addi t1, x0, 1
	addi t0, a0, 0
factorial_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

combination:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	jal x0, combination_return
endif_23:
else_22:
	jal x0, endif_23
or_true_24:
	bne t0, t0, else_22
	bne t1, x0, or_true_24
	sub t1, t1, x0
	sltiu t1, t1, 1
	sub t1, t0, t0
	addi t0, x0, 0
endif_21:
	jal x0, endif_21
combination_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

power:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	jal x0, power_return
	jal x0, while_start_25
	srli t0, t0, 1
	mul t0, t0, t0
endif_29:
	jal x0, endif_29
while_start_25:
	addi t0, x0, 1
	addi t0, a1, 0
	addi t0, a0, 0
power_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

complexFunction:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	jal x0, complexFunction_return
while_end_51:
	jal x0, while_start_49
	addi t0, x0, 0
	addi t0, t0, 1
	bge t0, t0, while_end_51
	addi t0, x0, 10
while_start_49:
	addi t0, x0, 0
endif_31:
endif_35:
endif_38:
endif_43:
endif_46:
	mul t0, t0, t1
	sub t1, t1, t1
	addi t1, x0, -6
	sub t1, t1, t2
	sub t2, t3, t2
	addi t3, x0, 0
	jal x0, endif_46
or_end_48:
	addi t3, x0, 1
	jal x0, or_end_48
else_42:
	jal x0, endif_43
or_true_44:
	blt t1, t2, else_42
	bge t2, t0, else_42
	bne t3, x0, or_true_44
	slt t3, t0, t1
else_37:
	jal x0, endif_38
or_true_39:
	blt t0, t1, else_37
	bne t3, x0, or_true_39
and_end_41:
	addi t3, x0, 0
	jal x0, and_end_41
else_34:
	jal x0, endif_35
or_true_36:
	bge t0, t1, else_34
	bne t1, x0, or_true_36
	sub t1, t1, x0
	sltiu t1, t1, 1
	slt t1, t2, t0
	jal x0, endif_31
and_end_33:
	addi t0, x0, 0
	jal x0, and_end_33
complexFunction_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

shortCircuit:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	jal x0, shortCircuit_return
endif_55:
else_54:
	jal x0, endif_55
or_true_56:
	bge t0, t0, else_54
	addi t0, x0, 0
	bne t0, x0, or_true_56
	slt t0, t0, t0
	addi t0, x0, 0
endif_53:
	jal x0, endif_53
shortCircuit_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

nestedLoopsAndConditions:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	jal x0, nestedLoopsAndConditions_return
while_end_59:
	jal x0, while_start_57
	addi t0, t0, 1
endif_70:
	jal x0, endif_70
	jal x0, while_start_60
	addi t1, t1, 1
endif_68:
	jal x0, endif_68
endif_64:
endif_66:
	jal x0, endif_66
	jal x0, endif_64
while_start_60:
	addi t1, x0, 0
	bge t0, t0, while_end_59
while_start_57:
	addi t0, x0, 0
	addi t0, x0, 0
	addi t0, a0, 0
nestedLoopsAndConditions_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

func1:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
endif_72:
	jal x0, func1_return
	jal x0, endif_72
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
endif_74:
	jal x0, func2_return
	jal x0, endif_74
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
endif_76:
	jal x0, func3_return
	jal x0, endif_76
func3_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

func4:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
endif_78:
	jal x0, func4_return
	jal x0, endif_78
func4_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

func5:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	jal x0, func5_return
func5_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

func6:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
endif_80:
	jal x0, func6_return
	jal x0, endif_80
func6_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

func7:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
endif_82:
	jal x0, func7_return
	jal x0, endif_82
func7_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

nestedCalls:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	jal x0, nestedCalls_return
nestedCalls_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

main:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	jal x0, main_return
endif_94:
	jal x0, endif_94
endif_92:
	jal x0, endif_92
endif_90:
	jal x0, endif_90
endif_88:
	jal x0, endif_88
endif_86:
	jal x0, endif_86
endif_84:
	jal x0, endif_84
main_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

