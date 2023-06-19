bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit   
extern printf            ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll  
import printf msvcrt.dll  ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    u db !5;
    x dw -256, 256h
    y dw 256|-256, 256h & 256
    z db !(y-$), y-x
    p dw 0ffffh;
    tabel times 50 dq 0ah;
    
    

    
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov ah, 0ffh;
        mob bh, 1;
        or ah, bh << 1
       mov eax, 1
       mov ebx, 2
        mov al, [tabel + eax + ebx*2 +10 +1]
        
        ;registers, errors, lea, flags
        
         
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
