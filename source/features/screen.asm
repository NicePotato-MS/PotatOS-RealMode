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

os_print_string:			; Output string in SI to screen
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
; bl - Color
; dh - Red
; ch - Green
; cl - Blue
os_change_palette_color:
    push ax
    mov bh,0
    mov ax, 10h
    int 10h ; Video
    pop ax
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