BITS 16
%INCLUDE "os.inc"
ORG exit_addr

call os_cursor_off
call os_reset_palette

mov bx, 0x05	;color
mov dh, [ENUM_os_bgcolor]	;red
mov ch, [ENUM_os_bgcolor+1]	;green
mov cl, [ENUM_os_bgcolor+2]	;blue
call os_change_palette_color

mov bh, 0x5f ; Background color
call os_clear_screen

; Setup GUI
; Borders
mov al, 0xBA        ; '║'
mov bl, 0x5f        ; Color
mov dl, 0           ; X
mov dh, 1           ; Y
mov cx, 1           ; Width
mov di, 23          ; Height
call os_draw_box
mov dl, 25          ; X
call os_draw_box
mov dl, 79          ; X
call os_draw_box
mov al, 0xCD        ; '═'
mov dl, 1           ; X
mov dh, 0           ; Y
mov cx, 78          ; Width
mov di, 1           ; Height
call os_draw_box
mov dh, 24          ; Y
call os_draw_box
; Corners


jmp $