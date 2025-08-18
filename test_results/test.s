.globl main
.text
main:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t0, x0, 100
	addi t1, x0, 50
while_start_0:
	bge zero, t0, while_end_2
	addi t0, t0, -1
	addi t1, t1, 2
	jal x0, while_start_0
while_end_2:
	mul t0, t1, t0
	addi a0, t0, 0
	jal x0, main_return
main_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

