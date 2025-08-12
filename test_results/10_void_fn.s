.globl main
.text
print:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	addi t0, x0, 1
	addi t0, t0, 1
print_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

main:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	jal ra, print
	addi t0, a0, 0
	addi a0, x0, 0
	jal x0, main_return
main_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

