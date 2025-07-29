.globl main
.text
fact:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, x0, 1
	slt t2, t1, t0
	sub t3, t2, x0
	sltiu t3, t3, 1
	beq t3, x0, else_10
	addi a0, x0, 1
	jal x0, fact_return
else_10:
	addi t3, x0, 1
	sub t2, t0, t3
	addi a0, t2, 0
	jal ra, fact
	addi t2, a0, 0
	mul t3, t0, t2
	addi a0, t3, 0
	jal x0, fact_return
endif_11:

fact_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

main:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t0, x0, 5
	addi a0, t0, 0
	jal ra, fact
	addi t0, a0, 0
	addi a0, t0, 0
	jal x0, main_return

main_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

