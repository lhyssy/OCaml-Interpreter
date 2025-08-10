.globl main
.text
sum:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, x0, 0
	addi t2, x0, 0
while_start_0:
	bge t2, t0, while_end_2
	addi t3, x0, 2
	rem t3, t2, t3
	addi t4, x0, 0
	bne t3, t4, else_3
	add t1, t1, t2
	jal x0, endif_4
else_3:
	sub t1, t1, t2
endif_4:
	addi t2, t2, 1
	jal x0, while_start_0
while_end_2:
	addi a0, t1, 0
	jal x0, sum_return
sum_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

main:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	addi s1, x0, 5
	addi s2, x0, 10
	addi a0, s1, 0
	jal ra, sum
	addi t0, a0, 0
	addi sp, sp, -4
	sw t0, 0(sp)
	addi a0, s2, 0
	jal ra, sum
	lw t0, 0(sp)
	addi sp, sp, 4
	addi t1, a0, 0
	add t0, t0, t1
	addi t1, x0, 0
	bge t1, t0, else_5
	slli t0, t0, 1
	jal x0, endif_6
else_5:
	addi t1, x0, 0
	sub t0, t1, t0
endif_6:
	addi t1, x0, 0
	addi t2, x0, 0
while_start_7:
	bge t2, t0, while_end_9
	addi t3, x0, 3
	rem t3, t2, t3
	addi t4, x0, 0
	bne t3, t4, else_10
	add t1, t1, t2
	jal x0, endif_11
else_10:
endif_11:
	addi t3, x0, 15
	bne t2, t3, else_12
	jal x0, while_end_9
else_12:
	addi t2, t2, 1
	jal x0, while_start_7
while_end_9:
	addi a0, t1, 0
	jal x0, main_return
main_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

