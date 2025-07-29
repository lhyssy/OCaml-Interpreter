.globl main
.text
main:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t0, x0, 0
while_start_0:
	addi t1, x0, 10
	slt t2, t0, t1
	beq t2, x0, while_end_2
	addi t1, x0, 5
	sub t2, t0, t1
	sub t3, t2, x0
	sltiu t3, t3, 1
	beq t3, x0, else_3
	jal x0, while_end_2
else_3:
endif_4:
	addi t3, x0, 1
	add t2, t0, t3
	addi t0, t2, 0
while_continue_1:
	jal x0, while_start_0
while_end_2:
	addi a0, t0, 0
	jal x0, main_return

main_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

