.globl main
.text
main:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t0, x0, 0
	addi t1, x0, 1
	beq t0, x0, else_0
	div t0, t1, t0
	beq t0, x0, else_0
	addi a0, x0, 1
	jal x0, main_return
else_0:
	addi a0, x0, 0
	jal x0, main_return
main_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

