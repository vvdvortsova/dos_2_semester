.model tiny
.code
org 100h

start:		
        call draw_frame
        call print_message
        
		mov ax, 4c00h	; exit
		int 21h

include draw_lib.asm			; load libs
end start
