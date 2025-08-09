.globl main
.text
abs:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
endif_1:
	jal x0, abs_return
	jal x0, endif_1
abs_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

echo:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	jal x0, echo_return
echo_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

compute:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	jal x0, compute_return
compute_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
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

