.globl main
.text
fibonacci:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, x0, 1
	slt t2, t1, t0
	sub t3, t2, x0
	sltiu t3, t3, 1
	beq t3, x0, else_82
	addi a0, t0, 0
	jal x0, fibonacci_return
else_82:
	addi t3, x0, 1
	sub t2, t0, t3
	addi a0, t2, 0
	jal ra, fibonacci
	addi t2, a0, 0
	addi t3, x0, 2
	sub t1, t0, t3
	addi a0, t1, 0
	jal ra, fibonacci
	addi t1, a0, 0
	add t0, t2, t1
	addi a0, t0, 0
	jal x0, fibonacci_return
endif_83:

fibonacci_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

gcd:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, a1, 0
	addi t2, x0, 0
	sub t3, t1, t2
	sub t4, t3, x0
	sltiu t4, t4, 1
	beq t4, x0, else_84
	addi a0, t0, 0
	jal x0, gcd_return
else_84:
endif_85:
	rem t4, t0, t1
	addi a0, t1, 0
	addi a1, t4, 0
	jal ra, gcd
	addi t4, a0, 0
	addi a0, t4, 0
	jal x0, gcd_return

gcd_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

isPrime:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, x0, 1
	slt t2, t1, t0
	sub t3, t2, x0
	sltiu t3, t3, 1
	beq t3, x0, else_86
	addi a0, x0, 0
	jal x0, isPrime_return
else_86:
endif_87:
	addi t3, x0, 3
	slt t2, t3, t0
	sub t1, t2, x0
	sltiu t1, t1, 1
	beq t1, x0, else_88
	addi a0, x0, 1
	jal x0, isPrime_return
else_88:
endif_89:
	addi t1, x0, 2
	rem t2, t0, t1
	addi t3, x0, 0
	sub t1, t2, t3
	sub t4, t1, x0
	sltiu t4, t4, 1
	addi t2, x0, 3
	rem t1, t0, t2
	addi t3, x0, 0
	sub t2, t1, t3
	sub s1, t2, x0
	sltiu s1, s1, 1
	bne t4, x0, or_true_90
	bne s1, x0, or_true_90
	addi t4, x0, 0
	jal x0, or_end_91
or_true_90:
	addi t4, x0, 1
or_end_91:
	beq t4, x0, else_92
	addi a0, x0, 0
	jal x0, isPrime_return
else_92:
endif_93:
	addi t4, x0, 5
while_start_94:
	mul s1, t4, t4
	slt t2, t0, s1
	sub t1, t2, x0
	sltiu t1, t1, 1
	beq t1, x0, while_end_96
	rem t2, t0, t4
	addi t1, x0, 0
	sub s1, t2, t1
	sub t3, s1, x0
	sltiu t3, t3, 1
	addi t2, x0, 2
	add s1, t4, t2
	rem t1, t0, s1
	addi t2, x0, 0
	sub t0, t1, t2
	sub s1, t0, x0
	sltiu s1, s1, 1
	bne t3, x0, or_true_97
	bne s1, x0, or_true_97
	addi t3, x0, 0
	jal x0, or_end_98
or_true_97:
	addi t3, x0, 1
or_end_98:
	beq t3, x0, else_99
	addi a0, x0, 0
	jal x0, isPrime_return
else_99:
endif_100:
	addi t3, x0, 6
	add s1, t4, t3
	addi t4, s1, 0
while_continue_95:
	jal x0, while_start_94
while_end_96:
	addi a0, x0, 1
	jal x0, isPrime_return

isPrime_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

factorial:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, x0, 1
while_start_101:
	addi t2, x0, 0
	slt t3, t2, t0
	beq t3, x0, while_end_103
	mul t2, t1, t0
	addi t1, t2, 0
	addi t3, x0, 1
	sub t2, t0, t3
	addi t0, t2, 0
while_continue_102:
	jal x0, while_start_101
while_end_103:
	addi a0, t1, 0
	jal x0, factorial_return

factorial_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

