# ToyC 编译器

这是一个将 ToyC 语言编译成 RISC-V 汇编代码的简单编译器。

## 项目结构

- `lib/`: 编译器核心库
  - `lexer.mll`: 词法分析文件（Ocamllex工具对应文件）
  - `parser.mly`: 语法分析文件（Ocamlyacc工具对应文件）
  - `ast.ml`: 抽象语法树定义
  - `string_of_ast.ml`：存放抽象语法树转化为字符串的函数，用于调试输出
  - `optimizer.ml`：优化AST结构的模块
  - `ir.ml`：中间形式IR的模式定义
  - `irgen.ml`：中间形式生成器，将语法树AST转化为中间形式
  - `optimizer2.ml`：优化IR结构的模块
  - `codegen.ml`: 代码生成器（RISC-V 汇编），将中间形式转化为汇编
  - `tool.ml`：其他工具
- `bin/`: 编译器可执行文件
  - `main.ml`: 主程序
- `test/`: 测试文件，存放测试用源文件
  - `test_interpreter_project.ml`：用于批量测试的测试文件
- `test_results/`：测试文件的编译结果
- `test_build/`: 另外的一个测试文件夹

## ToyC 语言

ToyC 是 C 语言的一个简化子集，支持以下特性：

- 基本类型：`int` 和 `void`
- 函数定义和调用
- 变量声明和赋值
- 控制流语句：`if-else` 和 `while`
- `break` 和 `continue` 语句
- 表达式：算术运算、逻辑运算、关系运算等

## 构建和使用

### 依赖项

- OCaml (5.3.0 或更新版本)
- Dune 构建系统

### 构建项目

```bash
dune build
```

### 使用编译器

```bash
dune exec interpreter_project -- [specs]
```

本项目提供可选参数specs如下：

- `-i <filename>`：将`filename`作为输入流
- `-o <filename>`：将`filename`作为输出流
- `-ast`：将解析得到的AST输出到终端
- `-ir`：将解析得到的IR输出到终端
- `-opt`：启用优化程序（被忽略）

在默认无参数情况下，程序将从标准输入流中读取文件，并输出到标准输出流中，但是您可以使用参数或改变输入输出流的方法生成生成与输入文件同名但扩展名为 `.s` 的 RISC-V 汇编代码文件。

### 示例

如下代码为默认的结构，从标准输入流读取，并输出到标准输出流

```bash
dune exec interpreter_project
```

如下代码从文件中读取并且读出到文件

```bash
dune exec interpreter_project -- -i test/test.tc -o test_results/res.s
```



## 代码生成

中间形式生成器(`irgen.ml`)将抽象语法树AST转换为中间形式IR，代码生成器 (`codegen.ml`) 将中间形式IR转换为 RISC-V 汇编代码。这些模块的主要功能包括：

1. 寄存器分配：使用固定的寄存器分配方案
2. 栈帧管理：为局部变量和函数调用分配栈空间
3. 控制流翻译：将 ToyC 的控制流语句翻译为 RISC-V 的跳转指令
4. 表达式求值：将表达式翻译为 RISC-V 指令序列

生成的 RISC-V 汇编代码遵循标准的 RISC-V 调用约定，并可以使用标准的 RISC-V 工具链进行进一步的处理。
- Clarkson, M. R. (2021–2025). [OCaml Programming: Correct + Efficient + Beautiful](https://cs3110.github.io/textbook/)