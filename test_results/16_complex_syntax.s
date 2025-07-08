.globl main
.text
factorial:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi s0, a0, 0
	addi a0, x0, 0
	slt t2, a0, s0
	sub t1, t2, x0
	sltiu t1, t1, 1
	beq t1, x0, else_0
	addi a0, x0, 1
	jal x0, factorial_return
else_0:
while_start_2:
	addi t1, x0, 1
	slt t2, t1, s0
	beq t2, x0, while_end_3
	addi t2, x0, 1
	sub t1, s0, t2
	addi s0, t1, 0
	jal x0, while_start_2
while_end_3:
	addi a0, x0, 1
	jal x0, factorial_return
endif_1:

factorial_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

main:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	addi s0, x0, 1
	addi a0, x0, 3
	addi a0, a0, 0
	jal ra, factorial
	addi t2, a0, 0
	div t1, s0, t2
	addi a0, t1, 0
	jal x0, main_return

main_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

