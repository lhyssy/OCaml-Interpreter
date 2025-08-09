.globl main
.text
factorial:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
endif_1:
	jal x0, factorial_return
while_end_4:
	jal x0, while_start_2
	addi t0, t0, -1
	mul t1, t1, t0
	bge t0, t0, while_end_4
	addi t0, x0, 1
while_start_2:
	jal x0, endif_1
factorial_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

main:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	jal x0, main_return
main_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

