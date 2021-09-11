#offset $0000

START:
    LD A $F0E9
    ST A $00D0

LOOP1:
    LD A $00D0
    LD X $F0E9
    SB A X
    JZ LOOP1

    ; it's not equal
    ST X $00D2

    LD A $F0E9
    ST A $00D1

LOOP2:
    LD A $00D1
    LD X $F0E9
    SB A X
    JZ LOOP2

    ; it's not equal
    ST X $00D3

    ; send stuff to GPU
    LD A $00D0
    ST A $F0F0
    LD A $00D1
    ST A $F0F1
    LD A $00D2
    ST A $F0F2
    LD A $00D3
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