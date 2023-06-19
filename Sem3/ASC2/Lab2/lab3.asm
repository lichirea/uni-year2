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
    ; (a+b)-(a+d)+(c-a)
    a1 db 2;
    b1 dw 1;
    c1 dq 4
    d1 dd 1;
    ;c-(d+a)+(b+c)
    a2 db 1;
    b2 dw 3;
    c2 dd 10;
    d2 dq 2;
    ;x+a/b+c*d-b/c+e; a,b,d-byte; c-word; e-doubleword; x-qword = 10+4/2 + 1*6 - 2/1 + 10 = 20+2+6-2 = 26
    x3 dq 10;
    a3 db 4;
    b3 db 2;
    d3 db 6;
    c3 dw 1;
    e3 dd 10;
    
; our code starts here
segment code use32 class=code
    start:
        ; ...
        ; (a+b)-(a+d)+(c-a) = 2+1 - (2+1) + 4-2 = 2
        ;we convert a to doubleword
        mov al, [a1];
        mov ah, 0;
        mov dx, 0;
        mov bx, word [d1];
        mov cx, word [d1+2];
        add ax, bx;
        adc dx, cx; dx:ax = a+d
        mov bx, ax;
        mov cx, dx;
        ;we convert a to word unsigned
        mov al, [a1];
        mov ah, 0;
        add ax, [b1]; ax = a + b
        ;then convert to a doubleword for sub
        mov dx, 0;
        sub ax, bx;
        sbb dx, cx; a+b-(a+d)
        ;we convert a to quadword
        mov bx, ax;
        mov cx, dx;
        mov eax, 0;
        mov al, [a1];
        mov edx, 0;
        push cx;
        push bx;
        mov ebx, dword [c1];
        mov ecx, dword [c1+4];
        sub ebx, eax;
        sbb ecx, edx; ecx:ebx = c-a
        ; now add the final ones
        pop eax;
        mov edx, 0;
        add eax, ebx;
        adc edx, ecx;
        
        
        ;c-(d+a)+(b+c) = 10 - (2+1) + (10+3) = 7+13 = 20
        ;convert b to dword
        mov ax, [b2];
        mov dx, 0;
        add ax, word [c2];
        adc dx, word [c2+2]; dx:ax = b+c
        ;convert a to qw
        mov ebx, 0;
        mov bl, [a2];
        mov ecx, 0; ecx:ebx = a
        add ebx, dword [d2];
        adc ecx, dword [d2+4]; ecx:ebx = a+d
        ;now to subtract a+d from c
        push dx;
        push ax;
        mov eax, [c2];
        mov edx, 0;
        sub eax, ebx;
        sbb edx, ecx;
        ; convert b+c to quadword
        pop ebx;
        mov ecx, 0;
        add eax, ebx;
        adc edx, ecx;
        
        
        ;x+a/b+c*d-b/c+e = 26 UNSIGNED
        mov al, [a3];
        mov ah, 0;
        div byte [b3]; al = a/b
        mov bl, al;
        ; now lets do c*d
        mov al, [d3];
        mov ah, 0;
        mul word [c3]; dx:ax = c*d;
        ; now lets add these 2
        ;convert al = a/b to a doubleword
        mov bh, 0;
        mov cx, 0; cx:bx = a/b
        add bx, ax;
        adc cx, dx; cx:bx = a/b+c*d = 8
        ; now lets do b/c
        mov al, [b3];
        mov ah, 0;
        mov dx, 0; dx:ax = b
        div word [c3]; ax = b/c = 2
        ; now we subtract this from our previous result
        mov dx, 0;
        sub bx, ax;
        sbb cx, dx; cx:bx = a/b+c*d-b/c = 6
        ; now we add the doubleword e = 10
        add bx, word [e3];
        adc cx, word [e3+2]; cx:bx = 16;
        ; now we add the quadword x = 10;
        push cx;
        push bx;
        pop eax;
        mov edx, 0; edx:eax = 16
        add eax, dword [x3];
        adc edx, dword [x3+4]; edx:eax = final result 26
        
        ;THIS IS A BUFFER SO I KNOW WHERE TO STOP IN THE DEBUGGER
        mov al,0;
        mov al,0;
        mov al,0;
        mov al,0;
        mov al,0;
        mov al,0;
        
        ; x+a/b+c*d-b/c+e = 26 SIGNED
        mov al, [a3]; convert a to word to divide by byte b
        cbw;
        idiv byte [b3]; al = a/b = 4/2 = 2
        mov bl, al;
        ;convert d to word to multiply with the word c
        mov al, [d3];
        cbw;
        imul word [c3];dx:ax = c*d = 6*1 = 6
        ; add these 2 together
        push dx;
        push ax;
        mov al, bl;
        cbw;
        cwde; eax = a/b
        pop ebx; ebx = c*d
        add ebx, eax; ebx = 8
        ;now calculate b/c
        ; convert b to doubleword to divide it by word c 
        mov al, [b3];
        cbw;
        cwd; dx:ax = b
        idiv word [c3]; ax = b/c = 2
        ;substract it from our previous result
        ;convert it to a doubleword for that
        cwde; eax = b/c = 2
        sub ebx, eax; ebx = 8-2 = 6
        ; now add to this the dword e = 10
        add ebx, dword [e3]; ebx = 10+6 = 16
        ;now add to this the qword x = 10
        mov eax, ebx;
        cdq; edx:eax = 16;
        add eax, dword [x3];
        adc edx, dword [x3+4]; edx:eax = 26 which is the final result
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
