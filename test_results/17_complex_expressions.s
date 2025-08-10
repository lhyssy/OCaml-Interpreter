.globl main
.text
factorial:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	blt t0, a0, else_0
	addi t0, x0, 1
	jal x0, factorial_return
	addi a0, x0, 1
else_0:
	jal x0, factorial_return
	addi a0, t0, 0
	mul t0, a0, a0
	jal ra, factorial
	addi a0, t0, 0
	addi t0, a0, -1
factorial_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

fibonacci:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	blt t0, a0, else_2
	addi t0, x0, 0
	jal x0, fibonacci_return
	addi a0, x0, 0
else_2:
	bne s1, t0, else_4
	addi t0, x0, 1
	jal x0, fibonacci_return
	addi a0, x0, 1
else_4:
	jal x0, fibonacci_return
	addi a0, t0, 0
	add t0, a0, a0
	jal ra, fibonacci
	addi a0, t0, 0
	addi t0, a0, -2
	jal ra, fibonacci
	addi a0, t0, 0
	addi t0, a0, -1
fibonacci_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

gcd:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	bne t0, t0, else_6
	addi t0, x0, 0
	addi t0, a1, 0
	jal x0, gcd_return
else_6:
	jal x0, gcd_return
	jal ra, gcd
	addi a1, t0, 0
	addi a0, a1, 0
	rem t0, a0, a1
gcd_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

is_prime:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	blt t0, a0, else_8
	addi t0, x0, 1
	jal x0, is_prime_return
	addi a0, x0, 0
else_8:
	blt t0, a0, else_10
	addi t0, x0, 3
	jal x0, is_prime_return
	addi a0, x0, 1
else_10:
	bne t0, x0, or_true_14
	sub t0, t0, x0
	sltiu t0, t0, 1
	rem t0, a0, t0
	addi t0, x0, 2
	bne t0, t0, else_12
	addi t0, x0, 0
	rem t0, a0, t0
	addi t0, x0, 3
	jal x0, is_prime_return
	addi a0, x0, 0
or_true_14:
else_12:
	blt t0, t1, while_end_17
	mul t1, t1, t1
while_start_15:
	bne t2, x0, or_true_20
	sub t2, t2, x0
	sltiu t2, t2, 1
	rem t2, t0, t1
	bne t2, t2, else_18
	addi t2, x0, 0
	rem t2, t0, t2
	addi t2, t1, 2
	jal x0, is_prime_return
	addi a0, x0, 0
or_true_20:
else_18:
	jal x0, while_start_15
	jal x0, is_prime_return
	addi a0, x0, 1
while_end_17:
is_prime_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

main:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	jal ra, fibonacci
	addi a0, x0, 8
	jal ra, factorial
	jal ra, gcd
	addi a1, x0, 87
	addi a0, x0, 56
	blt t0, s1, while_end_23
	addi t0, x0, 10
while_start_21:
	bne t0, t0, else_24
	addi t0, x0, 0
	rem t0, s1, t0
	addi t0, x0, 2
	jal x0, endif_25
	mul t0, s1, s1
	bne t0, t0, else_26
	addi t0, x0, 0
	rem t0, s1, t0
	addi t0, x0, 3
else_24:
	jal x0, endif_27
	mul t0, t0, s1
	mul t0, s1, s1
else_26:
endif_27:
endif_25:
	jal x0, while_start_21
while_end_23:
	blt t0, s1, while_end_30
	addi t0, x0, 5
while_start_28:
	blt s1, s2, while_end_33
while_start_31:
	jal x0, while_start_31
while_end_33:
	jal x0, while_start_28
	beq a0, x0, else_34
	jal ra, is_prime
	addi a0, x0, 42
while_end_30:
	beq a0, x0, else_36
	jal ra, is_prime
	addi a0, x0, 56
	jal x0, endif_35
	beq a0, x0, else_38
	jal ra, is_prime
	addi a0, x0, 87
else_36:
	jal x0, endif_39
else_38:
endif_39:
	jal x0, endif_35
	beq a0, x0, else_40
	jal ra, is_prime
	addi a0, x0, 56
else_34:
	beq a0, x0, else_42
	jal ra, is_prime
	addi a0, x0, 87
	jal x0, endif_41
else_42:
	jal x0, endif_41
	beq a0, x0, else_44
	jal ra, is_prime
	addi a0, x0, 87
else_40:
	jal x0, endif_45
else_44:
endif_45:
endif_41:
endif_35:
	bge t1, t0, while_end_48
	addi t1, x0, 0
while_start_46:
	bne t1, t1, else_49
	addi t1, x0, 1
	rem t1, t0, t1
	addi t1, x0, 2
	jal x0, endif_50
else_49:
endif_50:
	jal x0, while_start_46
	jal x0, main_return
	addi a0, t0, 0
	rem t0, t0, t0
	addi t0, x0, 256
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	addi t0, t0, 87
	add t0, t0, t0
	addi t0, x0, -2
while_end_48:
main_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

