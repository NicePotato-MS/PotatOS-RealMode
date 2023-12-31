BITS 16
CPU 386

%DEFINE POTATOS_VERSION '0.1.00'
%DEFINE API_VERSION 1

program_load_addr               equ 0x8000
disk_buffer	                    equ	0x6000
exit_addr                       equ 0x4800
autoexec_load_addr              equ 0x4000

; another thanks to MikeOS for some of this


jmp os_start                    ;0000h
jmp os_print                    ;0003h
jmp os_cursor_off               ;0006h
jmp os_cursor_on                ;0009h
jmp os_set_cursor_pos           ;000Ch
jmp os_draw_box                 ;000Fh
jmp os_clear_screen             ;0012h
jmp os_change_palette_color     ;0015h
jmp os_get_api_ver              ;0018h
jmp os_get_file_list            ;001Bh
jmp os_get_file_size            ;001Eh
jmp os_load_file                ;0021h
jmp os_write_file               ;0024h
jmp os_file_exists              ;0027h
jmp os_create_file              ;002Ah
jmp os_remove_file              ;002Dh
jmp os_rename_file              ;0030h
jmp os_reset_palette            ;0033h
jmp os_printc                   ;0036h
jmp os_string_length            ;0039h
jmp os_string_uppercase         ;003Ch
jmp os_string_lowercase         ;003Fh
jmp os_string_reverse           ;0042h
jmp os_string_charchange        ;0045h
jmp os_string_copy              ;0048h
jmp os_string_join              ;004Bh
jmp os_string_trim              ;004Eh
jmp os_string_strip             ;0051h
jmp os_string_compare           ;0054h
jmp os_string_truncate          ;0057h
jmp os_string_strincmp          ;005Ah
jmp os_string_parse             ;005Dh
jmp os_string_to_uint           ;0060h
jmp os_uint_to_string           ;0063h
jmp os_sint_to_string           ;0066h
jmp os_long_uint_to_string      ;0069h
jmp os_find_char_in_string      ;006Ch
jmp $                           ;006Fh
jmp os_load_file_and_execute    ;0072h
jmp os_string_get_section       ;0075h
jmp os_kernel_panic             ;0078h
jmp ENUM_default_colors         ;007Bh




os_start:
    ; Setup stack
    cli
    mov ax, 0
    mov ss, ax
    mov sp, 0x0FFFF
    sti

    ; Clear direction flag
    cld

    mov ax, 1000h       ; Set segment to 1000h
	mov ds, ax			
	mov es, ax			
	mov fs, ax			
	mov gs, ax

    cmp dl, 0
	je no_change
	mov [bootdev], dl		; Save boot device number
	push es
	mov ah, 8			; Get drive parameters
	int 13h
	pop es
	and cx, 3Fh			; Maximum sector number
	mov [SecsPerTrack], cx		; Sector numbers start at 1
	movzx dx, dh			; Maximum head number
	add dx, 1			; Head numbers start at 0 - add 1 for total
	mov [Sides], dx

no_change:

    mov ax, 1003h	; Set text output to be bright, and not blinking
	mov bx, 0
	int 10h

	call os_cursor_off

    mov bh, 0x0f ; Background color
	call os_clear_screen

    ; Search for AUTOEXEC.BIN
    mov ax, autoexec_bin_name
    call os_file_exists
    jc no_autoexec

    ; Found it, now load it
    mov dh, 19 ; row
    mov dl, 29 ; column
    mov si, load_message
    call os_printc

    mov cx, autoexec_load_addr
    jmp os_load_file_and_execute

no_autoexec:
    mov ax, error_no_auto
    jmp os_kernel_panic
	
potatos_msg: db "PotatOS Version ",POTATOS_VERSION,0 ; 25 chars /2 12 chars 40-12 28
potato_credit: db "OS made by NicePotato",0

enter_message: db "Searching for AUTOEXEC",0 ; 21 chars /2 11 40-11 29
load_message: db " Loading AUTOEXEC...  ",0 ; 19 /2
error_no_auto: db "RIP OS, where is AUTOEXEC???",0 ; 27 chars /2 13 40-13 27
debug_str: db "OK",0

autoexec_bin_name: db "AUTOEXEC.BIN",0

;------------------------------------------------
;Variables

fmt_12_24	db 0		; Non-zero = 24-hr format

fmt_date	db 0, '/'	; 0, 1, 2 = M/D/Y, D/M/Y or Y/M/D
					    ; Bit 7 = use name for months
					    ; If bit 7 = 0, second byte = separator character

;------------------------------------------------
;INCLUDES

%INCLUDE "source/features/screen.asm"
%INCLUDE "source/features/misc.asm"
%INCLUDE "source/features/mikedisk.asm"
%INCLUDE "source/features/string.asm"
%INCLUDE "source/features/math.asm"