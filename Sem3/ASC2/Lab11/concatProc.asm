bits 32                         
segment code use32 public code
global concat

;define the function
concat: ; 
    mov edi, [esp + 16]
    
    cld
    
    mov esi, [esp + 4]
    mov ecx, 100
    rep1:
        lodsb
        mov bl, 0;
        cmp bl, al
        je rep1done
        dec esi
        movsb
    loop rep1
    rep1done:
    
    mov esi, [esp + 8]
    mov ecx, 100
    rep2:
        lodsb
        mov bl, 0;
        cmp bl, al
        je rep2done
        dec esi
        movsb
    loop rep2
    rep2done:
    
    mov esi, [esp + 12]
    mov ecx, 100
    rep3:
        lodsb
        mov bl, 0;
        cmp bl, al
        je rep3done
        dec esi
        movsb
    loop rep3
    rep3done:

    ret 4*4;
