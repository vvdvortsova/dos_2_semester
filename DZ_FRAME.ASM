.model tiny

videoseg        = 0b800h
probel          = 0e00h         ; fill rectangle with space
string_color    = 0eh           ; red   

				; 05 - magneta color on the black
				; line is heart = 10h  :3

left_up         = 0510h         ; left border  
hor_line        = 0503h         ; line
right_up        = 0511h         ; right border
ver_line        = 0503h         ; line
right_down      = 0511h         ; right low border
left_down       = 0510h         ; left low border                 

Y               = 5
X               = 40
COLUMNS         = 80
ROWS            = 25
     
.code
org 100h


Start:

; go to videosegv
		mov bx, videoseg
		mov es, bx
		mov di, (Y * COLUMNS + X) * 2


		; put params
		push left_up
		push hor_line
		push right_up
		call draw

		;draw body	
		mov cx, 5

		

draw_body:      ; put params
		push left_up
		push probel
		push hor_line
		call draw

		loop draw_body		
		
	

		jmp exit     



; write message

                mov di, (20+30) * 2    ;rewrite
                mov si, offset Message
                mov ah, string_color
loopStr:        lodsb
                cmp al, 0
                je exit
                stosw
                jmp loopStr



exit:           mov ax, 4c00h
                int 21h

draw proc 
		push bp    ; save bp
		mov bp, sp ; put bp on the top of the stack
		
		push ax    ; save ax		
		mov ax, [bp + 8] ; draw left simbol
		mov es:[di], ax
		inc di
		inc di
                
		mov ax, [bp + 6] ; draw line simbol		

		push cx
		mov cx, 20

draw_line:      mov es:[di], ax
		inc di
		inc di
		loop draw_line

		pop cx	   ; old cx	
		
		mov ax, [bp + 4] ; draw left simbol		
                mov es:[di], ax
		inc di
		inc di
		
		
 		pop bp     ;  old bp
                pop ax     ;  old ax 
		ret 6      ; clean stack
draw endp

.data
Message             db 'In vino veritas...', 0


end Start
