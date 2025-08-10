.globl main
.text
fact:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	blt t0, a0, else_0
	addi t0, x0, 1
	addi a0, x0, 1
	addi a0, t0, 0
	mul t0, a0, a0
	jal ra, fact
	addi a0, t0, 0
	addi t0, a0, -1
else_0:
fact_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

main:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	jal ra, fact
	addi a0, x0, 5
main_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

