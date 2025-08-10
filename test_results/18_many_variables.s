.globl main
.text
abs:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	bge a0, t0, else_0
	addi t0, x0, 0
	jal x0, abs_return
	addi a0, t0, 0
	sub t0, t0, a0
	addi t0, x0, 0
	jal x0, abs_return
else_0:
abs_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

echo:
	addi sp, sp, -16
	sw s0, 12(sp)
	addi s0, sp, 16
	jal x0, echo_return
echo_return:
	lw s0, 12(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

compute:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	sw s1, 4(sp)
	addi s0, sp, 16
	jal x0, compute_return
	addi a0, t0, 0
	add t0, s1, t0
	mul t0, t0, a7
	rem t0, a5, t0
	addi t0, a0, 1
	jal ra, abs
	addi a0, a6, 0
	sub s1, s1, t0
	div t0, a3, t0
	addi t0, a0, 1
	jal ra, abs
	addi a0, a4, 0
	add s1, a0, t0
	mul t0, a1, a2
compute_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	lw s1, 4(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

main:
	addi sp, sp, -160
	sw ra, 156(sp)
	sw s0, 152(sp)
	addi s0, sp, 160
	jal x0, main_return
	jal ra, compute
	addi a7, t0, 0
	addi a6, t1, 0
	lw t5, -24(s0)
	addi a5, t5, 0
	lw t5, -12(s0)
	addi a4, t5, 0
	addi a3, t4, 0
	addi a2, t4, 0
	addi a1, t4, 0
	addi a0, t4, 0
	add t4, t4, t4
	add t4, t4, t4
	add t4, t0, t0
	add t4, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t0, t0, t0
	add t4, t0, t0
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
	addi t0, t0, 1
	addi t0, t4, 1
	addi t0, s1, 1
	addi t0, s2, 1
	addi t0, s3, 1
	addi t0, s4, 1
	addi t0, s5, 1
	addi t0, s6, 1
	addi t0, s7, 1
	addi t0, s8, 1
	addi t0, s9, 1
	addi t0, s10, 1
	addi t0, s11, 1
	addi t0, t3, 1
	lw t5, -32(s0)
	addi t0, t5, 1
	lw t5, -56(s0)
	addi t0, t5, 1
	lw t5, -148(s0)
	addi t0, t5, 1
	lw t5, -152(s0)
	addi t0, t5, 1
	lw t5, -108(s0)
	addi t0, t5, 1
	lw t5, -124(s0)
	addi t0, t5, 1
	lw t5, -72(s0)
	addi t0, t5, 1
	lw t5, -100(s0)
	addi t0, t5, 1
	lw t5, -104(s0)
	addi t0, t5, 1
	lw t5, -156(s0)
	addi t0, t5, 1
	lw t5, -132(s0)
	addi t0, t5, 1
	lw t5, -144(s0)
	addi t0, t5, 1
	lw t5, -80(s0)
	addi t0, t5, 1
	lw t5, -44(s0)
	addi t0, t5, 1
	lw t5, -16(s0)
	addi t0, t5, 1
	lw t5, -120(s0)
	addi t0, t5, 1
	lw t5, -92(s0)
	addi t0, t5, 1
	lw t5, -84(s0)
	addi t0, t5, 1
	add t4, t2, t2
	add t2, t2, t2
	add t2, t1, t1
	add t2, t0, t0
	add t0, t4, t4
	add t4, t4, s1
	add t4, t4, s2
	add t4, t4, s3
	add t4, t4, s4
	add t4, s6, s5
	add t2, t4, s7
	add t4, t4, s8
	add t4, t4, s9
	add t4, t4, s10
	add t4, t4, s11
	add t4, t3, t3
	lw t5, -56(s0)
	lw t6, -32(s0)
	add t3, t5, t6
	lw t5, -148(s0)
	add t1, t3, t5
	lw t5, -152(s0)
	add t3, t3, t5
	lw t5, -108(s0)
	add t3, t3, t5
	lw t5, -124(s0)
	add t3, t3, t5
	lw t5, -72(s0)
	add t3, t3, t5
	lw t5, -100(s0)
	add t3, t3, t5
	lw t5, -156(s0)
	lw t6, -104(s0)
	add t3, t5, t6
	lw t5, -132(s0)
	add t1, t3, t5
	lw t5, -144(s0)
	add t3, t3, t5
	lw t5, -80(s0)
	add t3, t3, t5
	lw t5, -44(s0)
	add t3, t3, t5
	lw t5, -16(s0)
	add t3, t3, t5
	lw t5, -120(s0)
	add t3, t3, t5
	lw t5, -84(s0)
	lw t6, -92(s0)
	add t3, t5, t6
	add t0, t3, a0
	add t4, t4, a0
	add s1, t0, a0
	add s2, t1, a0
	add s3, t2, a0
	add s4, s11, a0
	add s5, s10, a0
	add s6, s9, a0
	add s7, s8, a0
	add s8, s7, a0
	add s9, s5, a0
	add s10, s6, a0
	add s11, s4, a0
	add t3, s3, a0
	lw t5, -60(s0)
	add t5, t5, a0
	sw t5, -32(s0)
	add t5, s1, a0
	sw t5, -56(s0)
	lw t5, -76(s0)
	add t5, t5, a0
	sw t5, -148(s0)
	lw t5, -116(s0)
	add t5, t5, a0
	sw t5, -152(s0)
	lw t5, -136(s0)
	add t5, t5, a0
	sw t5, -108(s0)
	lw t5, -36(s0)
	add t5, t5, a0
	sw t5, -124(s0)
	lw t5, -128(s0)
	add t5, t5, a0
	sw t5, -72(s0)
	lw t5, -140(s0)
	add t5, t5, a0
	sw t5, -100(s0)
	lw t5, -96(s0)
	add t5, t5, a0
	sw t5, -104(s0)
	lw t5, -88(s0)
	add t5, t5, a0
	sw t5, -156(s0)
	lw t5, -64(s0)
	add t5, t5, a0
	sw t5, -132(s0)
	lw t5, -112(s0)
	add t5, t5, a0
	sw t5, -144(s0)
	lw t5, -52(s0)
	add t5, t5, a0
	sw t5, -80(s0)
	lw t5, -20(s0)
	add t5, t5, a0
	sw t5, -44(s0)
	lw t5, -28(s0)
	add t5, t5, a0
	sw t5, -16(s0)
	lw t5, -48(s0)
	add t5, t5, a0
	sw t5, -120(s0)
	lw t5, -40(s0)
	add t5, t5, a0
	sw t5, -92(s0)
	lw t5, -68(s0)
	add t5, t5, a0
	sw t5, -84(s0)
	add t4, s2, s2
	add s2, s2, s2
	lw t5, -24(s0)
	add s2, t5, s2
	add s2, t3, t3
	add t3, t4, t4
	add t4, t0, t0
	add t0, t1, t1
	add t1, t2, t2
	add t2, t2, s11
	add t2, s9, s10
	add s2, t2, s8
	add t2, t2, s7
	add t2, t2, s5
	add t2, t2, s6
	add t2, t2, s4
	add t2, t2, s3
	lw t5, -60(s0)
	add t2, s1, t5
	lw t5, -76(s0)
	add s2, t2, t5
	lw t5, -116(s0)
	add t2, t2, t5
	lw t5, -136(s0)
	add t2, t2, t5
	lw t5, -36(s0)
	add t2, t2, t5
	lw t5, -128(s0)
	add t2, t2, t5
	lw t5, -140(s0)
	add t2, t2, t5
	lw t5, -88(s0)
	lw t6, -96(s0)
	add t2, t5, t6
	lw t5, -64(s0)
	add t5, t2, t5
	sw t5, -24(s0)
	lw t5, -112(s0)
	add t2, t2, t5
	lw t5, -52(s0)
	add t2, t2, t5
	lw t5, -20(s0)
	add t2, t2, t5
	lw t5, -28(s0)
	add t2, t2, t5
	lw t5, -48(s0)
	add t2, t2, t5
	lw t5, -68(s0)
	lw t6, -40(s0)
	add t2, t5, t6
	slli t3, a0, 1
	slli t4, a0, 1
	slli t0, a0, 1
	slli t1, a0, 1
	slli t2, a0, 1
	slli s11, a0, 1
	slli s10, a0, 1
	slli s9, a0, 1
	slli s8, a0, 1
	slli s7, a0, 1
	slli s5, a0, 1
	slli s6, a0, 1
	slli s4, a0, 1
	slli s3, a0, 1
	slli t5, a0, 1
	sw t5, -60(s0)
	slli s1, a0, 1
	slli t5, a0, 1
	sw t5, -76(s0)
	slli t5, a0, 1
	sw t5, -116(s0)
	slli t5, a0, 1
	sw t5, -136(s0)
	slli t5, a0, 1
	sw t5, -36(s0)
	slli t5, a0, 1
	sw t5, -128(s0)
	slli t5, a0, 1
	sw t5, -140(s0)
	slli t5, a0, 1
	sw t5, -96(s0)
	slli t5, a0, 1
	sw t5, -88(s0)
	slli t5, a0, 1
	sw t5, -64(s0)
	slli t5, a0, 1
	sw t5, -112(s0)
	slli t5, a0, 1
	sw t5, -52(s0)
	slli t5, a0, 1
	sw t5, -20(s0)
	slli t5, a0, 1
	sw t5, -28(s0)
	slli t5, a0, 1
	sw t5, -48(s0)
	slli t5, a0, 1
	sw t5, -40(s0)
	slli t5, a0, 1
	sw t5, -68(s0)
	add t4, t2, t2
	add t2, t2, t2
	lw t5, -12(s0)
	add t2, t5, t2
	add t2, t2, a0
	add t2, t2, a0
	add t2, t2, a0
	add t2, t2, a0
	add t2, t2, a0
	add t2, t2, a0
	add t2, a0, a0
	add t2, t2, a0
	add t2, t2, a0
	add t2, t2, a0
	add t2, t2, a0
	add t2, t2, a0
	add t2, t2, a0
	add t2, a0, a0
	add t2, t2, a0
	add t2, t2, a0
	add t2, t2, a0
	add t2, t2, a0
	add t2, t2, a0
	add t2, t2, a0
	add t2, a0, a0
	add t5, t2, a0
	sw t5, -12(s0)
	add t2, t2, a0
	add t2, t2, a0
	add t2, t2, a0
	add t2, t2, a0
	add t2, t2, a0
	add t2, a0, a0
	jal ra, echo
	addi a0, x0, 32
	jal ra, echo
	addi a0, x0, 31
	jal ra, echo
	addi a0, x0, 30
	jal ra, echo
	addi a0, x0, 29
	jal ra, echo
	addi a0, x0, 28
	jal ra, echo
	addi a0, x0, 27
	jal ra, echo
	addi a0, x0, 26
	jal ra, echo
	addi a0, x0, 25
	jal ra, echo
	addi a0, x0, 24
	jal ra, echo
	addi a0, x0, 23
	jal ra, echo
	addi a0, x0, 22
	jal ra, echo
	addi a0, x0, 21
	jal ra, echo
	addi a0, x0, 20
	jal ra, echo
	addi a0, x0, 19
	jal ra, echo
	addi a0, x0, 18
	jal ra, echo
	addi a0, x0, 17
	jal ra, echo
	addi a0, x0, 16
	jal ra, echo
	addi a0, x0, 15
	jal ra, echo
	addi a0, x0, 14
	jal ra, echo
	addi a0, x0, 13
	jal ra, echo
	addi a0, x0, 12
	jal ra, echo
	addi a0, x0, 11
	jal ra, echo
	addi a0, x0, 10
	jal ra, echo
	addi a0, x0, 9
	jal ra, echo
	addi a0, x0, 8
	jal ra, echo
	addi a0, x0, 7
	jal ra, echo
	addi a0, x0, 6
	jal ra, echo
	addi a0, x0, 5
	jal ra, echo
	addi a0, x0, 4
	jal ra, echo
	addi a0, x0, 3
	jal ra, echo
	addi a0, x0, 2
	jal ra, echo
	addi a0, x0, 1
main_return:
	lw ra, 156(sp)
	lw s0, 152(sp)
	addi sp, sp, 160
	jalr x0, ra, 0