combination:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, a1, 0
	slt t2, t0, t1
	beq t2, x0, else_104
	addi a0, x0, 0
	jal x0, combination_return
else_104:
endif_105:
	addi t2, x0, 0
	sub t3, t1, t2
	sub t4, t3, x0
	sltiu t4, t4, 1
	sub t2, t1, t0
	sub t3, t2, x0
	sltiu t3, t3, 1
	bne t4, x0, or_true_106
	bne t3, x0, or_true_106
	addi t4, x0, 0
	jal x0, or_end_107
or_true_106:
	addi t4, x0, 1
or_end_107:
	beq t4, x0, else_108
	addi a0, x0, 1
	jal x0, combination_return
else_108:
endif_109:
	addi a0, t0, 0
	jal ra, factorial
	addi t4, a0, 0
	addi a0, t1, 0
	jal ra, factorial
	addi t3, a0, 0
	sub t2, t0, t1
	addi a0, t2, 0
	jal ra, factorial
	addi t2, a0, 0
	mul t0, t3, t2
	div t1, t4, t0
	addi a0, t1, 0
	jal x0, combination_return

combination_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

power:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, a1, 0
	addi t2, x0, 1
while_start_110:
	addi t3, x0, 0
	slt t4, t3, t1
	beq t4, x0, while_end_112
	addi t3, x0, 2
	rem t4, t1, t3
	addi s1, x0, 1
	sub t3, t4, s1
	sub s2, t3, x0
	sltiu s2, s2, 1
	beq s2, x0, else_113
	mul t3, t2, t0
	addi t2, t3, 0
	jal x0, endif_114
else_113:
endif_114:
	mul t3, t0, t0
	addi t0, t3, 0
	srli t0, t1, 1
	addi t1, t0, 0
while_continue_111:
	jal x0, while_start_110
while_end_112:
	addi a0, t2, 0
	jal x0, power_return

power_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

complexFunction:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, a1, 0
	addi t2, a2, 0
	addi t3, x0, 0
	slt t4, t1, t0
	slt s1, t2, t1
	beq t4, x0, and_false_115
	beq s1, x0, and_false_115
	addi t4, x0, 1
	jal x0, and_end_116
and_false_115:
	addi t4, x0, 0
and_end_116:
	sub s1, t4, x0
	sltiu s1, s1, 1
	beq s1, x0, else_117
	mul t4, t0, t1
	addi s1, x0, -1
	add s2, t2, s1
	addi s3, x0, 0
	sub s1, s3, s2
	sub s4, t4, s1
	addi t3, s4, 0
	jal x0, endif_118
else_117:
	slt s4, t0, t2
	sub t4, s4, x0
	sltiu t4, t4, 1
	slt s1, t2, t1
	bne t4, x0, or_true_119
	bne s1, x0, or_true_119
	addi t4, x0, 0
	jal x0, or_end_120
or_true_119:
	addi t4, x0, 1
or_end_120:
	beq t4, x0, else_121
	sub s1, t2, t1
	addi t4, x0, -2
	sub s4, s1, t4
	mul s2, t0, s4
	addi t3, s2, 0
	jal x0, endif_122
else_121:
	slt s2, t1, t0
	sub s4, s2, x0
	sltiu s4, s4, 1
	slt s1, t0, t2
	sub s2, s1, x0
	sltiu s2, s2, 1
	beq s4, x0, and_false_123
	beq s2, x0, and_false_123
	addi s4, x0, 1
	jal x0, and_end_124
and_false_123:
	addi s4, x0, 0
and_end_124:
	slt s2, t2, t1
	sub s1, s2, x0
	sltiu s1, s1, 1
	bne s4, x0, or_true_125
	bne s1, x0, or_true_125
	addi s4, x0, 0
	jal x0, or_end_126
or_true_125:
	addi s4, x0, 1
or_end_126:
	beq s4, x0, else_127
	mul s1, t1, t0
	addi s4, x0, -3
	add s2, t2, s4
	addi t4, x0, 0
	sub s4, t4, s2
	sub s3, s1, s4
	addi t3, s3, 0
	jal x0, endif_128
