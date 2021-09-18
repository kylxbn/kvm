; DRAWLINES
; this makes the GPU draw random colored
; lines at the screen

#offset $0300

START:
    ; send coordinates to GPU
    LD A $F0E9
    ST A $F0F0
    LD A $F0E9
    ST A $F0F1
    LD A $F0E9
    ST A $F0F2
    LD A $F0E9
    ST A $F0F3

    ; set color
    LD A $F0E9
    ST A $F0F4
    LD A $F0E9
    ST A $F0F5
    LD A $F0E9
    ST A $F0F6

    ; draw
    ST A $F0FF

    ; loop
    JP START