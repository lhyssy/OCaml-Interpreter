.globl main
.text
sum8:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	jal x0, sum8_return
sum8_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

sum16:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	jal x0, sum16_return
sum16_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

sum32:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	jal x0, sum32_return
sum32_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

sum64:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	jal x0, sum64_return
sum64_return:
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

