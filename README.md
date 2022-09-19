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
ld –-dynamic-linker /lib/ld-linux.so.2 –lc –o program program.o
```

## 4. `gas` - GNU Assembler
GAS, the GNU Assembler, is the default assembler for the GNU Operating System. It works on many different architectures and supports several assembly language syntaxes.

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

## assembler syntaxes:

1. nasm
    NASM syntax is the most full-featured syntax supported by Yasm. Yasm is nearly 100% compatible with NASM for 16-bit and 32-bit x86 code. Yasm additionally supports 64-bit AMD64 code with Yasm extensions to the NASM syntax. For more details see Part II.

2. gas
    The GNU Assembler (GAS) is the de-facto cross-platform assembler for modern Unix systems, and is used as the backend for the GCC compiler. Yasm’s support for GAS syntax is moderately good, although immature: not all directives are supported, and only 32-bit x86 and AMD64 architectures are supported. There is also no support for the GAS preprocessor. Despite these limitations, Yasm’s GAS syntax support is good enough to handle essentially all x86 and AMD64 GCC compiler output. For more details see Part III.