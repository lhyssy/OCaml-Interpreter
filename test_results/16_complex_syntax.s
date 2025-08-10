.globl main
.text
factorial:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	blt t0, a0, else_0
	addi t0, x0, 0
	addi a0, x0, 1
else_0:
	bge t0, t0, while_end_4
	addi t0, x0, 1
	addi a0, t0, 0
while_end_4:
factorial_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

main:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	addi a0, t0, 0
	div t0, s1, a0
	jal ra, factorial
	addi a0, x0, 3
	addi s1, x0, 1
main_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

