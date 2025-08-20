.globl main
.text
echo:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	jal x0, echo_return
echo_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

test0_1:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	addi a0, x0, 3
	jal x0, test0_1_return
test0_1_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

test0_2:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	addi a0, x0, 18
	jal x0, test0_2_return
test0_2_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

test0_3:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	sw s1, 4(sp)
	addi s0, sp, 16
	addi s1, x0, 10
	addi a0, s1, 0
	jal ra, echo
	addi t0, a0, 0
	addi a0, t0, 0
	jal x0, test0_3_return
test0_3_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	lw s1, 4(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

test0_4:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	addi a0, x0, 10
	jal x0, test0_4_return
test0_4_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

test1_1:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	sw s1, 4(sp)
	addi s0, sp, 16
	addi t0, x0, 120
	addi s1, x0, 114
	addi sp, sp, -4
	sw t0, 0(sp)
	addi a0, s1, 0
	jal ra, echo
	lw t0, 0(sp)
	addi sp, sp, 4
	addi t1, a0, 0
	beq t1, x0, else_0
	addi t0, x0, -120
	jal x0, endif_1
else_0:
endif_1:
	addi a0, t0, 0
	jal x0, test1_1_return
test1_1_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	lw s1, 4(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

test1_2:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	sw s1, 4(sp)
	addi s0, sp, 16
	addi t0, x0, 0
	addi s1, x0, 114
	addi sp, sp, -4
	sw t0, 0(sp)
	addi a0, s1, 0
	jal ra, echo
	lw t0, 0(sp)
	addi sp, sp, 4
	addi t1, a0, 0
	beq t1, x0, else_2
	addi t0, x0, 114
	jal x0, endif_3
else_2:
	addi t0, x0, 514
endif_3:
	addi a0, t0, 0
	jal x0, test1_2_return
test1_2_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	lw s1, 4(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

test1_3:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	sw s1, 4(sp)
	addi s0, sp, 16
	addi t0, x0, 1
	addi t1, x0, 2
	addi t2, x0, 3
	addi s1, x0, 114
	addi sp, sp, -12
	sw t0, 0(sp)
	sw t1, 4(sp)
	sw t2, 8(sp)
	addi a0, s1, 0
	jal ra, echo
	lw t0, 0(sp)
	lw t1, 4(sp)
	lw t2, 8(sp)
	addi sp, sp, 12
	addi s1, a0, 0
	beq s1, x0, else_4
	addi t0, x0, 114
	addi t2, x0, 514
	jal x0, endif_5
else_4:
	addi s1, x0, 514
	addi sp, sp, -12
	sw t0, 0(sp)
	sw t1, 4(sp)
	sw t2, 8(sp)
	addi a0, s1, 0
	jal ra, echo
	lw t0, 0(sp)
	lw t1, 4(sp)
	lw t2, 8(sp)
	addi sp, sp, 12
	addi t3, a0, 0
	beq t3, x0, else_6
	addi t0, x0, 514
	addi t1, x0, 114
	jal x0, endif_7
else_6:
	addi t2, x0, 114
	addi t1, x0, 514
endif_7:
endif_5:
	add t0, t0, t1
	add t2, t0, t2
	addi a0, t2, 0
	jal x0, test1_3_return
test1_3_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	lw s1, 4(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

test1_4_1:
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
	jal x0, test1_4_1_return
test1_4_1_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	lw s1, 4(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

test1_4_2:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	addi a0, x0, 20
	jal x0, test1_4_2_return
test1_4_2_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

test1_4_3:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	addi a0, x0, 10
	jal x0, test1_4_3_return
test1_4_3_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

test2_1:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	addi a0, x0, 55
	jal x0, test2_1_return
test2_1_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

main:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	addi a0, x0, 0
	jal x0, main_return
main_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

