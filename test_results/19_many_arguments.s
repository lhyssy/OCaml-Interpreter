.globl main
.text
sum8:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi s0, a0, 0
	addi a0, t2, 0
	addi t2, t3, 0
	addi t3, t4, 0
	addi t4, s1, 0
	addi s1, s2, 0
	addi s2, s3, 0
	addi s3, s4, 0
	add s4, s0, a0
	add t0, s4, t2
	add t2, t0, t3
	add t3, t2, t4
	add t4, t3, s1
	add s1, t4, s2
	add s2, s1, s3
	addi a0, s2, 0
	jal x0, sum8_return

sum8_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

sum16:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi s0, a0, 0
	addi a0, t2, 0
	addi t2, t3, 0
	addi t3, t4, 0
	addi t4, s1, 0
	addi s1, s2, 0
	addi s2, s3, 0
	addi s3, s4, 0
	lw s4, 0(s0)
	lw s5, 4(s0)
	lw s6, 8(s0)
	lw s7, 12(s0)
	lw s8, 16(s0)
	lw s9, 20(s0)
	lw s10, 24(s0)
	lw t5, 28(s0)
	sw t5, -4(s0)
	add s11, s0, a0
	add t0, s11, t2
	add t2, t0, t3
	add t3, t2, t4
	add t4, t3, s1
	add s1, t4, s2
	add s2, s1, s3
	add s3, s2, s4
	add s4, s3, s5
	add s5, s4, s6
	add s6, s5, s7
	add s7, s6, s8
	add s8, s7, s9
	add s9, s8, s10
	lw t5, -4(s0)
	add s10, s9, t5
	addi a0, s10, 0
	jal x0, sum16_return

sum16_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

sum32:
	addi sp, sp, -80
	sw s0, 72(sp)
	addi s0, sp, 80
	addi s0, a0, 0
	addi a0, t2, 0
	addi t2, t3, 0
	addi t3, t4, 0
	addi t4, s1, 0
	addi s1, s2, 0
	addi s2, s3, 0
	addi s3, s4, 0
	lw s4, 0(s0)
	lw s5, 4(s0)
	lw s6, 8(s0)
	lw s7, 12(s0)
	lw s8, 16(s0)
	lw s9, 20(s0)
	lw s10, 24(s0)
	lw t5, 28(s0)
	sw t5, -48(s0)
	lw t5, 32(s0)
	sw t5, -24(s0)
	lw t5, 36(s0)
	sw t5, -60(s0)
	lw t5, 40(s0)
	sw t5, -68(s0)
	lw t5, 44(s0)
	sw t5, -64(s0)
	lw t5, 48(s0)
	sw t5, -4(s0)
	lw t5, 52(s0)
	sw t5, -16(s0)
	lw t5, 56(s0)
	sw t5, -36(s0)
	lw t5, 60(s0)
	sw t5, -28(s0)
	lw t5, 64(s0)
	sw t5, -20(s0)
	lw t5, 68(s0)
	sw t5, -56(s0)
	lw t5, 72(s0)
	sw t5, -12(s0)
	lw t5, 76(s0)
	sw t5, -44(s0)
	lw t5, 80(s0)
	sw t5, -32(s0)
	lw t5, 84(s0)
	sw t5, -8(s0)
	lw t5, 88(s0)
	sw t5, -52(s0)
	lw t5, 92(s0)
	sw t5, -40(s0)
	add s11, s0, a0
	add t0, s11, t2
	add t2, t0, t3
	add t3, t2, t4
	add t4, t3, s1
	add s1, t4, s2
	add s2, s1, s3
	add s3, s4, s5
	add s4, s3, s6
	add s6, s4, s7
	add s7, s6, s8
	add s8, s7, s9
	add s9, s8, s10
	lw t5, -48(s0)
	add s10, s9, t5
	lw t5, -24(s0)
	lw t6, -60(s0)
	add s9, t5, t6
	lw t5, -68(s0)
	add s8, s9, t5
	lw t5, -64(s0)
	add s9, s8, t5
	lw t5, -4(s0)
	add s8, s9, t5
	lw t5, -16(s0)
	add s9, s8, t5
	lw t5, -36(s0)
	add s8, s9, t5
	lw t5, -28(s0)
	add s9, s8, t5
	lw t5, -20(s0)
	lw t6, -56(s0)
	add s8, t5, t6
	lw t5, -12(s0)
	add s7, s8, t5
	lw t5, -44(s0)
	add s8, s7, t5
	lw t5, -32(s0)
	add s7, s8, t5
	lw t5, -8(s0)
	add s8, s7, t5
	lw t5, -52(s0)
	add s7, s8, t5
	lw t5, -40(s0)
	add s8, s7, t5
	add s7, s2, s10
	add s2, s7, s9
	add s9, s2, s8
	addi a0, s9, 0
	jal x0, sum32_return

