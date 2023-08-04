ENUM_default_colors:
    db 0, 0, 0                  ;Color 0: Black
    db 0, 0, 42                 ;Color 1: Blue
    db 0, 42, 0                 ;Color 2: Green
    db 0, 42, 42                ;Color 3: Cyan
    db 42, 0, 0                 ;Color 4: Red
    db 42, 0, 42                ;Color 5: Magenta
    db 42, 21, 0                ;Color 6: Brown
    db 42, 42, 42               ;Color 7: Light Gray
    db 21, 21, 21               ;Color 8: Dark Gray
    db 21, 21, 63               ;Color 9: Light Blue
    db 21, 63, 21               ;Color 10: Light Green
    db 21, 63, 63               ;Color 11: Light Cyan
    db 63, 21, 21               ;Color 12: Light Red
    db 63, 21, 63               ;Color 13: Light Magenta
    db 63, 63, 21               ;Color 14: Yellow
    db 63, 63, 63               ;Color 15: White

os_cursor_off:
    pusha
    mov ah, 0x01
    mov cx, 0x2607  ;invisible cursor
    int 10h
    popa
    ret

os_cursor_on:
    pusha
    mov ah, 0x01
    mov cx, 0x0607  ;underscore cursor
    int 10h
    popa
    ret

os_printc:
    call os_set_cursor_pos

os_print:			; Output string in SI to screen
	pusha

	mov ah, 0Eh				; int 10h teletype function

.repeat:
	lodsb					; Get char from string
	cmp al, 0
	je .done				; If char is zero, end of string
	int 10h	; Video
	jmp short .repeat

.done:
	popa
	ret

; dh - Row
; dl - Column
os_set_cursor_pos:
	pusha
	mov bh, 0
	mov ah, 0x02
	int 0x10 ; Video
	popa
	ret

os_clear_screen:
    pusha
	mov ah, 0x06
	mov al, 0
	mov cx, 0x0000 
	mov dx, 0x184f
	int 0x10 ; Video
	mov dh, 0 ;row
	mov dl, 0 ;column
	call os_set_cursor_pos
    popa
	ret

; Inputs
; bx - Color
; dh - Red (0-63)
; ch - Green (0-63)
; cl - Blue (0-63)
os_change_palette_color:
    push ax
    mov ax, 1010h
    int 10h ; Video
    pop ax
    ret

os_reset_palette:
    pusha
    mov bx, 0
    mov si, ENUM_default_colors
.reset_palette_loop:
    mov dh, byte [si]
    mov ch, byte [si+1]
    mov cl, byte [si+2]
    call os_change_palette_color
    add si, 3
    inc bx
    cmp bx, 16
    jne .reset_palette_loop
    popa
    ret


; Inputs:
; al - character
; bl - color
; dl - start x
; dh - start y
; cx - width
; di - height
os_draw_box:
    pusha              ; Save registers

    mov ah, 0x09       ; Function to write character and attribute at cursor position
    mov bh, 0          ; Video page number (0 for default)

.draw_loop:
    call os_set_cursor_pos
    int 10h            ; Video interrupt

    inc dh             ; Increment row (y)
    dec di             ; Decrement height
    jnz .draw_loop

    popa               ; Restore registers
    ret                ; Return from the function

os_button_bottom_two:
	ret