else_127:
	slt s3, t2, t1
	slt s1, t0, t2
	slt s4, t1, t0
	sub s2, s4, x0
	sltiu s2, s2, 1
	beq s1, x0, and_false_129
	beq s2, x0, and_false_129
	addi s1, x0, 1
	jal x0, and_end_130
and_false_129:
	addi s1, x0, 0
and_end_130:
	bne s3, x0, or_true_131
	bne s1, x0, or_true_131
	addi s3, x0, 0
	jal x0, or_end_132
or_true_131:
	addi s3, x0, 1
or_end_132:
	beq s3, x0, else_133
	sub s1, t2, t0
	addi s3, x0, -4
	sub s2, s1, s3
	mul s4, t1, s2
	addi t3, s4, 0
	jal x0, endif_134
else_133:
	slt s4, t0, t2
	sub s2, t1, t0
	sub s1, s2, x0
	sltu s1, x0, s1
	bne s4, x0, or_true_135
	bne s1, x0, or_true_135
	addi s4, x0, 0
	jal x0, or_end_136
or_true_135:
	addi s4, x0, 1
or_end_136:
	sub s1, s4, x0
	sltiu s1, s1, 1
	sub s2, t0, t1
	sub s4, s2, x0
	sltiu s4, s4, 1
	beq s1, x0, and_false_137
	beq s4, x0, and_false_137
	addi s1, x0, 1
	jal x0, and_end_138
and_false_137:
	addi s1, x0, 0
and_end_138:
	beq s1, x0, else_139
	mul s4, t2, t0
	addi s1, x0, -5
	add s2, t1, s1
	sub s3, s4, s2
	addi t3, s3, 0
	jal x0, endif_140
else_139:
	addi s3, x0, 0
	sub s4, s3, t0
	sub s2, t1, s4
	addi t0, x0, -6
	sub t1, s2, t0
	mul s4, t2, t1
	addi t3, s4, 0
endif_140:
endif_134:
endif_128:
endif_122:
endif_118:
	addi s4, x0, 0
while_start_141:
	addi t2, x0, 10
	slt t1, s4, t2
	beq t1, x0, while_end_143
	addi t2, x0, 1
	add t1, s4, t2
	addi s4, t1, 0
	addi t2, x0, 3
	rem t1, s4, t2
	addi s2, x0, 0
	sub t2, t1, s2
	sub t0, t2, x0
	sltiu t0, t0, 1
	beq t0, x0, else_144
	add t2, t3, s4
	addi t3, t2, 0
	jal x0, endif_145
else_144:
	addi t2, x0, 3
	rem t0, s4, t2
	addi t1, x0, 1
	sub t2, t0, t1
	sub s2, t2, x0
	sltiu s2, s2, 1
	beq s2, x0, else_146
	sub t2, t3, s4
	addi t3, t2, 0
	jal x0, endif_147
else_146:
	slli t2, t3, 1
	addi t3, t2, 0
	addi s4, x0, 50
	slt t2, t3, s4
	beq t2, x0, else_148
	jal x0, while_continue_142
else_148:
endif_149:
	addi t2, x0, 1
	add s4, t3, t2
	addi t3, s4, 0
	addi t2, x0, 100
	slt s4, t2, t3
	beq s4, x0, else_150
	jal x0, while_end_143
else_150:
endif_151:
endif_147:
endif_145:
while_continue_142:
	jal x0, while_start_141
while_end_143:
	addi a0, t3, 0
	jal x0, complexFunction_return

complexFunction_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

shortCircuit:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, a1, 0
	addi t2, x0, 0
	slt t3, t2, t0
	div t4, t1, t0
	addi t2, x0, 2
	slt s1, t2, t4
	beq t3, x0, and_false_152
	beq s1, x0, and_false_152
	addi t3, x0, 1
	jal x0, and_end_153
and_false_152:
	addi t3, x0, 0
and_end_153:
	beq t3, x0, else_154
	jal x0, endif_155