sum32_return:
	lw s0, 72(sp)
	addi sp, sp, 80
	jalr x0, ra, 0

sum64:
	addi sp, sp, -208
	sw s0, 200(sp)
	addi s0, sp, 208
	addi s0, a0, 0
	addi a0, t2, 0
	addi t2, t3, 0
	addi t3, t4, 0
	addi t4, s1, 0
	addi s1, s2, 0
	addi s2, s3, 0
	addi s3, s4, 0
	lw s4, 0(s0)
	lw s5, 4(s0)
	lw s6, 8(s0)
	lw s7, 12(s0)
	lw s8, 16(s0)
	lw s9, 20(s0)
	lw s10, 24(s0)
	lw t5, 28(s0)
	sw t5, -168(s0)
	lw t5, 32(s0)
	sw t5, -144(s0)
	lw t5, 36(s0)
	sw t5, -104(s0)
	lw t5, 40(s0)
	sw t5, -196(s0)
	lw t5, 44(s0)
	sw t5, -112(s0)
	lw t5, 48(s0)
	sw t5, -4(s0)
	lw t5, 52(s0)
	sw t5, -136(s0)
	lw t5, 56(s0)
	sw t5, -60(s0)
	lw t5, 60(s0)
	sw t5, -148(s0)
	lw t5, 64(s0)
	sw t5, -140(s0)
	lw t5, 68(s0)
	sw t5, -188(s0)
	lw t5, 72(s0)
	sw t5, -124(s0)
	lw t5, 76(s0)
	sw t5, -84(s0)
	lw t5, 80(s0)
	sw t5, -56(s0)
	lw t5, 84(s0)
	sw t5, -12(s0)
	lw t5, 88(s0)
	sw t5, -176(s0)
	lw t5, 92(s0)
	sw t5, -160(s0)
	lw t5, 96(s0)
	sw t5, -108(s0)
	lw t5, 100(s0)
	sw t5, -40(s0)
	lw t5, 104(s0)
	sw t5, -68(s0)
	lw t5, 108(s0)
	sw t5, -16(s0)
	lw t5, 112(s0)
	sw t5, -132(s0)
	lw t5, 116(s0)
	sw t5, -36(s0)
	lw t5, 120(s0)
	sw t5, -80(s0)
	lw t5, 124(s0)
	sw t5, -20(s0)
	lw t5, 128(s0)
	sw t5, -100(s0)
	lw t5, 132(s0)
	sw t5, -32(s0)
	lw t5, 136(s0)
	sw t5, -28(s0)
	lw t5, 140(s0)
	sw t5, -8(s0)
	lw t5, 144(s0)
	sw t5, -44(s0)
	lw t5, 148(s0)
	sw t5, -156(s0)
	lw t5, 152(s0)
	sw t5, -24(s0)
	lw t5, 156(s0)
	sw t5, -48(s0)
	lw t5, 160(s0)
	sw t5, -64(s0)
	lw t5, 164(s0)
	sw t5, -184(s0)
	lw t5, 168(s0)
	sw t5, -192(s0)
	lw t5, 172(s0)
	sw t5, -116(s0)
	lw t5, 176(s0)
	sw t5, -180(s0)
	lw t5, 180(s0)
	sw t5, -52(s0)
	lw t5, 184(s0)
	sw t5, -152(s0)
	lw t5, 188(s0)
	sw t5, -96(s0)
	lw t5, 192(s0)
	sw t5, -164(s0)
	lw t5, 196(s0)
	sw t5, -128(s0)
	lw t5, 200(s0)
	sw t5, -72(s0)
	lw t5, 204(s0)
	sw t5, -88(s0)
	lw t5, 208(s0)
	sw t5, -92(s0)
	lw t5, 212(s0)
	sw t5, -76(s0)
	lw t5, 216(s0)
	sw t5, -172(s0)
	lw t5, 220(s0)
	sw t5, -120(s0)
	add s11, s0, a0
	add t0, s11, t2
	add t2, t0, t3
	add t3, t2, t4
	add t4, t3, s1
	add s1, t4, s2
	add s2, s1, s3
	add s3, s4, s5
	add s4, s3, s6
	add s6, s4, s7
	add s7, s6, s8
	add s8, s7, s9
	add s9, s8, s10
	lw t5, -168(s0)
	add s10, s9, t5
	lw t5, -144(s0)
	lw t6, -104(s0)
	add s9, t5, t6
	lw t5, -196(s0)
	add s8, s9, t5
	lw t5, -112(s0)
	add s9, s8, t5
	lw t5, -4(s0)
	add s8, s9, t5
	lw t5, -136(s0)
	add s9, s8, t5
	lw t5, -60(s0)
	add s8, s9, t5
	lw t5, -148(s0)
	add s9, s8, t5
	lw t5, -140(s0)
	lw t6, -188(s0)
	add s8, t5, t6
	lw t5, -124(s0)
	add s7, s8, t5
	lw t5, -84(s0)
	add s8, s7, t5
	lw t5, -56(s0)
	add s7, s8, t5
	lw t5, -12(s0)
	add s8, s7, t5
	lw t5, -176(s0)
	add s7, s8, t5
	lw t5, -160(s0)
	add s8, s7, t5
	lw t5, -108(s0)
	lw t6, -40(s0)
	add s7, t5, t6
	lw t5, -68(s0)
	add s6, s7, t5
	lw t5, -16(s0)
	add s7, s6, t5
	lw t5, -132(s0)
	add s6, s7, t5
	lw t5, -36(s0)
	add s7, s6, t5
	lw t5, -80(s0)
	add s6, s7, t5
	lw t5, -20(s0)
	add s7, s6, t5
	lw t5, -100(s0)
	lw t6, -32(s0)
	add s6, t5, t6
	lw t5, -28(s0)
	add s4, s6, t5
	lw t5, -8(s0)
	add s6, s4, t5
	lw t5, -44(s0)
	add s4, s6, t5
	lw t5, -156(s0)
	add s6, s4, t5
	lw t5, -24(s0)
	add s4, s6, t5
	lw t5, -48(s0)
	add s6, s4, t5
	lw t5, -64(s0)
	lw t6, -184(s0)
	add s4, t5, t6
	lw t5, -192(s0)
	add s3, s4, t5
	lw t5, -116(s0)
	add s4, s3, t5
	lw t5, -180(s0)
	add s3, s4, t5
	lw t5, -52(s0)
	add s4, s3, t5
	lw t5, -152(s0)
	add s3, s4, t5
	lw t5, -96(s0)
	add s4, s3, t5
	lw t5, -164(s0)
	lw t6, -128(s0)
	add s3, t5, t6
	lw t5, -72(s0)
	add s5, s3, t5
	lw t5, -88(s0)
	add s3, s5, t5
	lw t5, -92(s0)
	add s5, s3, t5
	lw t5, -76(s0)
	add s3, s5, t5
	lw t5, -172(s0)
	add s5, s3, t5
	lw t5, -120(s0)
	add s3, s5, t5
	add s5, s2, s10
	add s2, s5, s9
	add s9, s2, s8
	add s8, s9, s7
	add s7, s8, s6
	add s6, s7, s4
	add s4, s6, s3
	addi a0, s4, 0
	jal x0, sum64_return

