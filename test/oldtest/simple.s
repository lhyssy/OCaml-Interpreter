.globl main
.text
main:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	li a0, 30
	j main_return

main_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	ret

test:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	li a0, 0
	j test_return

test_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	ret

