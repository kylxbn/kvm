#offset $0000 ; this is the bootloader so we start at $0000

    LD A #$00     ; we read sector 0
    ST A $F300    ; store high pointer
    ST A $F301    ; store low pointer
    ST A $F302    ; store 0 to read

    LD A #$FF     ; set line color to white etc
    ST A $F0F4
    ST A $F0F5
    ST A $F0F6
    LD A #$00
    ST A $F0F0
    ST A $F0F2
    LD A #$80
    ST A $F0F1
    ST A $F0F3

    LD X #00      ; so we start at offset zero
LOOP:
    ST X $F0F2
    ST A $F0FF    ; draw a white line

    LD A $F100+X  ; and we read HDD RAM with offset X
    ST A $0300+X  ; then write that to $0300 with offset X

    ; we increment X
    ST X $0100    ; save X to $0100
    LD A $0100    ; put that to A
    AD A #01      ; add 1 to A
    
    JZ END        ; if that is zero (overflowed), go to end

    ; but not zero, so...
    ST A $0100    ; store that X to $0100
    LD X $0100    ; load that to X
    JP LOOP       ; not zero, so go back to LOOP

END:
    ; we just clear the stuff we use
    LD A #00
    ST A $0100

    ; clear the white line we drew
    LD A #00      
    ST A $F0F0
    ST A $F0F4
    ST A $F0F5
    ST A $F0F6
    LD A #$FF
    ST A $F0F2
    ST A $F0FF

    JP #$0300      ; then we jump to the loaded sector