sum64_return:
	lw s0, 200(sp)
	addi sp, sp, 208
	jalr x0, ra, 0

main:
	addi sp, sp, -304
	sw ra, 300(sp)
	sw s0, 296(sp)
	addi s0, sp, 304
	addi s0, x0, 1
	addi t5, x0, 1
	sw t5, -264(s0)
	addi t2, x0, 3
	addi t3, x0, 2
	addi t4, x0, 5
	addi s1, x0, 3
	addi s2, x0, 7
	addi s3, x0, 4
	addi t5, s0, 0
	sw t5, -264(s0)
	lw t5, -264(s0)
	addi t2, t5, 0
	addi t3, t2, 0
	addi t4, t3, 0
	addi s1, t4, 0
	addi s2, s1, 0
	addi s3, s2, 0
	addi t5, s3, 0
	sw t5, -268(s0)
	jal ra, sum8
	sw t5, -264(s0)
	lw t5, -264(s0)
	sw t5, -268(s0)
	addi s3, x0, 1
	addi s1, x0, 2
	addi t4, x0, 3
	addi t3, x0, 4
	addi t2, x0, 5
	addi t0, x0, 6
	addi s4, x0, 7
	addi t5, x0, 8
	sw t5, -256(s0)
	addi s6, x0, 1
	addi s7, x0, 2
	addi s8, x0, 3
	addi s9, x0, 4
	addi s10, x0, 13
	lw t5, -268(s0)
	add s11, t5, s10
	addi s10, x0, 14
	lw t5, -268(s0)
	add s2, t5, s10
	addi s10, x0, 15
	lw t5, -268(s0)
	add t1, t5, s10
	addi s10, x0, 16
	lw t5, -268(s0)
	add s5, t5, s10
	addi sp, sp, -32
	sw s5, 0(sp)
	sw t1, 4(sp)
	sw s2, 8(sp)
	sw s11, 12(sp)
	sw s9, 16(sp)
	sw s8, 20(sp)
	sw s7, 24(sp)
	sw s6, 28(sp)
	addi t5, s3, 0
	sw t5, -264(s0)
	addi t2, s1, 0
	addi t3, t4, 0
	addi t4, t3, 0
	addi s1, t2, 0
	addi s2, t0, 0
	addi s3, s4, 0
	lw t5, -256(s0)
	sw t5, -268(s0)
	jal ra, sum16
	sw t5, -264(s0)
	lw t5, -264(s0)
	sw t5, -12(s0)
	addi sp, sp, 32
	addi t5, x0, 1
	sw t5, -172(s0)
	addi t5, x0, 2
	sw t5, -144(s0)
	addi t5, x0, 3
	sw t5, -228(s0)
	addi t5, x0, 4
	sw t5, -200(s0)
	addi t5, x0, 5
	sw t5, -216(s0)
	addi t5, x0, 6
	sw t5, -16(s0)
	addi t5, x0, 7
	sw t5, -252(s0)
	addi t5, x0, 8
	sw t5, -40(s0)
	addi t5, x0, 9
	sw t5, -76(s0)
	addi t5, x0, 10
	sw t5, -184(s0)
	addi t5, x0, 11
	sw t5, -88(s0)
	addi t5, x0, 12
	sw t5, -36(s0)
	addi t5, x0, 13
	sw t5, -28(s0)
	addi t5, x0, 14
	sw t5, -8(s0)
	addi t5, x0, 15
	sw t5, -208(s0)
	addi t5, x0, 16
	sw t5, -128(s0)
	addi s7, x0, 17
	addi s6, x0, 18
	addi s3, x0, 19
	addi s1, x0, 20
	addi t4, x0, 21
	addi t3, x0, 22
	addi t2, x0, 23
	addi t0, x0, 24
	addi s8, x0, 25
	addi s9, x0, 26
	addi s11, x0, 27
	addi s2, x0, 28
	addi t1, x0, 29
	addi s5, x0, 30
	addi s10, x0, 31
	addi s4, x0, 32
	addi sp, sp, -96
	sw s4, 0(sp)
	sw s10, 4(sp)
	sw s5, 8(sp)
	sw t1, 12(sp)
	sw s2, 16(sp)
	sw s11, 20(sp)
	sw s9, 24(sp)
	sw s8, 28(sp)
	sw t0, 32(sp)
	sw t2, 36(sp)
	sw t3, 40(sp)
	sw t4, 44(sp)
	sw s1, 48(sp)
	sw s3, 52(sp)
	sw s6, 56(sp)
	sw s7, 60(sp)
	lw t5, -128(s0)
	sw t5, 64(sp)
	lw t5, -208(s0)
	sw t5, 68(sp)
	lw t5, -8(s0)
	sw t5, 72(sp)
	lw t5, -28(s0)
	sw t5, 76(sp)
	lw t5, -36(s0)
	sw t5, 80(sp)
	lw t5, -88(s0)
	sw t5, 84(sp)
	lw t5, -184(s0)
	sw t5, 88(sp)
	lw t5, -76(s0)
	sw t5, 92(sp)
	lw t5, -172(s0)
	sw t5, -264(s0)
	lw t5, -144(s0)
	addi t2, t5, 0
	lw t5, -228(s0)
	addi t3, t5, 0
	lw t5, -200(s0)
	addi t4, t5, 0
	lw t5, -216(s0)
	addi s1, t5, 0
	lw t5, -16(s0)
	addi s2, t5, 0
	lw t5, -252(s0)
	addi s3, t5, 0
	lw t5, -40(s0)
	sw t5, -268(s0)
	jal ra, sum32
	sw t5, -264(s0)
	lw t5, -264(s0)
	sw t5, -168(s0)
	addi sp, sp, 96
	addi t5, x0, 1
	sw t5, -232(s0)
	addi t5, x0, 2
	sw t5, -196(s0)
	addi t5, x0, 3
	sw t5, -212(s0)
	addi t5, x0, 4
	sw t5, -24(s0)
	addi t5, x0, 5
	sw t5, -84(s0)
	addi t5, x0, 6
	sw t5, -248(s0)
	addi t5, x0, 7
	sw t5, -136(s0)
	addi t5, x0, 8
	sw t5, -116(s0)
	addi t5, x0, 9
	sw t5, -60(s0)
	addi t5, x0, 10
	sw t5, -204(s0)
	addi t5, x0, 11
	sw t5, -56(s0)
	addi t5, x0, 12
	sw t5, -72(s0)
	addi t5, x0, 13
	sw t5, -64(s0)
	addi t5, x0, 14
	sw t5, -104(s0)
	addi t5, x0, 15
	sw t5, -260(s0)
	addi t5, x0, 16
	sw t5, -124(s0)
	addi t5, x0, 17
	sw t5, -148(s0)
	addi t5, x0, 18
	sw t5, -284(s0)
	addi t5, x0, 19
	sw t5, -120(s0)
	addi t5, x0, 20
	sw t5, -156(s0)
	addi t5, x0, 21
	sw t5, -20(s0)
	addi t5, x0, 22
	sw t5, -220(s0)
	addi t5, x0, 23
	sw t5, -244(s0)
	addi t5, x0, 24
	sw t5, -4(s0)
	addi t5, x0, 25
	sw t5, -224(s0)
	addi t5, x0, 26
	sw t5, -180(s0)
	addi t5, x0, 27
	sw t5, -152(s0)
	addi t5, x0, 28
	sw t5, -92(s0)
	addi t5, x0, 29
	sw t5, -52(s0)
	addi t5, x0, 30
	sw t5, -188(s0)
	addi t5, x0, 31
	sw t5, -192(s0)
	addi t5, x0, 32
	sw t5, -112(s0)
	addi t5, x0, 2
	sw t5, -32(s0)
	addi t5, x0, 4
	sw t5, -132(s0)
	addi t5, x0, 6
	sw t5, -48(s0)
	addi t5, x0, 8
	sw t5, -100(s0)
	addi t5, x0, 10
	sw t5, -44(s0)
	addi t5, x0, 12
	sw t5, -240(s0)
	addi t5, x0, 14
	sw t5, -140(s0)
	addi t5, x0, 16
	sw t5, -272(s0)
	addi t5, x0, 81
	sw t5, -276(s0)
	addi t5, x0, 100
	sw t5, -280(s0)
	addi t5, x0, 121
	sw t5, -236(s0)
	addi t5, x0, 144
	sw t5, -164(s0)
	addi t5, x0, 169
	sw t5, -96(s0)
	addi t5, x0, 196
	sw t5, -176(s0)
	addi t5, x0, 225
	sw t5, -108(s0)
	addi t5, x0, 256
	sw t5, -80(s0)
	addi t5, x0, 18
	sw t5, -160(s0)
	addi t5, x0, 20
	sw t5, -68(s0)
	addi t2, x0, 22
	addi t3, x0, 24
	addi t4, x0, 26
	addi s1, x0, 28
	addi s3, x0, 30
	addi s6, x0, 32
	addi s9, x0, 9
	lw t5, -168(s0)
	add s11, s9, t5
	addi s9, x0, 20
	lw t5, -168(s0)
	add s2, s9, t5
	addi s9, x0, 33
	lw t5, -168(s0)
	add t1, s9, t5
	addi s9, x0, 48
	lw t5, -168(s0)
	add s5, s9, t5
	addi s9, x0, 65
	lw t5, -168(s0)
	add s10, s9, t5
	addi s9, x0, 84
	lw t5, -168(s0)
	add s4, s9, t5
	addi s9, x0, 105
	lw t5, -168(s0)
	add s7, s9, t5
	addi s9, x0, 128
	lw t5, -268(s0)
	lw t6, -12(s0)
	add s8, t5, t6
	lw t5, -168(s0)
	add t0, s8, t5
	add s8, s9, t0
	addi sp, sp, -224
	sw s8, 0(sp)
	sw s7, 4(sp)
	sw s4, 8(sp)
	sw s10, 12(sp)
	sw s5, 16(sp)
	sw t1, 20(sp)
	sw s2, 24(sp)
	sw s11, 28(sp)
	sw s6, 32(sp)
	sw s3, 36(sp)
	sw s1, 40(sp)
	sw t4, 44(sp)
	sw t3, 48(sp)
	sw t2, 52(sp)
	lw t5, -68(s0)
	sw t5, 56(sp)
	lw t5, -160(s0)
	sw t5, 60(sp)
	lw t5, -80(s0)
	sw t5, 64(sp)
	lw t5, -108(s0)
	sw t5, 68(sp)
	lw t5, -176(s0)
	sw t5, 72(sp)
	lw t5, -96(s0)
	sw t5, 76(sp)
	lw t5, -164(s0)
	sw t5, 80(sp)
	lw t5, -236(s0)
	sw t5, 84(sp)
	lw t5, -280(s0)
	sw t5, 88(sp)
	lw t5, -276(s0)
	sw t5, 92(sp)
	lw t5, -272(s0)
	sw t5, 96(sp)
	lw t5, -140(s0)
	sw t5, 100(sp)
	lw t5, -240(s0)
	sw t5, 104(sp)
	lw t5, -44(s0)
	sw t5, 108(sp)
	lw t5, -100(s0)
	sw t5, 112(sp)
	lw t5, -48(s0)
	sw t5, 116(sp)
	lw t5, -132(s0)
	sw t5, 120(sp)
	lw t5, -32(s0)
	sw t5, 124(sp)
	lw t5, -112(s0)
	sw t5, 128(sp)
	lw t5, -192(s0)
	sw t5, 132(sp)
	lw t5, -188(s0)
	sw t5, 136(sp)
	lw t5, -52(s0)
	sw t5, 140(sp)
	lw t5, -92(s0)
	sw t5, 144(sp)
	lw t5, -152(s0)
	sw t5, 148(sp)
	lw t5, -180(s0)
	sw t5, 152(sp)
	lw t5, -224(s0)
	sw t5, 156(sp)
	lw t5, -4(s0)
	sw t5, 160(sp)
	lw t5, -244(s0)
	sw t5, 164(sp)
	lw t5, -220(s0)
	sw t5, 168(sp)
	lw t5, -20(s0)
	sw t5, 172(sp)
	lw t5, -156(s0)
	sw t5, 176(sp)
	lw t5, -120(s0)
	sw t5, 180(sp)
	lw t5, -284(s0)
	sw t5, 184(sp)
	lw t5, -148(s0)
	sw t5, 188(sp)
	lw t5, -124(s0)
	sw t5, 192(sp)
	lw t5, -260(s0)
	sw t5, 196(sp)
	lw t5, -104(s0)
	sw t5, 200(sp)
	lw t5, -64(s0)
	sw t5, 204(sp)
	lw t5, -72(s0)
	sw t5, 208(sp)
	lw t5, -56(s0)
	sw t5, 212(sp)
	lw t5, -204(s0)
	sw t5, 216(sp)
	lw t5, -60(s0)
	sw t5, 220(sp)
	lw t5, -232(s0)
	sw t5, -264(s0)
	lw t5, -196(s0)
	addi t2, t5, 0
	lw t5, -212(s0)
	addi t3, t5, 0
	lw t5, -24(s0)
	addi t4, t5, 0
	lw t5, -84(s0)
	addi s1, t5, 0
	lw t5, -248(s0)
	addi s2, t5, 0
	lw t5, -136(s0)
	addi s3, t5, 0
	lw t5, -116(s0)
	sw t5, -268(s0)
	jal ra, sum64
	sw t5, -264(s0)
	lw t5, -264(s0)
	addi t2, t5, 0
	addi sp, sp, 224
	lw t5, -268(s0)
	lw t6, -12(s0)
	add t3, t5, t6
	lw t5, -168(s0)
	add t4, t3, t5
	add t3, t4, t2
	addi t2, x0, 256
	rem t4, t3, t2
	addi t5, t4, 0
	sw t5, -264(s0)
	jal x0, main_return

main_return:
	lw ra, 300(sp)
	lw s0, 296(sp)
	addi sp, sp, 304
	jalr x0, ra, 0

