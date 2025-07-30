.globl main
.text
factorial:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, x0, 1
	addi t2, x0, 0
	slt t3, t2, t0
	sub t4, t3, x0
	sltiu t4, t4, 1
	beq t4, x0, else_0
	addi a0, x0, 1
	jal x0, factorial_return
else_0:
while_start_2:
	addi t4, x0, 1
	slt t3, t4, t0
	beq t3, x0, while_end_4
	mul t4, t1, t0
	addi t1, t4, 0
	addi t3, x0, 1
	sub t4, t0, t3
	addi t0, t4, 0
while_continue_3:
	jal x0, while_start_2
while_end_4:
	addi a0, t1, 0
	jal x0, factorial_return
endif_1:

factorial_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

main:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	addi s1, x0, 0
	addi s2, x0, 1
	addi s1, s2, 0
while_start_5:
	addi s2, x0, 100
	slt s3, s2, s1
	beq s3, x0, while_end_7
	addi s2, x0, 2
	rem s3, s1, s2
	addi s4, x0, 0
	sub s2, s3, s4
	sub s5, s2, x0
	sltiu s5, s5, 1
	beq s5, x0, else_8
	srli s2, s1, 1
	addi s1, s2, 0
	jal x0, endif_9
else_8:
	addi s2, x0, 1
	sub s5, s1, s2
	addi s1, s5, 0
endif_9:
while_continue_6:
	jal x0, while_start_5
while_end_7:
	addi s5, x0, 8
	rem t0, s1, s5
	addi s2, x0, 3
	addi a0, s2, 0
	jal ra, factorial
	addi t1, a0, 0
	div t2, t0, t1
	addi a0, t2, 0
	jal x0, main_return

main_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

