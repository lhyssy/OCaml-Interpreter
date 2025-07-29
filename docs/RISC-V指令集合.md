#### **R型指令包括加法、减法、逻辑运算、移位运算示，例如下。**

```
add a0, a1, a2  //a0 = a1 + a2
sub a0, a1, a2  //a0 = a1 - a2
sll a0, a1, a2  //a0 = a1 << a2(低位补0)
srl a0, a1, a2  //a0 = a1 >> a2(高位补0）
sra a0, a1, a2  //a0 = a1 >> a2 (算术右移，高位补原来的符号位)
slt a0, a1, a2  //a1 < a2 ? a0 = 1 : a0 = 0
xor a0, a1, a2  //a0 = a1 ^ a2
or  a0, a1, a2  //a0 = a1 | a2
and a0, a1, a2  //a0 = a1 & a2
```

#### I型指令示例

```
addi a0, a1, 0x5  //a0 = a1 + 0x5
subi a0, a1, 0x05  //a0 = a1 - 0x05
slli a0, a1, 0x05  //a0 = a1 << 0x05(低位补0)
srli a0, a1, 0x05  //a0 = a1 >> 0x05(高位补0）
srai a0, a1, 0x05  //a0 = a1 >> 0x05 (算术右移，高位补原来的符号位)
slti a0, a1, 0x05  //a1 < 0x05 ? a0 = 1 : a0 = 0
xori a0, a1, 0x05  //a0 = a1 ^ 0x05
ori a0, a1, 0x05   //a0 = a1 | 0x05
andi a0, a1, 0x05  //a0 = a1 & 0x05
lb x10,  0(x1)  //将x1的值加上0,将这个值作为地址， 取出这个地址所对应的内存中的值， 将这个值赋值给x10(取出的是8位数值)
lh x10,  0(x1)  //从内存中取出16位数值
lw x10, 0(x1)  //从内存中取出32位数值
lbu x10, 0(x1) //从内存中取出8位无符号数值
lhu x10, 0(x1) //从内存中取出16位无符号数值
```

####  S型指令

```
示例：
sb  x10, 0(x1)  //x1的值加上0,将这个值作为地址， 将x10的值存储到上述地址所对应的内存中去 (只会将x10的值的低8位写入)
sh  x10, 0(x1)  //只会将x10的值的低16位写入
sw  x10, 0(x1)  //只会将x10的值的低32位写入
```

#### B型指令

```
示例：
beq a1,a2,Label   //if(a1==a2){goto Label;}
bne a1,a2,Label   //if(a1!=a2){goto Label;}
blt a1,a2,Label   //if(a1< a2){goto Label;}
bgt a1,a2,Label   //if(a1> a2){goto Label;}
bge a1,a2,Label   //if(a1<=a2){goto Label;}
ble a1,a2,Label   //if(a1>=a2){goto Label;}
```

#### U型指令

```
示例：
lui  x10, 0x65432 //得到立即数的高20位，低位补0，立即数范围为：0x00~0xFFFFF
```

#### J型指令

```
示例：
jal ra, symbol    // 跳转到Symbol中去, 并把ra设置成返回地址 Symbol 可以是自定义的Label ,也可以是某个函数名
jal ra, 100       // 跳转到pc + 100 * 2的地方中去, 并把ra设置成返回地址  pc相对寻址，对应的是位置无关代码（PIC)
jalr ra, 40(x10)  // 跳转到x10+40 的地方中去, 并把ra设置成返回地址x10+40必须是绝对地址，指向内存中某个确定的地方（往往是函数的开头），非PIC
```