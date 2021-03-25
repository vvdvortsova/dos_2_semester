.model tiny

VIDEOSEG        = 0b800h

.code
.186
org 100h

start:		
        mov ax, 10101111b 
        push ax ; number
        push 16  ; base
        push 4 ; shift 
        push 16*2 ; videosegv shift
        call converter
        
		mov ax, 4c00h	; exit
		int 21h

;--------------------------------------------------------------------------------------------------------------------------
; Function prints in videosegv the inverted value of register to base -2, -8, -16    223d -> DFh -> prints FD
; params: put on the stack number, base, shift, videosegv shift
;--------------------------------------------------------------------------------------------------------------------------  
converter proc  
               
                
                mov cl, 0
                
                mov bx, VIDEOSEG               ; get videosegv
                mov es, bx
                mov bp, sp                     ; put bp on the top of the stack   

                mov di, [bp + 2]               ; get videosegv shift
                
                mov ax, [bp + 8]               ; get num
                mov bx, [bp + 6]               ; get base
                mov cx, [bp + 4]               ; get shift
                cmp bx, 2
                je  to_bin
                cmp bx, 8
                je  to_8
                
to_hex:         mov bx, 00001111b              ; set bit mask         
                push ax
translate:      cmp cx, 20d
                jge  exit_proc
                and ax, bx                     
                cmp al, 10d
                jl first_sym	; ah < 10
		        jae second_sym  ; ah >= 10
next:
                mov es:[di], al
                inc di
                inc di                         ; write symbol
                pop ax
                push ax
                shr ax, cl
                and ax, bx 
                add cl, [bp + 4] 
                jmp translate
                
                
                
                jmp exit_proc
                
to_bin:         mov bx, 0001b                  ; set bit mask
                push ax
                jmp translate
                
to_8:           mov bx, 0111b; set bit mask  
                push ax
                jmp translate

first_sym:	    add al, '0'
                jmp next

second_sym:	    add al, 'A' - 10
		        jmp next

exit_proc:      pop ax
                ret 8               ; 2*4
                endp  
;--------------------------------------------------------------------------------------------------------------------------
;                
;--------------------------------------------------------------------------------------------------------------------------  
end start
