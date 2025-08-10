.globl main
.text
sum8:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	addi a0, t0, 0
	add t0, t0, a7
	add t0, t0, a6
	add t0, t0, a5
	add t0, t0, a4
	add t0, t0, a3
	add t0, t0, a2
	add t0, a0, a1
sum8_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

sum16:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	addi a0, t0, 0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, a7
	add t0, t0, a6
	add t0, t0, a5
	add t0, t0, a4
	add t0, t0, a3
	add t0, t0, a2
	add t0, a0, a1
	lw t0, 28(s0)
	lw t0, 24(s0)
	lw t0, 20(s0)
	lw t0, 16(s0)
	lw t0, 12(s0)
	lw t0, 8(s0)
	lw t0, 4(s0)
	lw t0, 0(s0)
sum16_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

sum32:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	addi a0, t0, 0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, a7
	add t0, t0, a6
	add t0, t0, a5
	add t0, t0, a4
	add t0, t0, a3
	add t0, t0, a2
	add t0, a0, a1
	lw t0, 92(s0)
	lw t0, 88(s0)
	lw t0, 84(s0)
	lw t0, 80(s0)
	lw t0, 76(s0)
	lw t0, 72(s0)
	lw t0, 68(s0)
	lw t0, 64(s0)
	lw t0, 60(s0)
	lw t0, 56(s0)
	lw t0, 52(s0)
	lw t0, 48(s0)
	lw t0, 44(s0)
	lw t0, 40(s0)
	lw t0, 36(s0)
	lw t0, 32(s0)
	lw t0, 28(s0)
	lw t0, 24(s0)
	lw t0, 20(s0)
	lw t0, 16(s0)
	lw t0, 12(s0)
	lw t0, 8(s0)
	lw t0, 4(s0)
	lw t0, 0(s0)
sum32_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

sum64:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	addi a0, t0, 0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, a7
	add t0, t0, a6
	add t0, t0, a5
	add t0, t0, a4
	add t0, t0, a3
	add t0, t0, a2
	add t0, a0, a1
	lw t0, 220(s0)
	lw t0, 216(s0)
	lw t0, 212(s0)
	lw t0, 208(s0)
	lw t0, 204(s0)
	lw t0, 200(s0)
	lw t0, 196(s0)
	lw t0, 192(s0)
	lw t0, 188(s0)
	lw t0, 184(s0)
	lw t0, 180(s0)
	lw t0, 176(s0)
	lw t0, 172(s0)
	lw t0, 168(s0)
	lw t0, 164(s0)
	lw t0, 160(s0)
	lw t0, 156(s0)
	lw t0, 152(s0)
	lw t0, 148(s0)
	lw t0, 144(s0)
	lw t0, 140(s0)
	lw t0, 136(s0)
	lw t0, 132(s0)
	lw t0, 128(s0)
	lw t0, 124(s0)
	lw t0, 120(s0)
	lw t0, 116(s0)
	lw t0, 112(s0)
	lw t0, 108(s0)
	lw t0, 104(s0)
	lw t0, 100(s0)
	lw t0, 96(s0)
	lw t0, 92(s0)
	lw t0, 88(s0)
	lw t0, 84(s0)
	lw t0, 80(s0)
	lw t0, 76(s0)
	lw t0, 72(s0)
	lw t0, 68(s0)
	lw t0, 64(s0)
	lw t0, 60(s0)
	lw t0, 56(s0)
	lw t0, 52(s0)
	lw t0, 48(s0)
	lw t0, 44(s0)
	lw t0, 40(s0)
	lw t0, 36(s0)
	lw t0, 32(s0)
	lw t0, 28(s0)
	lw t0, 24(s0)
	lw t0, 20(s0)
	lw t0, 16(s0)
	lw t0, 12(s0)
	lw t0, 8(s0)
	lw t0, 4(s0)
	lw t0, 0(s0)
sum64_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

main:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	addi a0, t0, 0
	rem t0, t0, t0
	addi t0, x0, 256
	add t0, t0, a0
	add t0, t0, a0
	add t0, a0, a0
	addi sp, sp, 224
	jal ra, sum64
	addi a7, x0, 8
	addi a6, x0, 7
	addi a5, x0, 6
	addi a4, x0, 5
	addi a3, x0, 4
	addi a2, x0, 3
	addi a1, x0, 2
	addi a0, x0, 1
	sw s1, 220(sp)
	sw s1, 216(sp)
	sw s1, 212(sp)
	sw s1, 208(sp)
	sw s1, 204(sp)
	sw s1, 200(sp)
	sw s1, 196(sp)
	sw s1, 192(sp)
	sw s1, 188(sp)
	sw s1, 184(sp)
	sw s1, 180(sp)
	sw s1, 176(sp)
	sw s1, 172(sp)
	sw s1, 168(sp)
	sw s1, 164(sp)
	sw s1, 160(sp)
	sw s1, 156(sp)
	sw s1, 152(sp)
	sw s1, 148(sp)
	sw s1, 144(sp)
	sw s1, 140(sp)
	sw s1, 136(sp)
	sw s1, 132(sp)
	sw s1, 128(sp)
	sw s1, 124(sp)
	sw s1, 120(sp)
	sw s1, 116(sp)
	sw s1, 112(sp)
	sw s1, 108(sp)
	sw s1, 104(sp)
	sw s1, 100(sp)
	sw s1, 96(sp)
	sw s1, 92(sp)
	sw s1, 88(sp)
	sw s1, 84(sp)
	sw s1, 80(sp)
	sw s1, 76(sp)
	sw s1, 72(sp)
	sw s1, 68(sp)
	sw s1, 64(sp)
	sw s1, 60(sp)
	sw s1, 56(sp)
	sw s1, 52(sp)
	sw s1, 48(sp)
	sw s1, 44(sp)
	sw s1, 40(sp)
	sw s1, 36(sp)
	sw s1, 32(sp)
	sw s1, 28(sp)
	sw s1, 24(sp)
	sw s1, 20(sp)
	sw s1, 16(sp)
	sw s1, 12(sp)
	sw s1, 8(sp)
	sw s1, 4(sp)
	sw s1, 0(sp)
	addi sp, sp, -224
	add t0, t0, a0
	add t0, a0, a0
	addi sp, sp, 96
	jal ra, sum32
	addi a7, x0, 8
	addi a6, x0, 7
	addi a5, x0, 6
	addi a4, x0, 5
	addi a3, x0, 4
	addi a2, x0, 3
	addi a1, x0, 2
	addi a0, x0, 1
	sw s1, 92(sp)
	sw s1, 88(sp)
	sw s1, 84(sp)
	sw s1, 80(sp)
	sw s1, 76(sp)
	sw s1, 72(sp)
	sw s1, 68(sp)
	sw s1, 64(sp)
	sw s1, 60(sp)
	sw s1, 56(sp)
	sw s1, 52(sp)
	sw s1, 48(sp)
	sw s1, 44(sp)
	sw s1, 40(sp)
	sw s1, 36(sp)
	sw s1, 32(sp)
	sw s1, 28(sp)
	sw s1, 24(sp)
	sw s1, 20(sp)
	sw s1, 16(sp)
	sw s1, 12(sp)
	sw s1, 8(sp)
	sw s1, 4(sp)
	sw s1, 0(sp)
	addi sp, sp, -96
	addi sp, sp, 32
	jal ra, sum16
	addi a7, x0, 8
	addi a6, x0, 7
	addi a5, x0, 6
	addi a4, x0, 5
	addi a3, x0, 4
	addi a2, x0, 3
	addi a1, x0, 2
	addi a0, x0, 1
	sw s1, 28(sp)
	sw s1, 24(sp)
	sw s1, 20(sp)
	sw s1, 16(sp)
	sw s1, 12(sp)
	sw s1, 8(sp)
	sw s1, 4(sp)
	sw s1, 0(sp)
	addi sp, sp, -32
	jal ra, sum8
	addi a7, x0, 4
	addi a6, x0, 7
	addi a5, x0, 3
	addi a4, x0, 5
	addi a3, x0, 2
	addi a2, x0, 3
	addi a1, x0, 1
	addi a0, x0, 1
main_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

