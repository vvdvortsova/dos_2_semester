.model tiny
.code
org 7c00h

start:		
        call draw_frame
        call print_message
        
		mov ax, 4c00h	; exit
		int 21h

include draw_lib.asm			; load libs

db start+510-$ dup (0)
dw 0AA55h

end start 
