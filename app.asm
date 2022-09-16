SECTION .data
  hello: db "Hello World!", 10  ;string to print
  helloLen: equ $-hello         ;Length of string

SECTION .text
  global _start       ;entry point for Linker

  _start:
    mov   rax,1         ; sys_write
    mov   rdi,1         ; stdout
    mov   rsi,hello     ; message to write
    mov   rdx,helloLen  ; message Length
    syscall             ; call kernel

    ; end program
    mov   rax,60        ; sys_exit
    mov   rdi,0         ; error code 0 (success)
    syscall             ; call kernel