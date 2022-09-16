# asm_01

Learn assembly language

* [Assembly Language in 100 seconds](https://youtu.be/4gwYkEK0gOk)
* [Netwide Assembler (NASM)](https://www.nasm.us/)
* [nasm github](https://github.com/netwide-assembler/nasm)
* [Web Assembly](https://webassembly.org/)

## 1. Code structure

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

  

$ nasm -f elf -l hello.lst hello.asm
$ gcc -o hello hello.o
$ ./hello
```