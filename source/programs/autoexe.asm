BITS 16
%INCLUDE "os.inc"
ORG autoexec_load_addr

;call os_reset_palette
;mov bh, 0x0f ; Background color
;call os_clear_screen

; Search for EXPLORER.BIN
    mov ax, explorer_bin_name
    call os_file_exists
    jc no_explorer

    mov cx, exit_addr
    jmp os_load_file_and_execute

no_explorer:
    mov si, no_explorer_error
    call os_print

    mov ax, no_explorer_error
    jmp os_kernel_panic

no_explorer_error: db "AUTOEXEC inoperable! Missing "
explorer_bin_name: db "EXPLORER.BIN",0