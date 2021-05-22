.286
.model tiny
.code
org 7C00h
; DOS loader (1 head 79 track 17) 
; frame (1 head 79 track 18 sector) - put it in the end of the freeDos
main:		    mov ah, 02h        ; read loader and execute code of the frame(sub-program)
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

; the describing of constants
VIDEOSEG        = 0b800h
SPACE           = 0e00h         ; space
STRING_COLOR    = 0eh           ; red   
				; 05 - magneta color on the black
				; line is heart = 10h  :3
LEFT_UP         = 0510h         ; left border  
HOR_LINE        = 0503h         ; line
RIGHT_UP        = 0511h         ; right border
             
Y               = 5
X               = 20
COLUMNS         = 80
WIDTH_FRAME     = 20

start:	        call draw_frame    
    
                xor ax, ax
                mov es, ax
                mov ds, ax	    ; default es and ds

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
                    

;--------------------------------------------------------------------------------------------------------------------------
; Function draws frame in video segv. It changes register es, bx, di, cx, ax.              
;--------------------------------------------------------------------------------------------------------------------------  
draw_frame proc 
                pusha                          ; save registers  
                ; go to VIDEOSEGv
                mov bx, VIDEOSEG
                mov es, bx
                mov di, (Y * COLUMNS + X) * 2

                ; put params
                push LEFT_UP
                push HOR_LINE
                push RIGHT_UP
                call draw_line_func

                ; draw body	
                mov cx, 5
draw_body:      ; put params
                add di, (80 - WIDTH_FRAME) * 2 ; new line : 80 - WIDTH_FRAME of window
                push HOR_LINE
                push SPACE
                push HOR_LINE
                call draw_line_func
                loop draw_body		
                
                add di, (80 - WIDTH_FRAME) * 2 ; new line
                ; put params
                push LEFT_UP
                push HOR_LINE
                push RIGHT_UP
                call draw_line_func
                popa                           ; old registers
		        ;jmp exit    
                ret 0    
            endp
;--------------------------------------------------------------------------------------------------------------------------
;                
;--------------------------------------------------------------------------------------------------------------------------  
            
;--------------------------------------------------------------------------------------------------------------------------
; Function draws line in videosegv(address is set by draw_frame function). Params: left_corner, line, right corner   
;--------------------------------------------------------------------------------------------------------------------------                
draw_line_func proc                            
                push bp                        ; save bp
                mov bp, sp                     ; put bp on the top of the stack
                
                push ax                        ; save ax		
                mov ax, [bp + 8]               ; draw left simbol
                mov es:[di], ax
                inc di
                inc di
                        
                mov ax, [bp + 6]               ; draw line simbol		
                push cx
                mov cx, 20
draw_line:      mov es:[di], ax
                inc di
                inc di
                loop draw_line

                pop cx	                       ; old cx	
                mov ax, [bp + 4]               ; draw right simbol		
                mov es:[di], ax
                inc di
                inc di
                pop bp                         ;  old bp
                pop ax                         ;  old ax 
                ret 6                          ; clean stack 2 * 3 params
              endp
;--------------------------------------------------------------------------------------------------------------------------
;                
;--------------------------------------------------------------------------------------------------------------------------  

org 7C00h + 512 + 511
db  0

end		main
