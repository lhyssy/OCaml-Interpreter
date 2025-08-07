.globl main
.text
factorial:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, x0, 1
	addi t2, x0, 0
	blt t2, t0, else_0
	addi a0, x0, 1
	jal x0, factorial_return
else_0:
while_start_2:
	addi t2, x0, 1
	bge t2, t0, while_end_4
	mul t1, t1, t0
	addi t0, t0, -1
	jal x0, while_start_2
while_end_4:
	addi a0, t1, 0
	jal x0, factorial_return
factorial_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

main:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t0, x0, 1
	addi s1, x0, 3
	addi sp, sp, -4
	sw t0, 0(sp)
	addi a0, s1, 0
	jal ra, factorial
	lw t0, 0(sp)
	addi sp, sp, 4
	addi t1, a0, 0
	div a0, t0, t1
	jal x0, main_return
main_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

