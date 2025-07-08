.globl main
.text
add:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi s0, a0, 0
	addi a0, t2, 0
	add t2, s0, a0
	addi a0, t2, 0
	jal x0, add_return

add_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

main:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	addi s0, x0, 3
	addi a0, x0, 4
	addi a0, s0, 0
	addi t0, a0, 0
	jal ra, add
	addi t0, a0, 0
	addi a0, t0, 0
	jal x0, main_return

main_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

