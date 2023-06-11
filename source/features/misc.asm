os_get_api_ver:
    mov ax, API_VERSION
    ret

; Inputs
; AX - Error message location
os_fatal_error:



    jmp $ ; Goodbye cruel world :(

kernel_panic: db "Kernel Panic! System Halted.",0