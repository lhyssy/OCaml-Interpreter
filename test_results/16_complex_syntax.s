.globl main
.text
factorial:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, x0, 1
	addi t2, x0, 0
	slt t3, t2, t0
	sub t4, t3, x0
	sltiu t4, t4, 1
	beq t4, x0, else_17
	addi a0, x0, 1
	jal x0, factorial_return
else_17:
while_start_19:
	addi t4, x0, 1
	slt t3, t4, t0
	beq t3, x0, while_end_21
	mul t4, t1, t0
	addi t1, t4, 0
	addi t3, x0, 1
	sub t4, t0, t3
	addi t0, t4, 0
while_continue_20:
	jal x0, while_start_19
while_end_21:
	addi a0, t1, 0
	jal x0, factorial_return
endif_18:

factorial_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

main:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t0, x0, 0
	addi t1, x0, 1
	addi t0, t1, 0
while_start_22:
	addi t1, x0, 100
	slt t2, t1, t0
	beq t2, x0, while_end_24
	addi t1, x0, 2
	rem t2, t0, t1
	addi t3, x0, 0
	sub t1, t2, t3
	sub t4, t1, x0
	sltiu t4, t4, 1
	beq t4, x0, else_25
	srli t1, t0, 1
	addi t0, t1, 0
	jal x0, endif_26
else_25:
	addi t1, x0, 1
	sub t4, t0, t1
	addi t0, t4, 0
endif_26:
while_continue_23:
	jal x0, while_start_22
while_end_24:
	addi t4, x0, 8
	rem t1, t0, t4
	addi t2, x0, 3
	addi a0, t2, 0
	jal ra, factorial
	addi t2, a0, 0
	div t0, t1, t2
	addi a0, t0, 0
	jal x0, main_return

main_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

