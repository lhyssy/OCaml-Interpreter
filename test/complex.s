.globl main
.text
fibonacci:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
fibonacci_return:
	j fibonacci_return
	mv a0, t1
	add t1, t4, t2
	mv t2, a0
	call fibonacci
	mv a0, t2
	# Setup call arguments
	sub t2, t3, t0
	li t0, 2
	lw t3, -4(s0)
	# Load n
	mv t4, a0
	call fibonacci
	mv a0, t4
	# Setup call arguments
	sub t4, t3, t2
	li t2, 1
	lw t3, -4(s0)
	# Load n
endif_1:
else_0:
	j endif_1
	j fibonacci_return
	mv a0, t3
	lw t3, -4(s0)
	# Load n
	beqz t3, else_0
	seqz t3, t2
	sgt t2, s0, a0
	li a0, 1
	lw s0, -4(s0)
	# Load n
	sw a0, -4(s0)
	# Param n

fibonacci_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	ret

factorial:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
factorial_return:
	j factorial_return
	mv a0, t0
	li t0, 1
while_end_1:
	j while_start_0
	sw t1, -12(s0)
	# Assign i
	li t1, 2
	sw t1, -8(s0)
	# Assign result
	li t1, 1
	beqz t1, while_end_1
	seqz t1, t3
	sgt t3, t1, t2
	lw t2, -4(s0)
	# Load n
	li t1, 1
while_start_0:
	sw a0, -12(s0)
	# Declare i
	li a0, 1
	sw s0, -8(s0)
	# Declare result
	li s0, 1
	sw a0, -4(s0)
	# Param n

factorial_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	ret

isPrime:
	addi sp, sp, -24
	sw ra, 20(sp)
	sw s0, 16(sp)
	addi s0, sp, 24
isPrime_return:
	j isPrime_return
	mv a0, t0
	li t0, 1
while_end_9:
	j while_start_8
	sw t3, -8(s0)
	# Assign i
	li t3, 11
endif_13:
else_12:
	j endif_13
	j isPrime_return
	mv a0, t3
	li t3, 0
	beqz t3, else_12
or_end_11:
	li t3, 1
or_true_10:
	j or_end_11
	li t3, 0
	bnez t3, or_true_10
	bnez t2, or_true_10
	seqz t3, t4
	sub t4, t3, t1
	li t1, 0
	rem t3, t1, t4
	li t4, 7
	lw t1, -4(s0)
	# Load n
	seqz t2, t1
	sub t1, t2, t4
	li t4, 0
	rem t2, t4, t1
	li t1, 5
	lw t4, -4(s0)
	# Load n
	beqz t4, while_end_9
	seqz t4, t1
	sgt t1, t4, t2
	lw t2, -4(s0)
	# Load n
	li t4, 25
while_start_8:
	sw t4, -8(s0)
	# Declare i
	li t4, 5
endif_7:
else_6:
	j endif_7
	j isPrime_return
	mv a0, t4
	li t4, 0
	beqz t4, else_6
or_end_5:
	li t4, 1
or_true_4:
	j or_end_5
	li t4, 0
	bnez t4, or_true_4
	bnez t2, or_true_4
	seqz t4, t1
	sub t1, t4, t3
	li t3, 0
	rem t4, t3, t1
	li t1, 3
	lw t3, -4(s0)
	# Load n
	seqz t2, t3
	sub t3, t2, t1
	li t1, 0
	rem t2, t1, t3
	li t3, 2
	lw t1, -4(s0)
	# Load n
endif_3:
else_2:
	j endif_3
	j isPrime_return
	mv a0, t1
	li t1, 1
	beqz t1, else_2
	seqz t1, t3
	sgt t3, t1, t2
	li t2, 3
	lw t1, -4(s0)
	# Load n
endif_1:
else_0:
	j endif_1
	j isPrime_return
	mv a0, t1
	li t1, 0
	beqz t1, else_0
	seqz t1, t2
	sgt t2, s0, a0
	li a0, 1
	lw s0, -4(s0)
	# Load n
	sw a0, -4(s0)
	# Param n

isPrime_return:
	lw ra, 20(sp)
	lw s0, 16(sp)
	addi sp, sp, 24
	ret

main:
	addi sp, sp, -32
	sw ra, 28(sp)
	sw s0, 24(sp)
	addi s0, sp, 32
main_return:
	j main_return
	mv a0, t0
	li t0, 1
	sw t1, -8(s0)
	# Assign result
	li t1, 1
while_end_1:
	j while_start_0
	sw t1, -20(s0)
	# Assign __i_4
	li t1, 2
	sw t1, -16(s0)
	# Assign __result_5
	li t1, 1
	beqz t1, while_end_1
	li t1, 1
while_start_0:
	sw t1, -20(s0)
	# Declare __i_4
	li t1, 1
	sw t1, -16(s0)
	# Declare __result_5
	li t1, 1
	sw t1, -12(s0)
	# Declare __n_3
	li t1, 5
	sw a0, -8(s0)
	# Declare result
	li a0, 0
	sw s0, -4(s0)
	# Declare choice
	li s0, 2

main_return:
	lw ra, 28(sp)
	lw s0, 24(sp)
	addi sp, sp, 32
	ret

