.globl main
.text
abs:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, x0, 0
	slt t2, t0, t1
	beq t2, x0, else_0
	addi t1, x0, 0
	sub t2, t1, t0
	addi a0, t2, 0
	jal x0, abs_return
else_0:
	addi a0, t0, 0
	jal x0, abs_return
endif_1:

abs_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

compute:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	addi s1, a0, 0
	addi s2, a1, 0
	addi s3, a2, 0
	addi s4, a3, 0
	addi s5, a4, 0
	addi t0, a5, 0
	addi s6, a6, 0
	addi t1, a7, 0
	mul s7, s2, s3
	add s8, s1, s7
	addi a0, s5, 0
	jal ra, abs
	addi s5, a0, 0
	addi s1, x0, 1
	add s7, s5, s1
	div s2, s4, s7
	sub t2, s8, s2
	addi a0, s6, 0
	jal ra, abs
	addi t3, a0, 0
	addi t4, x0, 1
	add s6, t3, t4
	rem s8, t0, s6
	mul t3, s8, t1
	add t0, t2, t3
	addi a0, t0, 0
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
	addi s1, x0, 528
	addi s2, x0, 1056
	addi s3, x0, 1584
	addi s4, x0, 1616
	addi s5, x0, 36
	addi s6, x0, 72
	addi s7, x0, 108
	addi s8, x0, 116
	addi a0, s1, 0
	addi a1, s2, 0
	addi a2, s3, 0
	addi a3, s4, 0
	addi a4, s5, 0
	addi a5, s6, 0
	addi a6, s7, 0
	addi a7, s8, 0
	jal ra, compute
	addi t0, a0, 0
	addi a0, t0, 0
	jal x0, main_return

main_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

