.globl main
.text
echo:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, x0, 100
	mul t0, t0, t1
	addi a0, t0, 0
	jal x0, echo_return
echo_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

testRet:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	addi t0, x0, 20
	addi a0, x0, 20
	jal x0, testRet_return
testRet_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

testRet2:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	sw s1, 4(sp)
	addi s0, sp, 16
	addi s1, x0, 20
	addi a0, s1, 0
	jal ra, echo
	addi t0, a0, 0
	addi a0, t0, 0
	jal x0, testRet2_return
testRet2_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	lw s1, 4(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

main:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	addi s1, x0, 20
	addi a0, s1, 0
	jal ra, echo
	addi t0, a0, 0
	addi a0, t0, 0
	jal x0, main_return
main_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

