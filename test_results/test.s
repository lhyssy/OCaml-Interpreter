.globl main
.text
abs:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, x0, 0
	bge t0, t1, else_0
	addi t1, x0, 0
	sub t1, t1, t0
	addi a0, t1, 0
	jal x0, abs_return
else_0:
	addi a0, t0, 0
	jal x0, abs_return
abs_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

echo:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi a0, t0, 0
	jal x0, echo_return
echo_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

compute:
	addi sp, sp, -32
	sw ra, 28(sp)
	sw s0, 24(sp)
	sw s1, 20(sp)
	sw s2, 16(sp)
	sw s3, 12(sp)
	sw s4, 8(sp)
	sw s5, 4(sp)
	sw s6, 0(sp)
	addi s0, sp, 32
	addi s1, a0, 0
	addi s2, a1, 0
	addi s3, a2, 0
	addi s4, a3, 0
	addi s5, a4, 0
	addi t0, a5, 0
	addi s6, a6, 0
	addi t1, a7, 0
	mul s2, s2, s3
	add s1, s1, s2
	addi a0, s5, 0
	addi sp, sp, -8
	sw t0, 0(sp)
	sw t1, 4(sp)
	jal ra, abs
	lw t0, 0(sp)
	lw t1, 4(sp)
	addi sp, sp, 8
	addi s5, a0, 0
	addi s2, x0, 1
	add s5, s5, s2
	div s4, s4, s5
	sub t2, s1, s4
	addi a0, s6, 0
	addi sp, sp, -12
	sw t0, 0(sp)
	sw t1, 4(sp)
	sw t2, 8(sp)
	jal ra, abs
	lw t0, 0(sp)
	lw t1, 4(sp)
	lw t2, 8(sp)
	addi sp, sp, 12
	addi t3, a0, 0
	addi t4, x0, 1
	add t3, t3, t4
	rem t0, t0, t3
	mul t1, t0, t1
	add t2, t2, t1
	addi a0, t2, 0
	jal x0, compute_return
compute_return:
	lw ra, 28(sp)
	lw s0, 24(sp)
	lw s1, 20(sp)
	lw s2, 16(sp)
	lw s3, 12(sp)
	lw s4, 8(sp)
	lw s5, 4(sp)
	lw s6, 0(sp)
	addi sp, sp, 32
	jalr x0, ra, 0

