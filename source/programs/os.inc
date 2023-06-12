; Main

os_start                        equ 0000h
os_get_api_ver                  equ 0018h

; Video

os_print                        equ 0003h
os_printc                       equ 0036h
os_cursor_off                   equ 0006h
os_cursor_on                    equ 0009h
os_set_cursor_pos               equ 000Ch
os_clear_screen                 equ 0012h
os_draw_box                     equ 000Fh
os_change_palette_color         equ 0015h
os_reset_palette                equ 0033h

; Disk

os_get_file_list                equ 001Bh
os_get_file_size                equ 001Eh
os_load_file                    equ 0021h
os_write_file                   equ 0024h
os_file_exists                  equ 0027h
os_create_file                  equ 002Ah
os_remove_file                  equ 002Dh
os_rename_file                  equ 0030h

; String

os_string_length                equ 0039h
os_string_uppercase             equ 003Ch
os_string_lowercase             equ 003Fh
os_string_reverse               equ 0042h
os_string_charchange            equ 0045h
os_string_copy                  equ 0048h
os_string_join                  equ 004Bh
os_string_trim                  equ 004Eh
os_string_strip                 equ 0051h
os_string_compare               equ 0054h
os_string_truncate              equ 0057h
os_string_strincmp              equ 0060h
os_string_parse                 equ 0063h
os_string_to_uint               equ 0066h
os_uint_to_string               equ 0069h
os_sint_to_string               equ 006Ch
os_long_uint_to_string          equ 006Fh
os_find_char_in_string          equ 0072h