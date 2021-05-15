.286
.model tiny
.code
org 7C00h
; DOS loader (1 head 79 track 17) 
; frame (1 head 79 track 18 sector) - put it in the end of the freeDos
main:		        mov ah, 02h        ; read loader and execute code of the frame(sub-program)
                    mov al, 1          ; sector to write
                    xor bx, bx
                    mov es, bx         ; buffer 
                    mov bx, 0500h      ; code address
                    mov ch, 79         ; track
                    mov cl, 18         ; sector
                    mov dh, 1          ; head
                    mov dl, 0          ; floppy
                    int 13h	           ; read code of the sub-program

                    push bx
                    ret

org 7C00h + 510
dw  0AA55h


org 7C00h + 512
; sub-program
start:	            ;call draw_frame
                    ;call print_message

                    mov bx, 7C00h   ; data written to disk
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
org 7C00h + 512 + 511
db  0

end		main
