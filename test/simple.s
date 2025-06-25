.globl main
.text
main:
	addi sp, sp, -64
	sw ra, 56(sp)
	sw fp, 52(sp)
	addi fp, sp, 64
main_return:
endif_1:
	j main_return
	mv a0, s1
	li s1, 0
else_0:
	j endif_1
	j main_return
	mv a0, s0
	lw s0, -12(fp)
	# Load z
	beqz t6, else_0
	sgt t6, t4, t5
	li t5, 25
	lw t4, -12(fp)
	# Load z
	sw t3, -12(fp)
	# Declare z
	add t3, t1, t2
	lw t2, -8(fp)
	# Load y
	lw t1, -4(fp)
	# Load x
	sw t0, -8(fp)
	# Declare y
	li t0, 20
	sw fp, -4(fp)
	# Declare x
	li fp, 10
	lw ra, 56(sp)
	lw fp, 52(sp)
	addi sp, sp, 64
	ret

test:
	addi sp, sp, -64
	sw ra, 56(sp)
	sw fp, 52(sp)
	addi fp, sp, 64
test_return:
	j test_return
	mv a0, fp
	li fp, 0
	lw ra, 56(sp)
	lw fp, 52(sp)
	addi sp, sp, 64
	ret

