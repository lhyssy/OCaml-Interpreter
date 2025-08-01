.globl main
.text
count:
	addi sp, sp, -16
	sw s0, 12(sp)
	sw s1, 8(sp)
	sw s2, 4(sp)
	sw s3, 0(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, a1, 0
	addi t2, x0, 0
	addi t3, x0, 0
	addi t4, x0, 0
while_start_0:
	bge t4, t0, while_end_2
	addi s1, x0, 1
	add s2, t4, s1
	addi t4, s2, 0
	addi s1, x0, 0
	addi s2, x0, 1
	bne t4, s2, else_3
	jal x0, while_continue_1
else_3:
while_start_5:
	bge s1, t1, while_end_7
	addi s2, x0, 1
	add s3, s1, s2
	addi s1, s3, 0
	addi s2, x0, 2
	bne s1, s2, else_8
	jal x0, while_continue_6
else_8:
	addi s2, x0, 1
	add s3, t3, s2
	addi t3, s3, 0
while_continue_6:
	jal x0, while_start_5
while_end_7:
	addi s3, x0, 1
	add s1, t2, s3
	addi t2, s1, 0
while_continue_1:
	jal x0, while_start_0
while_end_2:
	mul t0, t3, t2
	addi a0, t0, 0
	jal x0, count_return
count_return:
	lw s0, 12(sp)
	lw s1, 8(sp)
	lw s2, 4(sp)
	lw s3, 0(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

main:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	addi s1, x0, 5
	addi s2, x0, 5
	addi a0, s1, 0
	addi a1, s2, 0
	jal ra, count
	addi t0, a0, 0
	addi a0, t0, 0
	jal x0, main_return
main_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

