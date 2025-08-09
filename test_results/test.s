.globl main
.text
subs:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, a1, 0
	sub t0, t0, t1
	addi a0, t0, 0
	jal x0, subs_return
subs_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

main:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	addi s1, x0, 114
	addi s2, x0, 514
	addi a0, s1, 0
	addi a1, s2, 0
	jal ra, subs
	addi t0, a0, 0
	addi a0, t0, 0
	jal x0, main_return
main_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

