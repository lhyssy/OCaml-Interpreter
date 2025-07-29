.globl main
.text
main:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t0, x0, 0
while_start_12:
	addi t1, x0, 5
	slt t2, t0, t1
	beq t2, x0, while_end_14
	addi t1, x0, 2
	rem t2, t0, t1
	addi t3, x0, 0
	sub t1, t2, t3
	sub t4, t1, x0
	sltiu t4, t4, 1
	beq t4, x0, else_15
	addi t1, x0, 2
	add t4, t0, t1
	addi t0, t4, 0
	jal x0, endif_16
else_15:
	addi t4, x0, 1
	add t1, t0, t4
	addi t0, t1, 0
endif_16:
while_continue_13:
	jal x0, while_start_12
while_end_14:
	addi a0, t0, 0
	jal x0, main_return

main_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