else_154:
endif_155:
	addi t3, x0, 0
	slt s1, t0, t3
	addi t4, x0, 0
	slt t0, t1, t4
	bne s1, x0, or_true_156
	bne t0, x0, or_true_156
	addi s1, x0, 0
	jal x0, or_end_157
or_true_156:
	addi s1, x0, 1
or_end_157:
	beq s1, x0, else_158
	jal x0, endif_159
else_158:
endif_159:
	addi a0, x0, 0
	jal x0, shortCircuit_return

shortCircuit_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

nestedLoopsAndConditions:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, x0, 0
	addi t2, x0, 0
while_start_160:
	slt t3, t2, t0
	beq t3, x0, while_end_162
	addi t0, x0, 0
while_start_163:
	slt t3, t0, t2
	beq t3, x0, while_end_165
	add t4, t2, t0
	addi t3, x0, 2
	rem s1, t4, t3
	addi s2, x0, 0
	sub t4, s1, s2
	sub t3, t4, x0
	sltiu t3, t3, 1
	beq t3, x0, else_166
	mul t4, t2, t0
	sub t3, t1, t4
	addi t1, t3, 0
	jal x0, endif_167
else_166:
	mul t3, t2, t0
	add t4, t1, t3
	addi t1, t4, 0
	addi t3, x0, 0
	slt t4, t1, t3
	beq t4, x0, else_168
	addi t3, x0, 0
	addi t1, t3, 0
	jal x0, while_continue_164
else_168:
endif_169:
endif_167:
	addi t3, x0, 1053
	slt t4, t3, t1
	beq t4, x0, else_170
	jal x0, while_end_165
else_170:
endif_171:
	addi t4, x0, 1
	add t3, t0, t4
	addi t0, t3, 0
while_continue_164:
	jal x0, while_start_163
while_end_165:
	addi t3, x0, 913
	slt t0, t3, t1
	beq t0, x0, else_172
	jal x0, while_end_162
else_172:
endif_173:
	addi t0, x0, 1
	add t3, t2, t0
	addi t2, t3, 0
while_continue_161:
	jal x0, while_start_160
while_end_162:
	addi a0, t1, 0
	jal x0, nestedLoopsAndConditions_return

nestedLoopsAndConditions_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

func1:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, a1, 0
	addi t2, a2, 0
	addi t3, x0, 0
	sub t4, t2, t3
	sub s1, t4, x0
	sltiu s1, s1, 1
	beq s1, x0, else_174
	mul t4, t0, t1
	addi a0, t4, 0
	jal x0, func1_return
else_174:
	sub t4, t1, t2
	addi s1, x0, 0
	addi a0, t0, 0
	addi a1, t4, 0
	addi a2, s1, 0
	jal ra, func1
	addi s1, a0, 0
	addi a0, s1, 0
	jal x0, func1_return
endif_175:

func1_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

func2:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, a1, 0
	beq t1, x0, else_176
	rem t2, t0, t1
	addi t3, x0, 0
	addi a0, t2, 0
	addi a1, t3, 0
	jal ra, func2
	addi t3, a0, 0
	addi a0, t3, 0
	jal x0, func2_return
else_176:
	addi a0, t0, 0
	jal x0, func2_return
endif_177:

func2_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

func3:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, a1, 0
	addi t2, x0, 0
	sub t3, t1, t2
	sub t4, t3, x0
	sltiu t4, t4, 1
	beq t4, x0, else_178
	addi t3, x0, 1
	add t4, t0, t3
	addi a0, t4, 0
	jal x0, func3_return
else_178:
	add t4, t0, t1
	addi t3, x0, 0
	addi a0, t4, 0
	addi a1, t3, 0
	jal ra, func3
	addi t3, a0, 0
	addi a0, t3, 0
	jal x0, func3_return
endif_179:

func3_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

func4:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, a1, 0
	addi t2, a2, 0
	beq t0, x0, else_180
	addi a0, t1, 0
	jal x0, func4_return
else_180:
	addi a0, t2, 0
	jal x0, func4_return
