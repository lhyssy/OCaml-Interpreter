.globl main
.text
fact:
	addi sp, sp, -32
	sw ra, 28(sp)
	sw s0, 24(sp)
	sw s1, 20(sp)
	sw s2, 16(sp)
	sw s3, 12(sp)
	addi s0, sp, 32
	addi s1, a0, 0
	addi s2, x0, 1
	blt s2, s1, else_0
	addi a0, x0, 1
	jal x0, fact_return
else_0:
	addi s2, x0, 1
	sub s3, s1, s2
	addi a0, s3, 0
	jal ra, fact
	addi t0, a0, 0
	mul t1, s1, t0
	addi a0, t1, 0
	jal x0, fact_return
endif_1:
fact_return:
	lw ra, 28(sp)
	lw s0, 24(sp)
	lw s1, 20(sp)
	lw s2, 16(sp)
	lw s3, 12(sp)
	addi sp, sp, 32
	jalr x0, ra, 0

main:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	addi s1, x0, 5
	addi a0, s1, 0
	jal ra, fact
	addi t0, a0, 0
	addi a0, t0, 0
	jal x0, main_return
main_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

