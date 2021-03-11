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

x1              = 10            ; size of the rectangle
x2              = 70
y1              = 5
y2              = 10     
     
.code
org 100h

Start:

; go to videoseg

                mov ax, videoseg
                mov es, ax
                mov ax, probel
                mov di, (y1 * 80 + x1) * 2
                mov cx, x2 - x1         ; Window width
                mov si, 0000h           ; si -> bx. if si = bx, exit
                mov bx, y2 - y1         ; Window height

;fill rectangle with space

x1_to_x2:       stosw                   ; mov es:[di], ax  /  inc di
                loop x1_to_x2

y1_to_y2:       add di, (80 - (x2 - x1)) * 2
                inc si
                mov cx, x2 - x1
                cmp si, bx
                jne x1_to_x2

; write frame around rectangle

                mov di, (y1 * 80 + x1 - 81) * 2
                mov ax, left_up
                stosw                   ; insert high left corner

                mov ax, hor_line        ; draw high line
                mov cx, x2 - x1
                rep stosw		; repete stosw cx count

                mov ax, right_up
                stosw                   ; insert right high corner

                                        ; right vertical right line
                mov di, (y1 * 80 + x1 - 1) * 2
                mov ax, ver_line
                mov si, 1d              ; conter to 2

right_ver:      mov cx, y2 - y1            ; <-------------+
                                           ;               |
vertical:       stosw                      ; <--+          |
                add di, 79d * 2            ;    | loop 1   |
                loop vertical              ; <--+          |
                                           ;               | loop 2
                mov di, (y1 * 80 + x2) * 2 ;               |
                add si, 1d                 ;               |
                cmp si, 2d                 ;               |
                je  right_ver              ; <-------------+

                mov ax, left_down       ; low left corner
                mov di, (y2 * 80 + x1 - 1) * 2
                stosw

                mov ax, hor_line        ;  low horizontal line
                mov cx, x2 - x1
                rep stosw
                                        ; 
                mov ax, right_down      ; low right corner
                stosw

; write message

                mov di, (y1 * 80 + (x2 - x1)/2) * 2
                mov si, offset Message
                mov ah, string_color
loopStr:        lodsb
                cmp al, 0
                je exit
                stosw
                jmp loopStr



exit:           mov ax, 4c00h
                int 21h

.data
Message             db 'In vino veritas...', 0

end Start