endif_181:

func4_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

func5:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, x0, 0
	sub t2, t1, t0
	addi a0, t2, 0
	jal x0, func5_return

func5_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

func6:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	addi t1, a1, 0
	beq t0, x0, and_false_182
	beq t1, x0, and_false_182
	addi t0, x0, 1
	jal x0, and_end_183
and_false_182:
	addi t0, x0, 0
and_end_183:
	beq t0, x0, else_184
	addi a0, x0, 1
	jal x0, func6_return
else_184:
	addi a0, x0, 0
	jal x0, func6_return
endif_185:

func6_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

func7:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t0, a0, 0
	sub t1, t0, x0
	sltiu t1, t1, 1
	beq t1, x0, else_186
	addi a0, x0, 1
	jal x0, func7_return
else_186:
	addi a0, x0, 0
	jal x0, func7_return
endif_187:

func7_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

nestedCalls:
	addi sp, sp, -16
	sw s0, 8(sp)
	addi s0, sp, 16
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
	addi s6, x0, 2
	addi a0, s6, 0
	jal ra, func7
	addi s6, a0, 0
	addi s7, x0, 8
	addi a0, s7, 0
	jal ra, func5
	addi s7, a0, 0
	addi a0, s6, 0
	addi a1, s7, 0
	jal ra, func6
	addi s7, a0, 0
	addi s6, x0, 8
	addi a0, s7, 0
	addi a1, s6, 0
	jal ra, func2
	addi s6, a0, 0
	addi s7, x0, 9
	addi a0, s6, 0
	addi a1, s7, 0
	jal ra, func3
	addi s7, a0, 0
	addi a0, s7, 0
	jal ra, func5
	addi s7, a0, 0
	addi a0, t1, 0
	jal ra, func5
	addi s6, a0, 0
	addi a0, t3, 0
	jal ra, func7
	addi s8, a0, 0
	addi a0, t2, 0
	addi a1, s8, 0
	jal ra, func6
	addi s8, a0, 0
	addi a0, s1, 0
	jal ra, func7
	addi s9, a0, 0
	addi a0, t4, 0
	addi a1, s9, 0
	jal ra, func2
	addi s9, a0, 0
	addi a0, s6, 0
	addi a1, s8, 0
	addi a2, s9, 0
	jal ra, func4
	addi s9, a0, 0
	addi a0, s9, 0
	addi a1, s2, 0
	jal ra, func3
	addi s9, a0, 0
	addi a0, s9, 0
	addi a1, s3, 0
	jal ra, func2
	addi s9, a0, 0
	addi a0, s5, 0
	jal ra, func7
	addi s8, a0, 0
	addi a0, s4, 0
	addi a1, s8, 0
	jal ra, func3
	addi s8, a0, 0
	addi s6, x0, 2
	addi a0, s9, 0
	addi a1, s8, 0
	addi a2, s6, 0
	jal ra, func1
	addi s6, a0, 0
	addi a0, s7, 0
	addi a1, t0, 0
	addi a2, s6, 0
	jal ra, func4
	addi s6, a0, 0
	addi s7, x0, 8
	addi s8, x0, 8
	addi a0, s8, 0
	jal ra, func7
	addi s8, a0, 0
	addi s9, x0, 9
	addi a0, s8, 0
	addi a1, s9, 0
	jal ra, func3
	addi s9, a0, 0
	addi a0, s7, 0
	addi a1, s9, 0
	jal ra, func2
	addi s9, a0, 0
	addi a0, s6, 0
	addi a1, s9, 0
	jal ra, func3
	addi s9, a0, 0
	addi a0, s9, 0
	addi a1, t0, 0
	addi a2, t1, 0
	jal ra, func1
	addi t1, a0, 0
	addi a0, t1, 0
	addi a1, t2, 0
	jal ra, func2
	addi t2, a0, 0
	addi a0, s1, 0
	jal ra, func5
	addi s1, a0, 0
	addi a0, t4, 0
	addi a1, s1, 0
	jal ra, func3
	addi s1, a0, 0
	addi a0, s2, 0
	jal ra, func5
	addi s2, a0, 0
	addi a0, s1, 0
	addi a1, s2, 0
	jal ra, func2
	addi s2, a0, 0
	addi a0, s4, 0
	jal ra, func7
	addi s4, a0, 0
	addi a0, s2, 0
	addi a1, s3, 0
	addi a2, s4, 0
	jal ra, func1
	addi s4, a0, 0
	addi a0, s5, 0
	jal ra, func5
	addi s5, a0, 0
	addi a0, s4, 0
	addi a1, s5, 0
	jal ra, func2
	addi s5, a0, 0
	addi s4, x0, 2
	addi a0, s5, 0
	addi a1, s4, 0
	jal ra, func3
	addi s4, a0, 0
	addi a0, t2, 0
	addi a1, t3, 0
	addi a2, s4, 0
	jal ra, func1
	addi s4, a0, 0
	addi a0, s4, 0
	jal x0, nestedCalls_return

