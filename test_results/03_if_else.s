.globl main
.text
main:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t0, x0, 3
	addi t1, x0, 2
	bge t1, t0, else_0
	addi t0, t0, 1
	jal x0, endif_1
else_0:
	addi t0, t0, -1
endif_1:
	addi a0, t0, 0
	jal x0, main_return
main_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

