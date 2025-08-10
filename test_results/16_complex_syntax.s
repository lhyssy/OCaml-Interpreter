.globl main
.text
factorial:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, x0, 1
	addi t2, x0, 0
	blt t2, t0, else_0
	addi a0, x0, 1
	jal x0, factorial_return
else_0:
while_start_2:
	addi t2, x0, 1
	bge t2, t0, while_end_4
	mul t1, t1, t0
	addi t0, t0, -1
	jal x0, while_start_2
while_end_4:
	addi a0, t1, 0
	jal x0, factorial_return
factorial_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

main:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	addi s1, x0, 0
	addi s2, x0, 3
	addi s3, x0, 1
while_start_5:
	addi s4, x0, 1
	bge s4, s2, while_end_7
	mul s3, s3, s2
	addi s2, s2, -1
	jal x0, while_start_5
while_end_7:
	addi s1, s3, 0
while_start_8:
	addi s3, x0, 100
	bge s3, s1, while_end_10
	addi s3, x0, 2
	rem s3, s1, s3
	addi s2, x0, 0
	bne s3, s2, else_11
	srli s1, s1, 1
	jal x0, endif_12
else_11:
	addi s1, s1, -1
endif_12:
	jal x0, while_start_8
while_end_10:
	addi s3, x0, 3
	addi a0, s3, 0
	jal ra, factorial
	addi t0, a0, 0
	div t0, s1, t0
	addi a0, t0, 0
	jal x0, main_return
main_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

