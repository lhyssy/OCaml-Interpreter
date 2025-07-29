.globl main
.text
abs:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, x0, 0
	slt t2, t0, t1
	beq t2, x0, else_80
	addi t1, x0, 0
	sub t2, t1, t0
	addi a0, t2, 0
	jal x0, abs_return
else_80:
	addi a0, t0, 0
	jal x0, abs_return
endif_81:

abs_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

compute:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, a1, 0
	addi t2, a2, 0
	addi t3, a3, 0
	addi t4, a4, 0
	addi s1, a5, 0
	addi s2, a6, 0
	addi s3, a7, 0
	mul s4, t1, t2
	add s5, t0, s4
	addi a0, t4, 0
	jal ra, abs
	addi t4, a0, 0
	addi t0, x0, 1
	add s4, t4, t0
	div t1, t3, s4
	sub t4, s5, t1
	addi a0, s2, 0
	jal ra, abs
	addi s2, a0, 0
	addi s5, x0, 1
	add t1, s2, s5
	rem t3, s1, t1
	mul s2, t3, s3
	add s1, t4, s2
	addi a0, s1, 0
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
	addi t0, x0, 528
	addi t1, x0, 1056
	addi t2, x0, 1584
	addi t3, x0, 1616
	addi t4, x0, 36
	addi s1, x0, 72
	addi s2, x0, 108
	addi s3, x0, 116
	addi a0, t0, 0
	addi a1, t1, 0
	addi a2, t2, 0
	addi a3, t3, 0
	addi a4, t4, 0
	addi a5, s1, 0
	addi a6, s2, 0
	addi a7, s3, 0
	jal ra, compute
	addi s3, a0, 0
	addi a0, s3, 0
	jal x0, main_return

main_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