nestedCalls_return:
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

main:
	addi sp, sp, -16
	sw ra, 12(sp)
	sw s0, 8(sp)
	addi s0, sp, 16
	addi t5, x0, 0
	sw t5, -4(s0)
	addi t1, x0, 12
	addi a0, t1, 0
	jal ra, fibonacci
	addi t1, a0, 0
	addi t2, x0, 22
	addi t3, x0, 15
	addi a0, t2, 0
	addi a1, t3, 0
	jal ra, gcd
	addi t3, a0, 0
	addi t2, x0, 17
	addi a0, t2, 0
	jal ra, isPrime
	addi t2, a0, 0
	addi t4, x0, 8
	addi a0, t4, 0
	jal ra, factorial
	addi t4, a0, 0
	addi s1, x0, 7
	addi s2, x0, 3
	addi a0, s1, 0
	addi a1, s2, 0
	jal ra, combination
	addi s2, a0, 0
	addi s1, x0, 3
	addi s3, x0, 11
	addi a0, s1, 0
	addi a1, s3, 0
	jal ra, power
	addi s3, a0, 0
	addi s1, x0, 3
	addi s4, x0, 5
	addi s5, x0, 1
	addi a0, s1, 0
	addi a1, s4, 0
	addi a2, s5, 0
	jal ra, complexFunction
	addi s5, a0, 0
	addi s5, x0, -5
	addi s4, x0, 10
	addi a0, s5, 0
	addi a1, s4, 0
	jal ra, shortCircuit
	addi s4, a0, 0
	addi s4, x0, 10
	addi a0, s4, 0
	jal ra, nestedLoopsAndConditions
	addi t5, a0, 0
	sw t5, -8(s0)
	addi s5, x0, 1
	addi s1, x0, 2
	addi s6, x0, 3
	addi s7, x0, 4
	addi s8, x0, 5
	addi s9, x0, 6
	addi s10, x0, 7
	addi s11, x0, 8
	addi t0, x0, 9
	addi s4, x0, 10
	addi sp, sp, -8
	sw s4, 0(sp)
	sw t0, 4(sp)
	addi a0, s5, 0
	addi a1, s1, 0
	addi a2, s6, 0
	addi a3, s7, 0
	addi a4, s8, 0
	addi a5, s9, 0
	addi a6, s10, 0
	addi a7, s11, 0
	jal ra, nestedCalls
	addi s11, a0, 0
	addi sp, sp, 8
	add s11, t1, t3
	add s10, s11, t2
	add t1, s10, t4
	sub t2, t1, s2
	add t4, t2, s3
	lw t5, -8(s0)
	sub s2, t4, t5
	addi s3, x0, 256
	rem t4, s2, s3
	addi t5, t4, 0
	sw t5, -4(s0)
	lw t5, -4(s0)
	addi a0, t5, 0
	jal x0, main_return

main_return:
	lw ra, 12(sp)
	lw s0, 8(sp)
	addi sp, sp, 16
	jalr x0, ra, 0

