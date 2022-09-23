# -----------------------------------------------------------------------------
# A 32-bit Linux application that writes the first 90 Fibonacci numbers.  It
# needs to be linked with a C library.
#
# Assemble and Link:
#     gcc fib.s
# -----------------------------------------------------------------------------

  .global main

  .text
main:
  push %ebx                    # we have to save this since we use it

  mov  $3, %ecx               # ecx will countdown to 0
  xor  %eax, %eax              # eax will hold the current number
  xor  %ebx, %ebx              # ebx will hold the next number
  inc  %ebx                    # ebx is originally 1

print:
  # We need to call printf, but we are using eax, ebx, and ecx.  printf
  # may destroy eax and ecx so we will save these before the call and
  # restore them afterwards.

  push %eax                    # caller-save register
  push %ecx                    # caller-save register

  mov  $format, %edi           # set 1st parameter (format)
  mov  %eax, %esi              # set 2nd parameter (current_number)
  xor  %eax, %eax              # because printf is varargs

  # Stack is already aligned because we pushed three 8 byte registers
  call printf                  # printf(format, current_number)

  pop  %ecx                    # restore caller-save register
  pop  %eax                    # restore caller-save register

  mov  %eax, %edx              # save the current number
  mov  %ebx, %eax              # next number is now current
  add  %edx, %ebx              # get the new next number
  dec  %ecx                    # count down
  jnz  print                   # if not done counting, do some more

  pop  %ebx                    # restore rbx before returning
  ret
format:
  .asciz  "%20ld\n"
