.globl main
.text
abs:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, x0, 0
	bge t0, t1, else_0
	addi t1, x0, 0
	sub t2, t1, t0
	addi a0, t2, 0
	jal x0, abs_return
else_0:
	addi a0, t0, 0
	jal x0, abs_return
abs_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

compute:
	addi sp, sp, -48
	sw ra, 44(sp)
	sw s0, 40(sp)
	sw s1, 36(sp)
	sw s2, 32(sp)
	sw s3, 28(sp)
	sw s4, 24(sp)
	sw s5, 20(sp)
	sw s6, 16(sp)
	sw s7, 12(sp)
	addi s0, sp, 48
	addi s1, a0, 0
	addi s2, a1, 0
	addi s3, a2, 0
	addi s4, a3, 0
	addi s5, a4, 0
	addi t0, a5, 0
	addi s6, a6, 0
	addi t1, a7, 0
	mul s7, s2, s3
	add s2, s1, s7
	addi a0, s5, 0
	addi sp, sp, -8
	sw t0, 4(sp)
	sw t1, 8(sp)
	jal ra, abs
	lw t0, 4(sp)
	lw t1, 8(sp)
	addi sp, sp, 8
	addi s5, a0, 0
	addi s1, x0, 1
	add s7, s5, s1
	div s5, s4, s7
	sub t2, s2, s5
	addi a0, s6, 0
	addi sp, sp, -12
	sw t0, 4(sp)
	sw t1, 8(sp)
	sw t2, 12(sp)
	jal ra, abs
	lw t0, 4(sp)
	lw t1, 8(sp)
	lw t2, 12(sp)
	addi sp, sp, 12
	addi t3, a0, 0
	addi t4, x0, 1
	add s6, t3, t4
	rem t3, t0, s6
	mul t0, t3, t1
	add t1, t2, t0
	addi a0, t1, 0
	jal x0, compute_return
compute_return:
	lw ra, 44(sp)
	lw s0, 40(sp)
	lw s1, 36(sp)
	lw s2, 32(sp)
	lw s3, 28(sp)
	lw s4, 24(sp)
	lw s5, 20(sp)
	lw s6, 16(sp)
	lw s7, 12(sp)
	addi sp, sp, 48
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

