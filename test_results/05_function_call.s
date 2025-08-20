.globl main
.text
add:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	add t0, a0, a1
	addi a0, t0, 0
	jal x0, add_return
add_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

main:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	addi s1, x0, 3
	addi s2, x0, 4
	addi a0, s1, 0
	addi a1, s2, 0
	jal ra, add
	addi t0, a0, 0
	addi a0, t0, 0
	jal x0, main_return
main_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

