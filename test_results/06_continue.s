.globl main
.text
main:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	bge t0, t1, while_end_2
	addi t1, x0, 5
while_start_0:
	bne t0, t1, else_3
	addi t1, x0, 3
	addi t0, t0, 1
	jal x0, while_start_0
else_3:
	jal x0, while_start_0
	jal x0, main_return
	addi a0, t0, 0
while_end_2:
main_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

