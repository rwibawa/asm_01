# asm_01

Learn assembly language

* [Assembly Language in 100 seconds](https://youtu.be/4gwYkEK0gOk)
* [Netwide Assembler (NASM)](https://www.nasm.us/)
* [nasm github](https://github.com/netwide-assembler/nasm)
* [Web Assembly](https://webassembly.org/)
* [yasm](https://yasm.tortall.net/)
* [yasm github](https://github.com/yasm)
* [nasm vs gas](https://developer.ibm.com/articles/l-gas-nasm/)

## 1. `nasm` Code structure

```asm
section .bss
  ; variables

section .data
  ; constants

section .text
  global _start       ; entry point for Linker

  _start:             ; start here
```

## 2. Commands

```sh
# Install nasm in Ubuntu
$ sudo apt-get install -y nasm

$ nasm -f elf64 app.asm
$ ld app.o -o app
$ ./app
Hello World!
$ ll
-rwxr-xr-x 1 ryan ryan 8920 Sep 16 16:39 app*
-rw-r--r-- 1 ryan ryan  533 Sep 16 16:34 app.asm
-rw-r--r-- 1 ryan ryan  880 Sep 16 16:39 app.o
$ objdump -d -M intel -S app

app:     file format elf64-x86-64


Disassembly of section .text:

0000000000401000 <_start>:
  401000:       b8 01 00 00 00          mov    eax,0x1
  401005:       bf 01 00 00 00          mov    edi,0x1
  40100a:       48 be 00 20 40 00 00    movabs rsi,0x402000
  401011:       00 00 00 
  401014:       ba 0d 00 00 00          mov    edx,0xd
  401019:       0f 05                   syscall 
  40101b:       b8 3c 00 00 00          mov    eax,0x3c
  401020:       bf 00 00 00 00          mov    edi,0x0
  401025:       0f 05                   syscall

  
# With interrupt 0x80 instead of system call
$ nasm -f elf -l hello.lst hello.asm
$ gcc -o hello hello.o
/usr/bin/ld: i386 architecture of input file 'hello.o' is incompatible with i386:x86-64 output
collect2: error: ld returned 1 exit status
$ ld -o hello hello.o
ld: i386 architecture of input file 'hello.o' is incompatible with i386:x86-64 output
ld: warning: cannot find entry symbol _start; defaulting to 0000000000401000
```

## 3. Assembling:
GAS:
```sh
$ as –o program.o program.s
```

NASM:
```sh
$ nasm –f elf –o program.o program.asm
```

Linking (common to both kinds of assembler):
```sh
ld –o program program.o
```

Linking when an external C library is to be used:
```sh
ld --dynamic-linker /lib/ld-linux.so.2 -lc -o program program.o
```

## 4. `gas` - GNU Assembler
GAS, the GNU Assembler, is the default assembler for the GNU Operating System. It works on many different architectures and supports several assembly language syntaxes.

* [gas examples](https://cs.lmu.edu/~ray/notes/gasexamples/)

Assembling with `gcc`:
```sh
$ gcc -c hello-gas.s -o hello-gas1.o
$ ld hello-gas1.o -o hello-gas1
$ ./hello-gas1 
Hello, world
$ ll
-rwxr-xr-x 1 ryan ryan 8920 Sep 16 16:39 app*
-rw-r--r-- 1 ryan ryan  543 Sep 16 16:49 app.asm
-rw-r--r-- 1 ryan ryan 1309 Sep 16 16:47 app.lst
-rw-r--r-- 1 ryan ryan  880 Sep 16 16:47 app.o
-rw-r--r-- 1 ryan ryan  998 Sep 18 23:49 hello-gas.s
-rwxr-xr-x 1 ryan ryan 4744 Sep 18 23:50 hello-gas1*
-rw-r--r-- 1 ryan ryan  872 Sep 18 23:49 hello-gas1.o
-rw-r--r-- 1 ryan ryan  955 Sep 16 16:34 hello.asm
-rw-r--r-- 1 ryan ryan 1968 Sep 16 16:38 hello.lst
-rw-r--r-- 1 ryan ryan  640 Sep 16 16:38 hello.o
```

Assembling with linux `as`:
```sh
$ which as
/usr/bin/as
$ ll /usr/bin/as
lrwxrwxrwx 1 root root 19 Oct 20  2021 /usr/bin/as -> x86_64-linux-gnu-as*

$ as -o hello-gas2.o hello-gas.s
$ ld hello-gas2.o -o hello-gas2
$ ./hello-gas2
Hello, world
```

Size comparison:
```sh
$ ll
-rwxr-xr-x 1 ryan ryan 8920 Sep 16 16:39 app*
-rw-r--r-- 1 ryan ryan  543 Sep 16 16:49 app.asm
-rw-r--r-- 1 ryan ryan 1309 Sep 16 16:47 app.lst
-rw-r--r-- 1 ryan ryan  880 Sep 16 16:47 app.o
-rw-r--r-- 1 ryan ryan  998 Sep 18 23:49 hello-gas.s
-rwxr-xr-x 1 ryan ryan 4744 Sep 18 23:50 hello-gas1*
-rw-r--r-- 1 ryan ryan  872 Sep 18 23:49 hello-gas1.o
-rwxr-xr-x 1 ryan ryan 4744 Sep 18 23:55 hello-gas2*
-rw-r--r-- 1 ryan ryan  872 Sep 18 23:55 hello-gas2.o
-rw-r--r-- 1 ryan ryan  955 Sep 16 16:34 hello.asm
-rw-r--r-- 1 ryan ryan 1968 Sep 16 16:38 hello.lst
-rw-r--r-- 1 ryan ryan  640 Sep 16 16:38 hello.o
```

### Working with the C Library
Find the path of the dynamic linker:
```sh
$ gcc -v hello_world.c |& grep 'collect2' | tr ' ' '\n'
```
You might also need `-lgcc` and `-lgcc_s`.

Assembling with `as` and link with `ld`:
```sh
$ as -o hola.o hola.s
$ ld -dynamic-linker \
/lib64/ld-linux-x86-64.so.2 \
/usr/lib/x86_64-linux-gnu/crt1.o \
/usr/lib/x86_64-linux-gnu/crti.o \
-lc hola.o \
/usr/lib/x86_64-linux-gnu/crtn.o \
-o hola

$ ./hola
Hola, mundo

# Fibonacci
$ as -o fib.o fib.s 
$ ld -dynamic-linker \
/lib64/ld-linux-x86-64.so.2 \
/usr/lib/x86_64-linux-gnu/crt1.o \
/usr/lib/x86_64-linux-gnu/crti.o \
-lc fib.o \
/usr/lib/x86_64-linux-gnu/crtn.o \
-o fib
```

### Mixing C and Assembly Language
This 64-bit program is a very simple function that takes in three 64-bit integer parameters and returns the maximum value. It shows how to extract integer parameters: They will have been pushed on the stack so that on entry to the function, they will be in `rdi`, `rsi`, and `rdx`, respectively. The return value is an integer so it gets returned in `rax`.

```sh
$ gcc -std=c99 callmaxofthree.c maxofthree.s -o maxofthree
$ ./maxofthree 
1
2
3
4
5
6
```

## Calling Conventions for 64-bit C Code

* [AMD64 ABI Reference](docs/abi.pdf)
* [System V ABI - gitlab](https://gitlab.com/x86-psABIs/x86-64-ABI)

The most important points are (again, for 64-bit Linux, not Windows):

* From left to right, pass as many parameters as will fit in registers. The order in which registers are allocated, are:
  * For **integers** and **pointers**, `rdi`, `rsi`, `rdx`, `rcx`, `r8`, `r9`.
  * For **floating-point** (float, double), `xmm0`, `xmm1`, `xmm2`, `xmm3`, `xmm4`, `xmm5`, `xmm6`, `xmm7`
* Additional parameters are pushed on the stack, right to left, and are removed by the caller after the call.
* After the parameters are pushed, the call instruction is made, so when the called function gets control, the return address is at (%rsp), the first memory parameter is at 8(%rsp), etc.
* **THE STACK POINTER %RSP MUST BE ALIGNED TO A 16-BYTE BOUNDARY BEFORE MAKING A CALL**. Fine, but the process of making a call pushes the return address (8 bytes) on the stack, so when a function gets control, `%rsp` is not aligned. You have to make that extra space yourself, by pushing something or subtracting 8 from `%rsp`.
* The only registers that the called function is required to preserve (the calle-save registers) are: `rbp`, `rbx`, `r12`, `r13`, `r14`, `r15`. All others are free to be changed by the called function.
* The callee is also supposed to save the control bits of the **XMCSR** and the _x87 control word_, but x87 instructions are rare in 64-bit code so you probably don't have to worry about this.
* Integers are returned in `rax` or `rdx:rax`, and floating point values are returned in `xmm0` or `xmm1:xmm0`.


## assembler syntaxes:

1. nasm
    NASM syntax is the most full-featured syntax supported by Yasm. Yasm is nearly 100% compatible with NASM for 16-bit and 32-bit x86 code. Yasm additionally supports 64-bit AMD64 code with Yasm extensions to the NASM syntax. For more details see Part II.

2. gas
    The GNU Assembler (GAS) is the de-facto cross-platform assembler for modern Unix systems, and is used as the backend for the GCC compiler. Yasm’s support for GAS syntax is moderately good, although immature: not all directives are supported, and only 32-bit x86 and AMD64 architectures are supported. There is also no support for the GAS preprocessor. Despite these limitations, Yasm’s GAS syntax support is good enough to handle essentially all x86 and AMD64 GCC compiler output. For more details see Part III.