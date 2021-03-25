;--------------------------------------------------------------------------------------------------------------------------
; Dvortsova BSE 182
; Lib for drawing frame of hearts and some additional functions.
;--------------------------------------------------------------------------------------------------------------------------  
  
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
     
.code
.186
;--------------------------------------------------------------------------------------------------------------------------
; Function puts value of ax register into the frame by address ((Y + 3) * COLUMNS + (X + 8)) * 2                 
;--------------------------------------------------------------------------------------------------------------------------  

;--------------------------------------------------------------------------------------------------------------------------
;                
;--------------------------------------------------------------------------------------------------------------------------  
        
;--------------------------------------------------------------------------------------------------------------------------
; Function prints message            
;--------------------------------------------------------------------------------------------------------------------------  
print_message proc
                mov di, ((Y + 3) * COLUMNS + (X + 8)) * 2  
                mov si, offset Message
                mov ah, string_color
loop_str:        lodsb
                cmp al, 0
                je exit
                stosw
                jmp loop_str
exit:
                ret
              endp   

Message             db 'In vino veritas...', 0
;--------------------------------------------------------------------------------------------------------------------------
;                
;--------------------------------------------------------------------------------------------------------------------------  
   

;--------------------------------------------------------------------------------------------------------------------------
; Function draws frame in video segv. It changes register es, bx, di, cx, ax.              
;--------------------------------------------------------------------------------------------------------------------------  
draw_frame proc 
                pusha                         ; save registers  
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
                popa                        ; old registers
		        ;jmp exit    
                ret     
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
