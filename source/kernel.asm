BITS 16
CPU 386

%DEFINE SNOOPOS_VERSION '0.1.00'
%DEFINE API_VERSION 1

disk_buffer	equ	0x6000
autoexec_load_addr equ 0x5000

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
jmp os_get_file_size            ;0033h
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
jmp os_string_strincmp          ;0060h
jmp os_string_parse             ;0063h
jmp os_string_to_uint           ;0066h
jmp os_uint_to_string           ;0069h
jmp os_sint_to_string           ;006Ch
jmp os_long_uint_to_string      ;006Fh
jmp os_find_char_in_string      ;0072h

os_start:
    cli
    mov ax, 0
    mov ss, ax
    mov sp, 0x0FFFF
    sti

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

    mov ax, 1003h			; Set text output with certain attributes
	mov bx, 0			; to be bright, and not blinking
	int 10h

	call os_cursor_off
	
    mov bx, 0x05	;color
	mov dh, 56	;red
	mov ch, 19	;green
	mov cl, 63	;blue
	call os_change_palette_color

    mov bh, 0x5f ; Background color
	call os_clear_screen

	mov dh, 1       ; row
	mov dl, 0       ; column
	
    mov si, snoopos_msg_0
    call os_printc

	mov dh, 15       ; row
	mov dl, 28       ; column
	
    mov si, snoopos_msg
    call os_printc

    mov dh, 24       ; row
	mov dl, 0       ; column
	
    mov si, potato_credit
    call os_printc

    mov dh, 19 ; row
    mov dl, 29 ; column
    
    mov si, enter_message
    call os_printc

    ; Search for AUTOEXEC.BIN
    mov ax, autoexec_bin_name
    call os_file_exists
    jc no_autoexec

    mov dh, 19 ; row
    mov dl, 29 ; column
    
    mov si, load_message
    call os_printc

    jmp $

no_autoexec:
    ; Hang forever because I am too lazy to implement proper error handling

    mov dh, 19
    mov dl, 27
    
    mov si, error_no_auto
    call os_printc

    jmp $
	




snoopos_msg_0: db "                                                        ,----..",13,10
snoopos_msg_1: db "     .--.--.                                           /   /   \   .--.--.",13,10
snoopos_msg_2: db "    /  /    '.                             ,-.----.   /   .     : /  /    '.",13,10
snoopos_msg_3: db "   |  :  /`. /      ,---,   ,---.    ,---. \    /  \ .   /   :.  |  :  /`. /",13,10
snoopos_msg_4: db "   :  |  |--`   ,-+-. /  | '   ,'\  '   ,'\|   :    .   :   /  ` :  |  |--`",13,10
snoopos_msg_5: db "   |  :  :_    ,--.'|'   |/   /   |/   /   |   | .\ :   |  : \ : |  :  :_",13,10
snoopos_msg_6: db "    \  \    `.|   |  ,'' .   : ,. .   : ,. .   : |: |   :  | : | '\  \    `.",13,10
snoopos_msg_7: db "     `----.   |   | /  | '   | |: '   | |: |   |  \ .   |  ' ' ' : `----.   \",13,10
snoopos_msg_8: db "     __ \  \  |   | |  | '   | .: '   | .: |   : .  '   :  \: /  | __ \  \  |",13,10
snoopos_msg_9: db "    /  /`--'  |   | |  |/|   :    |   :    :     |`-'\   \  ',  / /  /`--'  /",13,10
snoopos_msg_a: db "   '--'.     /|   | |--'  \   \  / \   \  /:   : :    :   :    / '--'.     /",13,10
snoopos_msg_b: db "     `--'---' |   |/       `----'   `----' |   | :     \   \ .'    `--'---'",13,10
snoopos_msg_c: db "              '---'                        `---'.|      `---`",13,10
snoopos_msg_d: db "                                            `---`",13,10,0
snoopos_msg: db "SnoopOS Version ",SNOOPOS_VERSION," :3",0 ; 25 chars /2 12 chars 40-12 28
potato_credit: db "OS made by NicePotato                                  An OS made for Snoopie <3",0

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
%INCLUDE "source/features/disk.asm"
%INCLUDE "source/features/string.asm"
%INCLUDE "source/features/math.asm"