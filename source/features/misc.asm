os_get_api_ver:
    mov ax, API_VERSION
    ret

; Inputs
; AX - Error message location
os_kernel_panic:

    call os_cursor_off
    call os_reset_palette
    mov bh, 0x4f ; Background color
	call os_clear_screen
    mov si, kernel_panic
    call os_print
    mov si, ax
    call os_print

    jmp $ ; Goodbye cruel world :(

kernel_panic: db "Kernel Panic! System Halted.",10,13,0

os_exit:
    jmp exit_addr