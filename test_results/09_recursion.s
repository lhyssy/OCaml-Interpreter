.globl main
.text
fact:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi s0, a0, 0
	addi a0, x0, 1
	slt t2, a0, s0
	sub t3, t2, x0
	sltiu t3, t3, 1
	beq t3, x0, else_0
	addi a0, x0, 1
	jal x0, fact_return
else_0:
	addi t3, x0, 1
	sub t2, s0, t3
	addi a0, t2, 0
	jal ra, fact
	addi t2, a0, 0
	mul t1, s0, t2
	addi a0, t1, 0
	jal x0, fact_return
endif_1:

fact_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

main:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	addi s0, x0, 5
	addi a0, s0, 0
	jal ra, fact
	addi a0, a0, 0
	addi a0, a0, 0
	jal x0, main_return

main_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

