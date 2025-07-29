.globl main
.text
main:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t0, x0, 0
	addi t1, x0, 0
while_start_5:
	addi t2, x0, 5
	slt t3, t0, t2
	beq t3, x0, while_end_7
	addi t2, x0, 1
	add t3, t0, t2
	addi t0, t3, 0
	addi t2, x0, 3
	sub t3, t0, t2
	sub t4, t3, x0
	sltiu t4, t4, 1
	beq t4, x0, else_8
	jal x0, while_continue_6
else_8:
endif_9:
	addi t4, x0, 1
	add t3, t1, t4
	addi t1, t3, 0
while_continue_6:
	jal x0, while_start_5
while_end_7:
	addi a0, t1, 0
	jal x0, main_return

main_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

