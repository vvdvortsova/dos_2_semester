.model tiny
.code
org 100h
X 		equ 40
Y 		equ 5 		; define consts
Start:
                mov bx, 0b800h     ; addr = ES*10h +di/bx real mode
                mov es, bx
                mov bx, offset Message
                mov di, (Y * 80 + X) * 2
                mov dh, 4eh

LoopStart:      mov dl, [bx] ; mov dl, ds:[bx]  dl <= RAM [ds*10h +bx]
                cmp dl, 0
                je LoopEnd  ; if ([bx] == 0) goto LoopEnd


                mov es:[di], dx
                inc bx
                add di, 2
                jmp LoopStart

LoopEnd:         mov ax, 4c00h ; exit
                 int 21h

Message          db "Hello, world!", 0 , "This shouldn't be printed!!", 0

end              Start