main:
	addi sp, sp, -448
	sw ra, 444(sp)
	sw s0, 440(sp)
	addi s0, sp, 448
	addi s1, x0, 1
	addi a0, s1, 0
	jal ra, echo
	addi s1, a0, 0
	addi s2, x0, 2
	addi a0, s2, 0
	jal ra, echo
	addi s2, a0, 0
	addi s3, x0, 3
	addi a0, s3, 0
	jal ra, echo
	addi s3, a0, 0
	addi s4, x0, 4
	addi a0, s4, 0
	jal ra, echo
	addi s4, a0, 0
	addi s5, x0, 5
	addi a0, s5, 0
	jal ra, echo
	addi t5, a0, 0
	sw t5, -160(s0)
	addi s6, x0, 6
	addi a0, s6, 0
	addi sp, sp, -4
	sw t5, 0(sp)
	jal ra, echo
	lw t5, 0(sp)
	addi sp, sp, 4
	addi t5, a0, 0
	sw t5, -368(s0)
	addi s7, x0, 7
	addi a0, s7, 0
	addi sp, sp, -4
	sw t5, 0(sp)
	jal ra, echo
	lw t5, 0(sp)
	addi sp, sp, 4
	addi t5, a0, 0
	sw t5, -12(s0)
	addi s8, x0, 8
	addi a0, s8, 0
	addi sp, sp, -4
	sw t5, 0(sp)
	jal ra, echo
	lw t5, 0(sp)
	addi sp, sp, 4
	addi t5, a0, 0
	sw t5, -308(s0)
	addi s9, x0, 9
	addi a0, s9, 0
	addi sp, sp, -4
	sw t5, 0(sp)
	jal ra, echo
	lw t5, 0(sp)
	addi sp, sp, 4
	addi t5, a0, 0
	sw t5, -344(s0)
	addi s10, x0, 10
	addi a0, s10, 0
	addi sp, sp, -4
	sw t5, 0(sp)
	jal ra, echo
	lw t5, 0(sp)
	addi sp, sp, 4
	addi t5, a0, 0
	sw t5, -16(s0)
	addi s11, x0, 11
	addi a0, s11, 0
	addi sp, sp, -4
	sw t5, 0(sp)
	jal ra, echo
	lw t5, 0(sp)
	addi sp, sp, 4
	addi t5, a0, 0
	sw t5, -36(s0)
	addi s11, x0, 12
	addi a0, s11, 0
	addi sp, sp, -4
	sw t5, 0(sp)
	jal ra, echo
	lw t5, 0(sp)
	addi sp, sp, 4
	addi t5, a0, 0
	sw t5, -332(s0)
	addi s11, x0, 13
	addi a0, s11, 0
	addi sp, sp, -4
	sw t5, 0(sp)
	jal ra, echo
	lw t5, 0(sp)
	addi sp, sp, 4
	addi t5, a0, 0
	sw t5, -32(s0)
	addi s11, x0, 14
	addi a0, s11, 0
	addi sp, sp, -4
	sw t5, 0(sp)
	jal ra, echo
	lw t5, 0(sp)
	addi sp, sp, 4
	addi t5, a0, 0
	sw t5, -8(s0)
	addi s11, x0, 15
	addi a0, s11, 0
	addi sp, sp, -4
	sw t5, 0(sp)
	jal ra, echo
	lw t5, 0(sp)
	addi sp, sp, 4
	addi t5, a0, 0
	sw t5, -120(s0)
	addi s11, x0, 16
	addi a0, s11, 0
	addi sp, sp, -4
	sw t5, 0(sp)
	jal ra, echo
	lw t5, 0(sp)
	addi sp, sp, 4
	addi t5, a0, 0
	sw t5, -44(s0)
	addi s11, x0, 17
	addi a0, s11, 0
	addi sp, sp, -4
	sw t5, 0(sp)
	jal ra, echo
	lw t5, 0(sp)
	addi sp, sp, 4
	addi t5, a0, 0
	sw t5, -156(s0)
	addi s11, x0, 18
	addi a0, s11, 0
	addi sp, sp, -4
	sw t5, 0(sp)
	jal ra, echo
	lw t5, 0(sp)
	addi sp, sp, 4
	addi t5, a0, 0
	sw t5, -96(s0)
	addi s11, x0, 19
	addi a0, s11, 0
	addi sp, sp, -4
	sw t5, 0(sp)
	jal ra, echo
	lw t5, 0(sp)
	addi sp, sp, 4
	addi t5, a0, 0
	sw t5, -264(s0)
	addi s11, x0, 20
	addi a0, s11, 0
	addi sp, sp, -4
	sw t5, 0(sp)
	jal ra, echo
	lw t5, 0(sp)
	addi sp, sp, 4
	addi t5, a0, 0
	sw t5, -88(s0)
	addi s11, x0, 21
	addi a0, s11, 0
	addi sp, sp, -4
	sw t5, 0(sp)
	jal ra, echo
	lw t5, 0(sp)
	addi sp, sp, 4
	addi t5, a0, 0
	sw t5, -296(s0)
	addi s11, x0, 22
	addi a0, s11, 0
	addi sp, sp, -4
	sw t5, 0(sp)
	jal ra, echo
	lw t5, 0(sp)
	addi sp, sp, 4
	addi t5, a0, 0
	sw t5, -76(s0)
	addi s11, x0, 23
	addi a0, s11, 0
	addi sp, sp, -4
	sw t5, 0(sp)
	jal ra, echo
	lw t5, 0(sp)
	addi sp, sp, 4
	addi t5, a0, 0
	sw t5, -72(s0)
	addi s11, x0, 24
	addi a0, s11, 0
	addi sp, sp, -4
	sw t5, 0(sp)
	jal ra, echo
	lw t5, 0(sp)
	addi sp, sp, 4
	addi t5, a0, 0
	sw t5, -396(s0)
	addi s11, x0, 25
	addi a0, s11, 0
	addi sp, sp, -4
	sw t5, 0(sp)
	jal ra, echo
	lw t5, 0(sp)
	addi sp, sp, 4
	addi t5, a0, 0
	sw t5, -356(s0)
	addi s11, x0, 26
	addi a0, s11, 0
	addi sp, sp, -4
	sw t5, 0(sp)
	jal ra, echo
	lw t5, 0(sp)
	addi sp, sp, 4
	addi t5, a0, 0
	sw t5, -292(s0)
	addi s11, x0, 27
	addi a0, s11, 0
	addi sp, sp, -4
	sw t5, 0(sp)
	jal ra, echo
	lw t5, 0(sp)
	addi sp, sp, 4
	addi t5, a0, 0
	sw t5, -136(s0)
	addi s11, x0, 28
	addi a0, s11, 0
	addi sp, sp, -4
	sw t5, 0(sp)
	jal ra, echo
	lw t5, 0(sp)
	addi sp, sp, 4
	addi t5, a0, 0
	sw t5, -60(s0)
	addi s11, x0, 29
	addi a0, s11, 0
	addi sp, sp, -4
	sw t5, 0(sp)
	jal ra, echo
	lw t5, 0(sp)
	addi sp, sp, 4
	addi t5, a0, 0
	sw t5, -260(s0)
	addi s11, x0, 30
	addi a0, s11, 0
	addi sp, sp, -4
	sw t5, 0(sp)
	jal ra, echo
	lw t5, 0(sp)
	addi sp, sp, 4
	addi t5, a0, 0
	sw t5, -276(s0)
	addi s11, x0, 31
	addi a0, s11, 0
	addi sp, sp, -4
	sw t5, 0(sp)
	jal ra, echo
	lw t5, 0(sp)
	addi sp, sp, 4
	addi t5, a0, 0
	sw t5, -404(s0)
	addi s11, x0, 32
	addi a0, s11, 0
	addi sp, sp, -4
	sw t5, 0(sp)
	jal ra, echo
	lw t5, 0(sp)
	addi sp, sp, 4
	addi t5, a0, 0
	sw t5, -316(s0)
	add s11, s1, s2
	add s11, s11, s3
	add s11, s11, s4
	lw t5, -160(s0)
	add s11, s11, t5
	lw t5, -368(s0)
	add s11, s11, t5
	lw t5, -12(s0)
	add s11, s11, t5
	lw t5, -308(s0)
	add t5, s11, t5
	sw t5, -4(s0)
	lw t5, -344(s0)
	lw t6, -16(s0)
	add s11, t5, t6
	lw t5, -36(s0)
	add s11, s11, t5
	lw t5, -332(s0)
	add s11, s11, t5
	lw t5, -32(s0)
	add s11, s11, t5
	lw t5, -8(s0)
	add s11, s11, t5
	lw t5, -120(s0)
	add s11, s11, t5
	lw t5, -44(s0)
	add s11, s11, t5
	lw t5, -156(s0)
	lw t6, -96(s0)
	add s10, t5, t6
	lw t5, -264(s0)
	add s10, s10, t5
	lw t5, -88(s0)
	add s10, s10, t5
	lw t5, -296(s0)
	add s10, s10, t5
	lw t5, -76(s0)
	add s10, s10, t5
	lw t5, -72(s0)
	add s10, s10, t5
	lw t5, -396(s0)
	add s10, s10, t5
	lw t5, -356(s0)
	lw t6, -292(s0)
	add s9, t5, t6
	lw t5, -136(s0)
	add s9, s9, t5
	lw t5, -60(s0)
	add s9, s9, t5
	lw t5, -260(s0)
	add s9, s9, t5
	lw t5, -276(s0)
	add s9, s9, t5
	lw t5, -404(s0)
	add s9, s9, t5
	lw t5, -316(s0)
	add s9, s9, t5
	lw t5, -4(s0)
	add s11, t5, s11
	add s10, s11, s10
	add t5, s10, s9
	sw t5, -288(s0)
	slli s10, s1, 1
	slli s11, s2, 1
	slli s9, s3, 1
	slli s8, s4, 1
	lw t5, -160(s0)
	slli t5, t5, 1
	sw t5, -24(s0)
	lw t5, -368(s0)
	slli t5, t5, 1
	sw t5, -280(s0)
	lw t5, -12(s0)
	slli t5, t5, 1
	sw t5, -208(s0)
	lw t5, -308(s0)
	slli t5, t5, 1
	sw t5, -116(s0)
	lw t5, -344(s0)
	slli t5, t5, 1
	sw t5, -176(s0)
	lw t5, -16(s0)
	slli t5, t5, 1
	sw t5, -348(s0)
	lw t5, -36(s0)
	slli t5, t5, 1
	sw t5, -416(s0)
	lw t5, -332(s0)
	slli t5, t5, 1
	sw t5, -228(s0)
	lw t5, -32(s0)
	slli t5, t5, 1
	sw t5, -272(s0)
	lw t5, -8(s0)
	slli t5, t5, 1
	sw t5, -232(s0)
	lw t5, -120(s0)
	slli t5, t5, 1
	sw t5, -212(s0)
	lw t5, -44(s0)
	slli t5, t5, 1
	sw t5, -328(s0)
	lw t5, -156(s0)
	slli t5, t5, 1
	sw t5, -188(s0)
	lw t5, -96(s0)
	slli t5, t5, 1
	sw t5, -304(s0)
	lw t5, -264(s0)
	slli t5, t5, 1
	sw t5, -168(s0)
	lw t5, -88(s0)
	slli t5, t5, 1
	sw t5, -164(s0)
	lw t5, -296(s0)
	slli t5, t5, 1
	sw t5, -400(s0)
	lw t5, -76(s0)
	slli t5, t5, 1
	sw t5, -84(s0)
	lw t5, -72(s0)
	slli t5, t5, 1
	sw t5, -140(s0)
	lw t5, -396(s0)
	slli t5, t5, 1
	sw t5, -300(s0)
	lw t5, -356(s0)
	slli t5, t5, 1
	sw t5, -220(s0)
	lw t5, -292(s0)
	slli t5, t5, 1
	sw t5, -172(s0)
	lw t5, -136(s0)
	slli t5, t5, 1
	sw t5, -204(s0)
	lw t5, -60(s0)
	slli t5, t5, 1
	sw t5, -68(s0)
	lw t5, -260(s0)
	slli t5, t5, 1
	sw t5, -268(s0)
	lw t5, -276(s0)
	slli t5, t5, 1
	sw t5, -408(s0)
	lw t5, -404(s0)
	slli t5, t5, 1
	sw t5, -244(s0)
	lw t5, -316(s0)
	slli t5, t5, 1
	sw t5, -376(s0)
	add s6, s10, s11
	add s6, s6, s9
	add s6, s6, s8
	lw t5, -24(s0)
	add s6, s6, t5
	lw t5, -280(s0)
	add s6, s6, t5
	lw t5, -208(s0)
	add s6, s6, t5
	lw t5, -116(s0)
	add t5, s6, t5
	sw t5, -256(s0)
	lw t5, -176(s0)
	lw t6, -348(s0)
	add s6, t5, t6
	lw t5, -416(s0)
	add s6, s6, t5
	lw t5, -228(s0)
	add s6, s6, t5
	lw t5, -272(s0)
	add s6, s6, t5
	lw t5, -232(s0)
	add s6, s6, t5
	lw t5, -212(s0)
	add s6, s6, t5
	lw t5, -328(s0)
	add s6, s6, t5
	lw t5, -188(s0)
	lw t6, -304(s0)
	add s5, t5, t6
	lw t5, -168(s0)
	add s5, s5, t5
	lw t5, -164(s0)
	add s5, s5, t5
	lw t5, -400(s0)
	add s5, s5, t5
	lw t5, -84(s0)
	add s5, s5, t5
	lw t5, -140(s0)
	add s5, s5, t5
	lw t5, -300(s0)
	add s5, s5, t5
	lw t5, -220(s0)
	lw t6, -172(s0)
	add s7, t5, t6
	lw t5, -204(s0)
	add s7, s7, t5
	lw t5, -68(s0)
	add s7, s7, t5
	lw t5, -268(s0)
	add s7, s7, t5
	lw t5, -408(s0)
	add s7, s7, t5
	lw t5, -244(s0)
	add s7, s7, t5
	lw t5, -376(s0)
	add s7, s7, t5
	lw t5, -256(s0)
	add s6, t5, s6
	add s5, s6, s5
	add t5, s5, s7
	sw t5, -56(s0)
	add s1, s10, s1
	add s2, s11, s2
	add s3, s9, s3
	add s4, s8, s4
	lw t5, -24(s0)
	lw t6, -160(s0)
	add s8, t5, t6
	lw t5, -280(s0)
	lw t6, -368(s0)
	add s9, t5, t6
	lw t5, -208(s0)
	lw t6, -12(s0)
	add s11, t5, t6
	lw t5, -116(s0)
	lw t6, -308(s0)
	add s10, t5, t6
	lw t5, -176(s0)
	lw t6, -344(s0)
	add t5, t5, t6
	sw t5, -428(s0)
	lw t5, -348(s0)
	lw t6, -16(s0)
	add t5, t5, t6
	sw t5, -196(s0)
	lw t5, -416(s0)
	lw t6, -36(s0)
	add t5, t5, t6
	sw t5, -180(s0)
	lw t5, -228(s0)
	lw t6, -332(s0)
	add t5, t5, t6
	sw t5, -320(s0)
	lw t5, -272(s0)
	lw t6, -32(s0)
	add t5, t5, t6
	sw t5, -392(s0)
	lw t5, -232(s0)
	lw t6, -8(s0)
	add t5, t5, t6
	sw t5, -380(s0)
	lw t5, -212(s0)
	lw t6, -120(s0)
	add t5, t5, t6
	sw t5, -424(s0)
	lw t5, -328(s0)
	lw t6, -44(s0)
	add t5, t5, t6
	sw t5, -248(s0)
	lw t5, -188(s0)
	lw t6, -156(s0)
	add t5, t5, t6
	sw t5, -108(s0)
	lw t5, -304(s0)
	lw t6, -96(s0)
	add t5, t5, t6
	sw t5, -48(s0)
	lw t5, -168(s0)
	lw t6, -264(s0)
	add t5, t5, t6
	sw t5, -216(s0)
	lw t5, -164(s0)
	lw t6, -88(s0)
	add t5, t5, t6
	sw t5, -80(s0)
	lw t5, -400(s0)
	lw t6, -296(s0)
	add t5, t5, t6
	sw t5, -200(s0)
	lw t5, -84(s0)
	lw t6, -76(s0)
	add t5, t5, t6
	sw t5, -236(s0)
	lw t5, -140(s0)
	lw t6, -72(s0)
	add t5, t5, t6
	sw t5, -284(s0)
	lw t5, -300(s0)
	lw t6, -396(s0)
	add t5, t5, t6
	sw t5, -104(s0)
	lw t5, -220(s0)
	lw t6, -356(s0)
	add t5, t5, t6
	sw t5, -28(s0)
	lw t5, -172(s0)
	lw t6, -292(s0)
	add t5, t5, t6
	sw t5, -388(s0)
	lw t5, -204(s0)
	lw t6, -136(s0)
	add t5, t5, t6
	sw t5, -152(s0)
	lw t5, -68(s0)
	lw t6, -60(s0)
	add t5, t5, t6
	sw t5, -132(s0)
	lw t5, -268(s0)
	lw t6, -260(s0)
	add t5, t5, t6
	sw t5, -100(s0)
	lw t5, -408(s0)
	lw t6, -276(s0)
	add t5, t5, t6
	sw t5, -128(s0)
	lw t5, -244(s0)
	lw t6, -404(s0)
	add t5, t5, t6
	sw t5, -240(s0)
	lw t5, -376(s0)
	lw t6, -316(s0)
	add t5, t5, t6
	sw t5, -412(s0)
	add s7, s1, s2
	add s7, s7, s3
	add s7, s7, s4
	add s7, s7, s8
	add s7, s7, s9
	add s7, s7, s11
	add t5, s7, s10
	sw t5, -364(s0)
	lw t5, -428(s0)
	lw t6, -196(s0)
	add s7, t5, t6
	lw t5, -180(s0)
	add s7, s7, t5
	lw t5, -320(s0)
	add s7, s7, t5
	lw t5, -392(s0)
	add s7, s7, t5
	lw t5, -380(s0)
	add s7, s7, t5
	lw t5, -424(s0)
	add s7, s7, t5
	lw t5, -248(s0)
	add s7, s7, t5
	lw t5, -108(s0)
	lw t6, -48(s0)
	add s6, t5, t6
	lw t5, -216(s0)
	add s6, s6, t5
	lw t5, -80(s0)
	add s6, s6, t5
	lw t5, -200(s0)
	add s6, s6, t5
	lw t5, -236(s0)
	add s6, s6, t5
	lw t5, -284(s0)
	add s6, s6, t5
	lw t5, -104(s0)
	add s6, s6, t5
	lw t5, -28(s0)
	lw t6, -388(s0)
	add s5, t5, t6
	lw t5, -152(s0)
	add s5, s5, t5
	lw t5, -132(s0)
	add s5, s5, t5
	lw t5, -100(s0)
	add s5, s5, t5
	lw t5, -128(s0)
	add s5, s5, t5
	lw t5, -240(s0)
	add s5, s5, t5
	lw t5, -412(s0)
	add s5, s5, t5
	lw t5, -364(s0)
	add s7, t5, s7
	add s6, s7, s6
	add t5, s6, s5
	sw t5, -112(s0)
	addi s6, x0, 1
	add s1, s1, s6
	addi s6, x0, 1
	add s2, s2, s6
	addi s6, x0, 1
	add s3, s3, s6
	addi s6, x0, 1
	add s4, s4, s6
	addi s6, x0, 1
	add s8, s8, s6
	addi s6, x0, 1
	add s9, s9, s6
	addi s6, x0, 1
	add s11, s11, s6
	addi s6, x0, 1
	add s10, s10, s6
	addi s6, x0, 1
	lw t5, -428(s0)
	add s6, t5, s6
	addi s7, x0, 1
	lw t5, -196(s0)
	add s7, t5, s7
	addi s5, x0, 1
	lw t5, -180(s0)
	add t5, t5, s5
	sw t5, -252(s0)
	addi s5, x0, 1
	lw t5, -320(s0)
	add t5, t5, s5
	sw t5, -52(s0)
	addi s5, x0, 1
	lw t5, -392(s0)
	add t5, t5, s5
	sw t5, -372(s0)
	addi s5, x0, 1
	lw t5, -380(s0)
	add t5, t5, s5
	sw t5, -384(s0)
	addi s5, x0, 1
	lw t5, -424(s0)
	add t5, t5, s5
	sw t5, -144(s0)
	addi s5, x0, 1
	lw t5, -248(s0)
	add t5, t5, s5
	sw t5, -92(s0)
	addi s5, x0, 1
	lw t5, -108(s0)
	add t5, t5, s5
	sw t5, -312(s0)
	addi s5, x0, 1
	lw t5, -48(s0)
	add t5, t5, s5
	sw t5, -420(s0)
	addi s5, x0, 1
	lw t5, -216(s0)
	add t5, t5, s5
	sw t5, -192(s0)
	addi s5, x0, 1
	lw t5, -80(s0)
	add t5, t5, s5
	sw t5, -336(s0)
	addi s5, x0, 1
	lw t5, -200(s0)
	add t5, t5, s5
	sw t5, -64(s0)
	addi s5, x0, 1
	lw t5, -236(s0)
	add t5, t5, s5
	sw t5, -352(s0)
	addi s5, x0, 1
	lw t5, -284(s0)
	add t5, t5, s5
	sw t5, -40(s0)
	addi s5, x0, 1
	lw t5, -104(s0)
	add t5, t5, s5
	sw t5, -148(s0)
	addi s5, x0, 1
	lw t5, -28(s0)
	add t5, t5, s5
	sw t5, -360(s0)
	addi s5, x0, 1
	lw t5, -388(s0)
	add t5, t5, s5
	sw t5, -124(s0)
	addi s5, x0, 1
	lw t5, -152(s0)
	add t5, t5, s5
	sw t5, -20(s0)
	addi s5, x0, 1
	lw t5, -132(s0)
	add t5, t5, s5
	sw t5, -340(s0)
	addi s5, x0, 1
	lw t5, -100(s0)
	add t5, t5, s5
	sw t5, -324(s0)
	addi s5, x0, 1
	lw t5, -128(s0)
	add t5, t5, s5
	sw t5, -224(s0)
	addi s5, x0, 1
	lw t5, -240(s0)
	add t5, t5, s5
	sw t5, -184(s0)
	addi s5, x0, 1
	lw t5, -412(s0)
	add s5, t5, s5
	add s1, s1, s2
	add s3, s1, s3
	add s4, s3, s4
	add s8, s4, s8
	add s9, s8, s9
	add s11, s9, s11
	add s10, s11, s10
	add s6, s6, s7
	lw t5, -252(s0)
	add s6, s6, t5
	lw t5, -52(s0)
	add s6, s6, t5
	lw t5, -372(s0)
	add s6, s6, t5
	lw t5, -384(s0)
	add s6, s6, t5
	lw t5, -144(s0)
	add s6, s6, t5
	lw t5, -92(s0)
	add s6, s6, t5
	lw t5, -312(s0)
	lw t6, -420(s0)
	add s7, t5, t6
	lw t5, -192(s0)
	add s7, s7, t5
	lw t5, -336(s0)
	add s7, s7, t5
	lw t5, -64(s0)
	add s7, s7, t5
	lw t5, -352(s0)
	add s7, s7, t5
	lw t5, -40(s0)
	add s7, s7, t5
	lw t5, -148(s0)
	add s7, s7, t5
	lw t5, -360(s0)
	lw t6, -124(s0)
	add s11, t5, t6
	lw t5, -20(s0)
	add s11, s11, t5
	lw t5, -340(s0)
	add s11, s11, t5
	lw t5, -324(s0)
	add s11, s11, t5
	lw t5, -224(s0)
	add s11, s11, t5
	lw t5, -184(s0)
	add s11, s11, t5
	add s5, s11, s5
	add s6, s10, s6
	add s7, s6, s7
	add s5, s7, s5
	lw t5, -288(s0)
	addi a0, t5, 0
	lw t5, -56(s0)
	addi a1, t5, 0
	lw t5, -112(s0)
	addi a2, t5, 0
	addi a3, s5, 0
	lw t5, -4(s0)
	addi a4, t5, 0
	lw t5, -256(s0)
	addi a5, t5, 0
	lw t5, -364(s0)
	addi a6, t5, 0
	addi a7, s10, 0
	jal ra, compute
	addi t0, a0, 0
	addi a0, t0, 0
	jal x0, main_return
main_return:
	lw ra, 444(sp)
	lw s0, 440(sp)
	addi sp, sp, 448
	jalr x0, ra, 0

