.globl main
.text
main:
	addi sp, sp, -64
	sw ra, 60(sp)
	sw s0, 56(sp)
	addi s0, sp, 64
main_return:
	j main_return
	mv a0, t0
	li t0, 90
	sw t1, -52(s0)
	# Declare m
	li t1, 30
	sw t1, -48(s0)
	# Declare l
	li t1, 0
	sw t1, -44(s0)
	# Declare k
	li t1, 30
	sw t1, -40(s0)
	# Declare j
	li t1, 30
	sw t1, -36(s0)
	# Declare i
	li t1, 3
	sw t1, -32(s0)
	# Declare h
	li t1, 7
	sw t1, -28(s0)
	# Declare g
	li t1, 15
	sw t1, -24(s0)
	# Declare f
	li t1, 240
	sw t1, -20(s0)
	# Declare e
	li t1, 120
	sw t1, -16(s0)
	# Declare d
	li t1, 60
	sw t1, -12(s0)
	# Declare c
	li t1, 25
	sw a0, -8(s0)
	# Declare b
	li a0, 20
	sw s0, -4(s0)
	# Declare a
	li s0, 30

main_return:
	lw ra, 60(sp)
	lw s0, 56(sp)
	addi sp, sp, 64
	ret

