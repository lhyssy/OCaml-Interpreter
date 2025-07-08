.globl main
.text
main:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	addi s0, x0, 0
while_start_0:
	addi a0, x0, 10
	slt t2, s0, a0
	beq t2, x0, while_end_2
	addi t2, x0, 5
	sub t1, s0, t2
	sub t2, t1, x0
	sltiu t2, t2, 1
	beq t2, x0, else_3
	jal x0, while_end_2
else_3:
endif_4:
	addi t2, x0, 1
	add t1, s0, t2
	addi s0, t1, 0
while_continue_1:
	jal x0, while_start_0
while_end_2:
	addi a0, s0, 0
	jal x0, main_return

main_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

