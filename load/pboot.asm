.286
.model tiny
.code
org 7C00h

CODE_ADDR	=	7C00h

start:		
                call draw_frame
                call print_message

                pop ax
                xor ah, ah
                int 10h		    ; restore video mode

                xor ax, ax
                mov es, ax
                mov ds, ax	    ; restore es and ds
            
                mov bx, CODE_ADDR
                mov ah, 02h
                mov al, 1       ; sector to write
                mov ch, 79      ; track 
                mov cl, 17      ; sector
                mov dh, 1       ; head
                mov dl, 0       ; floppy
                int 13h		    ; read bootloader from freeDos into memory

                mov ah, 03h
                xor ch, ch
                mov cl, 1
                xor dh, dh
                int 13h		    ; put freeDos on the first sector

                push bx
                ret
include draw_lib.asm			; load libs

db start+512-$ dup (0)


end		start
