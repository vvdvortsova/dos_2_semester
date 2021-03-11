       

.model tiny
.code
org 100h
Start:
                mov ah, 09h 
                mov dx, offset Message
                int 21h

                mov ax, 4ch
                int 21h


Message         db "Hellow AAA!!!!$"

end             Start 
