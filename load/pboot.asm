.286
.model tiny
.code
org 0500h

CODE_ADDR	=	7C00h

start:		
                ;call draw_frame
                ;call print_message

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
;include draw_lib.asm			; load libs

org 0500h + 511
db  0

end		start
