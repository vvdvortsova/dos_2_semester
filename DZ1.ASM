.model tiny
.code
org 100h

Start:          mov bx, offset Message

LoopStart:      mov dl, [bx]
                cmp dl, 0
                je LoopEnd  ; if ([bx] == 0) goto LoopEnd

                mov ah, 02h
                int 21h      ; putchar([bx])
                inc bx
                jmp LoopStart

LoopEnd:         mov ax, 4c00h ; exit
                 int 21h

Message          db "Hello, world!", 0 , "This shouldn't be printed!!", 0

end              Start
