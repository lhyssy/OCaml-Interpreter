.globl main
.text
sum8:
	addi sp, sp, -16
	sw s0, 12(sp)
	sw s1, 8(sp)
	sw s2, 4(sp)
	sw s3, 0(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, a1, 0
	addi t2, a2, 0
	addi t3, a3, 0
	addi t4, a4, 0
	addi s1, a5, 0
	addi s2, a6, 0
	addi s3, a7, 0
	add t0, t0, t1
	add t2, t0, t2
	add t3, t2, t3
	add t4, t3, t4
	add t4, t4, s1
	add t4, t4, s2
	add t4, t4, s3
	addi a0, t4, 0
	jal x0, sum8_return
sum8_return:
	lw s0, 12(sp)
	lw s1, 8(sp)
	lw s2, 4(sp)
	lw s3, 0(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

sum16:
	addi sp, sp, -48
	sw s0, 44(sp)
	sw s1, 40(sp)
	sw s10, 36(sp)
	sw s11, 32(sp)
	sw s2, 28(sp)
	sw s3, 24(sp)
	sw s4, 20(sp)
	sw s5, 16(sp)
	sw s6, 12(sp)
	sw s7, 8(sp)
	sw s8, 4(sp)
	sw s9, 0(sp)
	addi s0, sp, 48
	addi t0, a0, 0
	addi t1, a1, 0
	addi t2, a2, 0
	addi t3, a3, 0
	addi t4, a4, 0
	addi s1, a5, 0
	addi s2, a6, 0
	addi s3, a7, 0
	lw s4, 0(s0)
	lw s5, 4(s0)
	lw s6, 8(s0)
	lw s7, 12(s0)
	lw s8, 16(s0)
	lw s9, 20(s0)
	lw s10, 24(s0)
	lw s11, 28(s0)
	add t0, t0, t1
	add t2, t0, t2
	add t3, t2, t3
	add t4, t3, t4
	add t4, t4, s1
	add t4, t4, s2
	add t4, t4, s3
	add t4, t4, s4
	add t4, t4, s5
	add t4, t4, s6
	add t4, t4, s7
	add t4, t4, s8
	add t4, t4, s9
	add t4, t4, s10
	add t4, t4, s11
	addi a0, t4, 0
	jal x0, sum16_return
sum16_return:
	lw s0, 44(sp)
	lw s1, 40(sp)
	lw s10, 36(sp)
	lw s11, 32(sp)
	lw s2, 28(sp)
	lw s3, 24(sp)
	lw s4, 20(sp)
	lw s5, 16(sp)
	lw s6, 12(sp)
	lw s7, 8(sp)
	lw s8, 4(sp)
	lw s9, 0(sp)
	addi sp, sp, 48
	jalr x0, ra, 0

sum32:
	addi sp, sp, -112
	sw s0, 108(sp)
	sw s1, 104(sp)
	sw s10, 100(sp)
	sw s11, 96(sp)
	sw s2, 92(sp)
	sw s3, 88(sp)
	sw s4, 84(sp)
	sw s5, 80(sp)
	sw s6, 76(sp)
	sw s7, 72(sp)
	sw s8, 68(sp)
	sw s9, 64(sp)
	addi s0, sp, 112
	addi t0, a0, 0
	addi t1, a1, 0
	addi t2, a2, 0
	addi t3, a3, 0
	addi t4, a4, 0
	addi s1, a5, 0
	addi s2, a6, 0
	addi s3, a7, 0
	lw s4, 0(s0)
	lw s5, 4(s0)
	lw s6, 8(s0)
	lw s7, 12(s0)
	lw s8, 16(s0)
	lw s9, 20(s0)
	lw s10, 24(s0)
	lw s11, 28(s0)
	lw t5, 32(s0)
	sw t5, -112(s0)
	lw t5, 36(s0)
	sw t5, -84(s0)
	lw t5, 40(s0)
	sw t5, -100(s0)
	lw t5, 44(s0)
	sw t5, -56(s0)
	lw t5, 48(s0)
	sw t5, -76(s0)
	lw t5, 52(s0)
	sw t5, -80(s0)
	lw t5, 56(s0)
	sw t5, -104(s0)
	lw t5, 60(s0)
	sw t5, -60(s0)
	lw t5, 64(s0)
	sw t5, -108(s0)
	lw t5, 68(s0)
	sw t5, -72(s0)
	lw t5, 72(s0)
	sw t5, -68(s0)
	lw t5, 76(s0)
	sw t5, -52(s0)
	lw t5, 80(s0)
	sw t5, -88(s0)
	lw t5, 84(s0)
	sw t5, -96(s0)
	lw t5, 88(s0)
	sw t5, -64(s0)
	lw t5, 92(s0)
	sw t5, -92(s0)
	add t0, t0, t1
	add t2, t0, t2
	add t3, t2, t3
	add t4, t3, t4
	add t4, t4, s1
	add t4, t4, s2
	add t4, t4, s3
	add t3, s4, s5
	add t3, t3, s6
	add t3, t3, s7
	add t3, t3, s8
	add t3, t3, s9
	add t3, t3, s10
	add t3, t3, s11
	lw t5, -112(s0)
	lw t6, -84(s0)
	add t2, t5, t6
	lw t5, -100(s0)
	add t2, t2, t5
	lw t5, -56(s0)
	add t2, t2, t5
	lw t5, -76(s0)
	add t2, t2, t5
	lw t5, -80(s0)
	add t2, t2, t5
	lw t5, -104(s0)
	add t2, t2, t5
	lw t5, -60(s0)
	add t2, t2, t5
	lw t5, -108(s0)
	lw t6, -72(s0)
	add t0, t5, t6
	lw t5, -68(s0)
	add t0, t0, t5
	lw t5, -52(s0)
	add t0, t0, t5
	lw t5, -88(s0)
	add t0, t0, t5
	lw t5, -96(s0)
	add t0, t0, t5
	lw t5, -64(s0)
	add t0, t0, t5
	lw t5, -92(s0)
	add t0, t0, t5
	add t4, t4, t3
	add t2, t4, t2
	add t0, t2, t0
	addi a0, t0, 0
	jal x0, sum32_return
sum32_return:
	lw s0, 108(sp)
	lw s1, 104(sp)
	lw s10, 100(sp)
	lw s11, 96(sp)
	lw s2, 92(sp)
	lw s3, 88(sp)
	lw s4, 84(sp)
	lw s5, 80(sp)
	lw s6, 76(sp)
	lw s7, 72(sp)
	lw s8, 68(sp)
	lw s9, 64(sp)
	addi sp, sp, 112
	jalr x0, ra, 0

sum64:
	addi sp, sp, -240
	sw s0, 236(sp)
	sw s1, 232(sp)
	sw s10, 228(sp)
	sw s11, 224(sp)
	sw s2, 220(sp)
	sw s3, 216(sp)
	sw s4, 212(sp)
	sw s5, 208(sp)
	sw s6, 204(sp)
	sw s7, 200(sp)
	sw s8, 196(sp)
	sw s9, 192(sp)
	addi s0, sp, 240
	addi t0, a0, 0
	addi t1, a1, 0
	addi t2, a2, 0
	addi t3, a3, 0
	addi t4, a4, 0
	addi s1, a5, 0
	addi s2, a6, 0
	addi s3, a7, 0
	lw s4, 0(s0)
	lw s5, 4(s0)
	lw s6, 8(s0)
	lw s7, 12(s0)
	lw s8, 16(s0)
	lw s9, 20(s0)
	lw s10, 24(s0)
	lw s11, 28(s0)
	lw t5, 32(s0)
	sw t5, -168(s0)
	lw t5, 36(s0)
	sw t5, -88(s0)
	lw t5, 40(s0)
	sw t5, -132(s0)
	lw t5, 44(s0)
	sw t5, -56(s0)
	lw t5, 48(s0)
	sw t5, -192(s0)
	lw t5, 52(s0)
	sw t5, -84(s0)
	lw t5, 56(s0)
	sw t5, -144(s0)
	lw t5, 60(s0)
	sw t5, -64(s0)
	lw t5, 64(s0)
	sw t5, -164(s0)
	lw t5, 68(s0)
	sw t5, -76(s0)
	lw t5, 72(s0)
	sw t5, -72(s0)
	lw t5, 76(s0)
	sw t5, -52(s0)
	lw t5, 80(s0)
	sw t5, -96(s0)
	lw t5, 84(s0)
	sw t5, -212(s0)
	lw t5, 88(s0)
	sw t5, -68(s0)
	lw t5, 92(s0)
	sw t5, -104(s0)
	lw t5, 96(s0)
	sw t5, -120(s0)
	lw t5, 100(s0)
	sw t5, -236(s0)
	lw t5, 104(s0)
	sw t5, -240(s0)
	lw t5, 108(s0)
	sw t5, -172(s0)
	lw t5, 112(s0)
	sw t5, -232(s0)
	lw t5, 116(s0)
	sw t5, -112(s0)
	lw t5, 120(s0)
	sw t5, -208(s0)
	lw t5, 124(s0)
	sw t5, -156(s0)
	lw t5, 128(s0)
	sw t5, -224(s0)
	lw t5, 132(s0)
	sw t5, -184(s0)
	lw t5, 136(s0)
	sw t5, -136(s0)
	lw t5, 140(s0)
	sw t5, -148(s0)
	lw t5, 144(s0)
	sw t5, -152(s0)
	lw t5, 148(s0)
	sw t5, -140(s0)
	lw t5, 152(s0)
	sw t5, -228(s0)
	lw t5, 156(s0)
	sw t5, -176(s0)
	lw t5, 160(s0)
	sw t5, -80(s0)
	lw t5, 164(s0)
	sw t5, -108(s0)
	lw t5, 168(s0)
	sw t5, -60(s0)
	lw t5, 172(s0)
	sw t5, -160(s0)
	lw t5, 176(s0)
	sw t5, -180(s0)
	lw t5, 180(s0)
	sw t5, -216(s0)
	lw t5, 184(s0)
	sw t5, -196(s0)
	lw t5, 188(s0)
	sw t5, -116(s0)
	lw t5, 192(s0)
	sw t5, -92(s0)
	lw t5, 196(s0)
	sw t5, -100(s0)
	lw t5, 200(s0)
	sw t5, -128(s0)
	lw t5, 204(s0)
	sw t5, -124(s0)
	lw t5, 208(s0)
	sw t5, -188(s0)
	lw t5, 212(s0)
	sw t5, -200(s0)
	lw t5, 216(s0)
	sw t5, -204(s0)
	lw t5, 220(s0)
	sw t5, -220(s0)
	add t0, t0, t1
	add t2, t0, t2
	add t3, t2, t3
	add t4, t3, t4
	add t4, t4, s1
	add t4, t4, s2
	add t4, t4, s3
	add t3, s4, s5
	add t3, t3, s6
	add t3, t3, s7
	add t3, t3, s8
	add t3, t3, s9
	add t3, t3, s10
	add t3, t3, s11
	lw t5, -168(s0)
	lw t6, -88(s0)
	add t2, t5, t6
	lw t5, -132(s0)
	add t2, t2, t5
	lw t5, -56(s0)
	add t2, t2, t5
	lw t5, -192(s0)
	add t2, t2, t5
	lw t5, -84(s0)
	add t2, t2, t5
	lw t5, -144(s0)
	add t2, t2, t5
	lw t5, -64(s0)
	add t2, t2, t5
	lw t5, -164(s0)
	lw t6, -76(s0)
	add t0, t5, t6
	lw t5, -72(s0)
	add t0, t0, t5
	lw t5, -52(s0)
	add t0, t0, t5
	lw t5, -96(s0)
	add t0, t0, t5
	lw t5, -212(s0)
	add t0, t0, t5
	lw t5, -68(s0)
	add t0, t0, t5
	lw t5, -104(s0)
	add t0, t0, t5
	lw t5, -120(s0)
	lw t6, -236(s0)
	add t1, t5, t6
	lw t5, -240(s0)
	add t1, t1, t5
	lw t5, -172(s0)
	add t1, t1, t5
	lw t5, -232(s0)
	add t1, t1, t5
	lw t5, -112(s0)
	add t1, t1, t5
	lw t5, -208(s0)
	add t1, t1, t5
	lw t5, -156(s0)
	add t1, t1, t5
	lw t5, -224(s0)
	lw t6, -184(s0)
	add s11, t5, t6
	lw t5, -136(s0)
	add s11, s11, t5
	lw t5, -148(s0)
	add s11, s11, t5
	lw t5, -152(s0)
	add s11, s11, t5
	lw t5, -140(s0)
	add s11, s11, t5
	lw t5, -228(s0)
	add s11, s11, t5
	lw t5, -176(s0)
	add s11, s11, t5
	lw t5, -80(s0)
	lw t6, -108(s0)
	add s10, t5, t6
	lw t5, -60(s0)
	add s10, s10, t5
	lw t5, -160(s0)
	add s10, s10, t5
	lw t5, -180(s0)
	add s10, s10, t5
	lw t5, -216(s0)
	add s10, s10, t5
	lw t5, -196(s0)
	add s10, s10, t5
	lw t5, -116(s0)
	add s10, s10, t5
	lw t5, -92(s0)
	lw t6, -100(s0)
	add s9, t5, t6
	lw t5, -128(s0)
	add s9, s9, t5
	lw t5, -124(s0)
	add s9, s9, t5
	lw t5, -188(s0)
	add s9, s9, t5
	lw t5, -200(s0)
	add s9, s9, t5
	lw t5, -204(s0)
	add s9, s9, t5
	lw t5, -220(s0)
	add s9, s9, t5
	add t4, t4, t3
	add t2, t4, t2
	add t0, t2, t0
	add t1, t0, t1
	add t1, t1, s11
	add t1, t1, s10
	add t1, t1, s9
	addi a0, t1, 0
	jal x0, sum64_return
sum64_return:
	lw s0, 236(sp)
	lw s1, 232(sp)
	lw s10, 228(sp)
	lw s11, 224(sp)
	lw s2, 220(sp)
	lw s3, 216(sp)
	lw s4, 212(sp)
	lw s5, 208(sp)
	lw s6, 204(sp)
	lw s7, 200(sp)
	lw s8, 196(sp)
	lw s9, 192(sp)
	addi sp, sp, 240
	jalr x0, ra, 0

main:
	addi sp, sp, -352
	sw ra, 348(sp)
	sw s0, 344(sp)
	addi s0, sp, 352
	addi s1, x0, 1
	addi s2, x0, 1
	addi s3, x0, 3
	addi s4, x0, 2
	addi s5, x0, 5
	addi s6, x0, 3
	addi s7, x0, 7
	addi s8, x0, 4
	addi a0, s1, 0
	addi a1, s2, 0
	addi a2, s3, 0
	addi a3, s4, 0
	addi a4, s5, 0
	addi a5, s6, 0
	addi a6, s7, 0
	addi a7, s8, 0
	jal ra, sum8
	addi t5, a0, 0
	sw t5, -136(s0)
	addi s7, x0, 1
	addi s6, x0, 2
	addi s5, x0, 3
	addi t5, x0, 4
	sw t5, -256(s0)
	addi t5, x0, 5
	sw t5, -16(s0)
	addi t5, x0, 6
	sw t5, -200(s0)
	addi t5, x0, 7
	sw t5, -168(s0)
	addi t5, x0, 8
	sw t5, -280(s0)
	addi s10, x0, 1
	addi s11, x0, 2
	addi s8, x0, 3
	addi s9, x0, 4
	addi s1, x0, 13
	lw t5, -136(s0)
	add s1, t5, s1
	addi s2, x0, 14
	lw t5, -136(s0)
	add s2, t5, s2
	addi s3, x0, 15
	lw t5, -136(s0)
	add s3, t5, s3
	addi s4, x0, 16
	lw t5, -136(s0)
	add s4, t5, s4
	addi sp, sp, -4
	sw t5, 0(sp)
	addi sp, sp, -32
	sw s4, 0(sp)
	sw s3, 4(sp)
	sw s2, 8(sp)
	sw s1, 12(sp)
	sw s9, 16(sp)
	sw s8, 20(sp)
	sw s11, 24(sp)
	sw s10, 28(sp)
	addi a0, s7, 0
	addi a1, s6, 0
	addi a2, s5, 0
	lw t5, -256(s0)
	addi a3, t5, 0
	lw t5, -16(s0)
	addi a4, t5, 0
	lw t5, -200(s0)
	addi a5, t5, 0
	lw t5, -168(s0)
	addi a6, t5, 0
	lw t5, -280(s0)
	addi a7, t5, 0
	jal ra, sum16
	addi sp, sp, 32
	lw t5, 0(sp)
	addi sp, sp, 4
	addi t5, a0, 0
	sw t5, -156(s0)
	addi t5, x0, 1
	sw t5, -28(s0)
	addi t5, x0, 2
	sw t5, -56(s0)
	addi t5, x0, 3
	sw t5, -64(s0)
	addi t5, x0, 4
	sw t5, -204(s0)
	addi t5, x0, 5
	sw t5, -340(s0)
	addi t5, x0, 6
	sw t5, -116(s0)
	addi t5, x0, 7
	sw t5, -208(s0)
	addi t5, x0, 8
	sw t5, -60(s0)
	addi t5, x0, 9
	sw t5, -316(s0)
	addi t5, x0, 10
	sw t5, -104(s0)
	addi t5, x0, 11
	sw t5, -176(s0)
	addi t5, x0, 12
	sw t5, -124(s0)
	addi t5, x0, 13
	sw t5, -76(s0)
	addi t5, x0, 14
	sw t5, -92(s0)
	addi t5, x0, 15
	sw t5, -272(s0)
	addi t5, x0, 16
	sw t5, -84(s0)
	addi t5, x0, 17
	sw t5, -196(s0)
	addi t5, x0, 18
	sw t5, -288(s0)
	addi t5, x0, 19
	sw t5, -244(s0)
	addi t5, x0, 20
	sw t5, -252(s0)
	addi t5, x0, 21
	sw t5, -24(s0)
	addi s5, x0, 22
	addi s2, x0, 23
	addi s1, x0, 24
	addi s9, x0, 25
	addi s8, x0, 26
	addi s11, x0, 27
	addi s10, x0, 28
	addi s7, x0, 29
	addi s6, x0, 30
	addi s3, x0, 31
	addi s4, x0, 32
	addi sp, sp, -4
	sw t5, 0(sp)
	addi sp, sp, -96
	sw s4, 0(sp)
	sw s3, 4(sp)
	sw s6, 8(sp)
	sw s7, 12(sp)
	sw s10, 16(sp)
	sw s11, 20(sp)
	sw s8, 24(sp)
	sw s9, 28(sp)
	sw s1, 32(sp)
	sw s2, 36(sp)
	sw s5, 40(sp)
	lw t5, -24(s0)
	sw t5, 44(sp)
	lw t5, -252(s0)
	sw t5, 48(sp)
	lw t5, -244(s0)
	sw t5, 52(sp)
	lw t5, -288(s0)
	sw t5, 56(sp)
	lw t5, -196(s0)
	sw t5, 60(sp)
	lw t5, -84(s0)
	sw t5, 64(sp)
	lw t5, -272(s0)
	sw t5, 68(sp)
	lw t5, -92(s0)
	sw t5, 72(sp)
	lw t5, -76(s0)
	sw t5, 76(sp)
	lw t5, -124(s0)
	sw t5, 80(sp)
	lw t5, -176(s0)
	sw t5, 84(sp)
	lw t5, -104(s0)
	sw t5, 88(sp)
	lw t5, -316(s0)
	sw t5, 92(sp)
	lw t5, -28(s0)
	addi a0, t5, 0
	lw t5, -56(s0)
	addi a1, t5, 0
	lw t5, -64(s0)
	addi a2, t5, 0
	lw t5, -204(s0)
	addi a3, t5, 0
	lw t5, -340(s0)
	addi a4, t5, 0
	lw t5, -116(s0)
	addi a5, t5, 0
	lw t5, -208(s0)
	addi a6, t5, 0
	lw t5, -60(s0)
	addi a7, t5, 0
	jal ra, sum32
	addi sp, sp, 96
	lw t5, 0(sp)
	addi sp, sp, 4
	addi t5, a0, 0
	sw t5, -152(s0)
	addi t5, x0, 1
	sw t5, -172(s0)
	addi t5, x0, 2
	sw t5, -336(s0)
	addi t5, x0, 3
	sw t5, -144(s0)
	addi t5, x0, 4
	sw t5, -184(s0)
	addi t5, x0, 5
	sw t5, -20(s0)
	addi t5, x0, 6
	sw t5, -264(s0)
	addi t5, x0, 7
	sw t5, -300(s0)
	addi t5, x0, 8
	sw t5, -12(s0)
	addi t5, x0, 9
	sw t5, -268(s0)
	addi t5, x0, 10
	sw t5, -228(s0)
	addi t5, x0, 11
	sw t5, -180(s0)
	addi t5, x0, 12
	sw t5, -108(s0)
	addi t5, x0, 13
	sw t5, -52(s0)
	addi t5, x0, 14
	sw t5, -232(s0)
	addi t5, x0, 15
	sw t5, -240(s0)
	addi t5, x0, 16
	sw t5, -132(s0)
	addi t5, x0, 17
	sw t5, -36(s0)
	addi t5, x0, 18
	sw t5, -160(s0)
	addi t5, x0, 19
	sw t5, -48(s0)
	addi t5, x0, 20
	sw t5, -120(s0)
	addi t5, x0, 21
	sw t5, -44(s0)
	addi t5, x0, 22
	sw t5, -296(s0)
	addi t5, x0, 23
	sw t5, -164(s0)
	addi t5, x0, 24
	sw t5, -324(s0)
	addi t5, x0, 25
	sw t5, -328(s0)
	addi t5, x0, 26
	sw t5, -332(s0)
	addi t5, x0, 27
	sw t5, -292(s0)
	addi t5, x0, 28
	sw t5, -192(s0)
	addi t5, x0, 29
	sw t5, -112(s0)
	addi t5, x0, 30
	sw t5, -216(s0)
	addi t5, x0, 31
	sw t5, -128(s0)
	addi t5, x0, 32
	sw t5, -96(s0)
	addi t5, x0, 2
	sw t5, -188(s0)
	addi t5, x0, 4
	sw t5, -72(s0)
	addi t5, x0, 6
	sw t5, -80(s0)
	addi t5, x0, 8
	sw t5, -40(s0)
	addi t5, x0, 10
	sw t5, -32(s0)
	addi t5, x0, 12
	sw t5, -88(s0)
	addi t5, x0, 14
	sw t5, -276(s0)
	addi t5, x0, 16
	sw t5, -148(s0)
	addi t5, x0, 81
	sw t5, -236(s0)
	addi t5, x0, 100
	sw t5, -248(s0)
	addi t5, x0, 121
	sw t5, -320(s0)
	addi t5, x0, 144
	sw t5, -304(s0)
	addi t5, x0, 169
	sw t5, -68(s0)
	addi t5, x0, 196
	sw t5, -312(s0)
	addi t5, x0, 225
	sw t5, -284(s0)
	addi t5, x0, 256
	sw t5, -224(s0)
	addi t5, x0, 18
	sw t5, -260(s0)
	addi t5, x0, 20
	sw t5, -140(s0)
	addi t5, x0, 22
	sw t5, -220(s0)
	addi t5, x0, 24
	sw t5, -212(s0)
	addi t5, x0, 26
	sw t5, -308(s0)
	addi t5, x0, 28
	sw t5, -100(s0)
	addi s5, x0, 30
	addi s6, x0, 32
	addi s7, x0, 9
	lw t5, -152(s0)
	add s7, s7, t5
	addi s10, x0, 20
	lw t5, -152(s0)
	add s10, s10, t5
	addi s11, x0, 33
	lw t5, -152(s0)
	add s11, s11, t5
	addi s8, x0, 48
	lw t5, -152(s0)
	add s8, s8, t5
	addi s9, x0, 65
	lw t5, -152(s0)
	add s9, s9, t5
	addi s1, x0, 84
	lw t5, -152(s0)
	add s1, s1, t5
	addi s2, x0, 105
	lw t5, -152(s0)
	add s2, s2, t5
	addi s3, x0, 128
	lw t5, -136(s0)
	lw t6, -156(s0)
	add s4, t5, t6
	lw t5, -152(s0)
	add s4, s4, t5
	add s3, s3, s4
	addi sp, sp, -4
	sw t5, 0(sp)
	addi sp, sp, -224
	sw s3, 0(sp)
	sw s2, 4(sp)
	sw s1, 8(sp)
	sw s9, 12(sp)
	sw s8, 16(sp)
	sw s11, 20(sp)
	sw s10, 24(sp)
	sw s7, 28(sp)
	sw s6, 32(sp)
	sw s5, 36(sp)
	lw t5, -100(s0)
	sw t5, 40(sp)
	lw t5, -308(s0)
	sw t5, 44(sp)
	lw t5, -212(s0)
	sw t5, 48(sp)
	lw t5, -220(s0)
	sw t5, 52(sp)
	lw t5, -140(s0)
	sw t5, 56(sp)
	lw t5, -260(s0)
	sw t5, 60(sp)
	lw t5, -224(s0)
	sw t5, 64(sp)
	lw t5, -284(s0)
	sw t5, 68(sp)
	lw t5, -312(s0)
	sw t5, 72(sp)
	lw t5, -68(s0)
	sw t5, 76(sp)
	lw t5, -304(s0)
	sw t5, 80(sp)
	lw t5, -320(s0)
	sw t5, 84(sp)
	lw t5, -248(s0)
	sw t5, 88(sp)
	lw t5, -236(s0)
	sw t5, 92(sp)
	lw t5, -148(s0)
	sw t5, 96(sp)
	lw t5, -276(s0)
	sw t5, 100(sp)
	lw t5, -88(s0)
	sw t5, 104(sp)
	lw t5, -32(s0)
	sw t5, 108(sp)
	lw t5, -40(s0)
	sw t5, 112(sp)
	lw t5, -80(s0)
	sw t5, 116(sp)
	lw t5, -72(s0)
	sw t5, 120(sp)
	lw t5, -188(s0)
	sw t5, 124(sp)
	lw t5, -96(s0)
	sw t5, 128(sp)
	lw t5, -128(s0)
	sw t5, 132(sp)
	lw t5, -216(s0)
	sw t5, 136(sp)
	lw t5, -112(s0)
	sw t5, 140(sp)
	lw t5, -192(s0)
	sw t5, 144(sp)
	lw t5, -292(s0)
	sw t5, 148(sp)
	lw t5, -332(s0)
	sw t5, 152(sp)
	lw t5, -328(s0)
	sw t5, 156(sp)
	lw t5, -324(s0)
	sw t5, 160(sp)
	lw t5, -164(s0)
	sw t5, 164(sp)
	lw t5, -296(s0)
	sw t5, 168(sp)
	lw t5, -44(s0)
	sw t5, 172(sp)
	lw t5, -120(s0)
	sw t5, 176(sp)
	lw t5, -48(s0)
	sw t5, 180(sp)
	lw t5, -160(s0)
	sw t5, 184(sp)
	lw t5, -36(s0)
	sw t5, 188(sp)
	lw t5, -132(s0)
	sw t5, 192(sp)
	lw t5, -240(s0)
	sw t5, 196(sp)
	lw t5, -232(s0)
	sw t5, 200(sp)
	lw t5, -52(s0)
	sw t5, 204(sp)
	lw t5, -108(s0)
	sw t5, 208(sp)
	lw t5, -180(s0)
	sw t5, 212(sp)
	lw t5, -228(s0)
	sw t5, 216(sp)
	lw t5, -268(s0)
	sw t5, 220(sp)
	lw t5, -172(s0)
	addi a0, t5, 0
	lw t5, -336(s0)
	addi a1, t5, 0
	lw t5, -144(s0)
	addi a2, t5, 0
	lw t5, -184(s0)
	addi a3, t5, 0
	lw t5, -20(s0)
	addi a4, t5, 0
	lw t5, -264(s0)
	addi a5, t5, 0
	lw t5, -300(s0)
	addi a6, t5, 0
	lw t5, -12(s0)
	addi a7, t5, 0
	jal ra, sum64
	addi sp, sp, 224
	lw t5, 0(sp)
	addi sp, sp, 4
	addi t0, a0, 0
	lw t5, -152(s0)
	addi a0, t5, 0
	jal x0, main_return
main_return:
	lw ra, 348(sp)
	lw s0, 344(sp)
	addi sp, sp, 352
	jalr x0, ra, 0

