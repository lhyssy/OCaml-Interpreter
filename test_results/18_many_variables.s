.globl main
.text
abs:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi s0, a0, 0
	addi a0, x0, 0
	slt t2, s0, a0
	beq t2, x0, else_0
	addi t2, x0, 0
	sub t1, t2, s0
	addi a0, t1, 0
	jal x0, abs_return
else_0:
	addi a0, s0, 0
	jal x0, abs_return
endif_1:

abs_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

compute:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi s0, a0, 0
	addi a0, t2, 0
	addi t2, t3, 0
	addi t3, t4, 0
	addi t4, s0, 0
	addi s0, s1, 0
	addi s1, s2, 0
	addi s2, s3, 0
	mul s3, a0, t2
	add t2, s0, s3
	addi a0, t4, 0
	jal ra, abs
	addi t4, a0, 0
	addi t0, x0, 1
	add s3, t4, t0
	div t4, t3, s3
	sub t3, t2, t4
	addi a0, s1, 0
	jal ra, abs
	addi s1, a0, 0
	addi t1, x0, 1
	add t2, s1, t1
	rem s1, s0, t2
	mul s0, s1, s2
	add s2, t3, s0
	addi a0, s2, 0
	jal x0, compute_return

compute_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

main:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	addi s0, x0, 528
	addi a0, x0, 1056
	addi t2, x0, 1584
	addi t3, x0, 1616
	addi t4, x0, 36
	addi s0, x0, 72
	addi s1, x0, 108
	addi s2, x0, 116
	addi a0, s0, 0
	addi t2, a0, 0
	addi t3, t2, 0
	addi t4, t3, 0
	addi s0, t4, 0
	addi s1, s0, 0
	addi s2, s1, 0
	addi s1, s2, 0
	jal ra, compute
	addi s1, a0, 0
	addi a0, s1, 0
	jal x0, main_return

main_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

