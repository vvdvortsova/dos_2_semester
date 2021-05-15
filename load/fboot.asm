.286
.model tiny
.code
org 7C00h

CODE_ADDR	=	0500h

; DOS loader (1 head 79 track 17) 
; frame (1 head 79 track 18 sector) - put it in the end of the freeDos
; sub-program - pboot.asm

main:		        mov ah, 02h        ; read loader and execute code of the frame(sub-program)
                    mov al, 1          ; sector
                    xor bx, bx
                    mov es, bx         ; buffer 
                    mov bx, CODE_ADDR
                    mov ch, 79         ; track
                    mov cl, 18         ; sector
                    mov dh, 1          ; head
                    mov dl, 0          ; floppy
                    int 13h	           ; read code of the sub-program

                    push bx
                    ret

org 7C00h + 510
dw  0AA55h

end		main
