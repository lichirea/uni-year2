bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    
    
    
; 2+8
    a1 db 2;
    b1 db 8;
    
;a+b-c+d-(a-d)
    a2 db 1;
    b2 db 2;
    c2 db 3;
    d2 db 4;
    
;(a+a-c)-(b+b+d)
    a3 dw 1;
    b3 dw 2;
    c3 dw 3;
    d3 dw 4;
;[(a*b)-d]/(b+c)
    a4 db 3;
    b4 db 2;
    c4 db 2;
    d4 dw 2;
;(g+5)-a*d
    g5 dw 5;
    a5 db 1;
    d5 db 4;
;a*d*e/(f-5)
    a6 db 2;
    d6 db 2;
    e6 dw 4;
    f6 dw 7;
; our code starts here
segment code use32 class=code
    start:
        ; 2+8
        mov al, [a1];
        add al, [b1]; al = 2 + 8
        ;a+b-c+d-(a-d) = 1+2-3+4-(1-4) = 7
        mov al, [a2];
        add al, [b2]; a+b
        sub al, [c2]; a+b-c
        add al, [d2]; a+b-c+d
        mov bl, [a2];
        sub bl, [d2]; a-d;
        sub al, bl; (a+b-c+d) - (a-d)
        ;(a+a-c)-(b+b+d) = (1+1-3)-(2+2+4)= -9
        mov ax, [a3];
        add ax, [a3]; a+a
        sub ax, [c3]; a+a-c
        mov bx, [b3];
        add bx, [b3]; b+b
        add bx, [d3]; b+b+d;
        sub ax, bx; (a+a-c) - (b+b+d)
        ;[(a*b)-d]/(b+c) = [(3*2)-2]/(2+2) = 4/4 = 1
        mov al, [a4];
        mul byte [b4]; ax = a*b
        sub ax, [d4]; ax - d
        mov bl, [b4];
        add bl, [c4]; b+c
        div byte bl; [(a*b)-d]/(b+c)
        ;(g+5)-a*d = 5 + 5 - 1*4 = 10 - 4 = 6
        mov bx, [g5];
        add bx, 5; g+5
        mov al, [a5];
        mul byte [d5]; a*d
        sub bx, ax; g+5-a*d
        ;the last one didnt have doublewords so let's do another one
        ;a*d*e/(f-5) = 2*2*4/(7-5) = 16/2=8
        mov al, [a6];
        mul byte [d6]; a*d
        mul word [e6]; a*d*e = DX:AX
        mov bx, [f6];
        sub bx, 5; f-5
        div word bx; ax = a*d*e/(f-5) = 8
        
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
   