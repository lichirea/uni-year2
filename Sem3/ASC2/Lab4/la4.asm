bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; Given the word A, obtain the integer number n represented on the bits 0-2 of A. Then obtain the word B by rotating A n positions to the right. Compute the doubleword C:
a dw 0000000010001100b; 
b resw 1;
c resd 1;

; our code starts here
segment code use32 class=code
    start:
        ;lets calculate b
        mov ax, [a];
        and ax, 00000000000000111b; this is n
        mov cx, ax;
        mov ax, [a];
        ror ax, cl;
        mov word [b], ax;
        ; the bits 8-15 of C have the value 0
        mov ebx, 0; well, it is done
        ;the bits 16-23 of C are the same as the bits of 2-9 of B
        ;we isolate bits 2-9 of b
        mov eax, 0;
        mov ax, [b];
        and ax, 0000001111111100b;
        ;rotate 14 bits to the left
        mov cl, 14;
        rol eax, cl;
        or ebx, eax; its done
        ;the bits 24-31 of C are the same as the bits of 7-14 of A
        ;isolate
        mov eax, 0;
        mov ax, [a];
        and ax, 0111111110000000b;
        ;rotate 17 bits to the left;
        mov cl, 17;
        rol eax, cl;
        or ebx, eax; done
        ;the bits 0-7 of C have the value 1
        or ebx, 11111111b;
        mov dword [c], ebx;
        
       
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
