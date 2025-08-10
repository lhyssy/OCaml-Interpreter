.globl main
.text
main:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	bge t0, t1, while_end_2
	addi t1, x0, 5
	bne t1, t1, else_3
	addi t1, x0, 0
	rem t1, t0, t1
	addi t1, x0, 2
else_3:
	addi a0, t0, 0
while_end_2:
main_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

