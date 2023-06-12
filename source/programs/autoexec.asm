BITS 16
%INCLUDE "os.inc"
ORG 0x5000

call os_reset_palette
mov bh, 0x0f ; Background color
call os_clear_screen

mov si, hello
call os_print

jmp $

hello: db "Hello from external program!",0