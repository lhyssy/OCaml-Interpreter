.globl main
.text
main:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t0, x0, 0
while_start_0:
	addi t1, x0, 5
	bge t0, t1, while_end_2
	addi t2, x0, 2
	rem t1, t0, t2
	addi t3, x0, 0
	bne t1, t3, else_3
	addi t2, x0, 2
	add t1, t0, t2
	addi t0, t1, 0
	jal x0, endif_4
else_3:
	addi t1, x0, 1
	add t2, t0, t1
	addi t0, t2, 0
endif_4:
	jal x0, while_start_0
while_end_2:
	addi a0, t0, 0
	jal x0, main_return
main_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

