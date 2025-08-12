.globl main
.text
factorial:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, x0, 1
	blt zero, t0, else_0
	addi a0, x0, 1
	jal x0, factorial_return
else_0:
while_start_2:
	addi t2, x0, 1
	bge t2, t0, while_end_4
	mul t1, t1, t0
	addi t0, t0, -1
	jal x0, while_start_2
while_end_4:
	addi a0, t1, 0
	jal x0, factorial_return
factorial_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

main:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	addi s1, x0, -2
	addi s2, x0, -1
	addi s3, x0, 0
	bge s2, s1, else_5
	sub s4, s1, s2
	addi s5, x0, 1
	bge s5, s4, else_5
	addi s4, x0, 1
	blt zero, s1, else_7
	addi s3, x0, 1
	jal x0, endif_8
else_7:
while_start_9:
	addi s5, x0, 1
	bge s5, s1, while_end_11
	mul s4, s4, s1
	addi s1, s1, -1
	jal x0, while_start_9
while_end_11:
	addi s3, s4, 0
endif_8:
	jal x0, endif_6
else_5:
	slt s4, s1, s2
	bne s4, x0, or_true_14
	bne s1, s2, else_12
or_true_14:
	add s4, s1, s2
	addi s5, x0, 0
	sub s4, s5, s4
	addi s5, x0, 1
	blt zero, s4, else_15
	addi s3, x0, 1
	jal x0, endif_16
else_15:
while_start_17:
	addi s6, x0, 1
	bge s6, s4, while_end_19
	mul s5, s5, s4
	addi s4, s4, -1
	jal x0, while_start_17
while_end_19:
	addi s3, s5, 0
endif_16:
	jal x0, endif_13
else_12:
	mul s1, s1, s2
	addi s2, x0, 1
	blt zero, s1, else_20
	addi s3, x0, 1
	jal x0, endif_21
else_20:
while_start_22:
	addi s5, x0, 1
	bge s5, s1, while_end_24
	mul s2, s2, s1
	addi s1, s1, -1
	jal x0, while_start_22
while_end_24:
	addi s3, s2, 0
endif_21:
endif_13:
endif_6:
while_start_25:
	addi s2, x0, 100
	bge s2, s3, while_end_27
	addi s2, x0, 2
	rem s2, s3, s2
	bne s2, x0, else_28
	srli s3, s3, 1
	jal x0, endif_29
else_28:
	addi s3, s3, -1
endif_29:
	jal x0, while_start_25
while_end_27:
	addi s2, x0, 3
	addi a0, s2, 0
	jal ra, factorial
	addi t0, a0, 0
	div t0, s3, t0
	addi a0, t0, 0
	jal x0, main_return
main_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

