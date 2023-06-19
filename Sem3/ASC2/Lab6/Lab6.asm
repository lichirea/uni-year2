bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ;A word string s is given. Build the byte string d such that each element d[i] contains:
    ;- the count of zeros in the word s[i], if s[i] is a negative number
    ;- the count of ones in the word s[i], if s[i] is a positive number
    
s dw -22, 145, -48, 127
; 1111111111101010, 10010001, 1111111111010000, 1111111
ls db ($-s)/2;
d resb 10; d: 3, 3, 5, 7


x dd 0;

; our code starts here
segment code use32 class=code
    start:
        mov esi, s;
        mov edi, d;
        cld;
        mov ecx, 0;
        mov cl, [ls];
        structure:
            mov dword [x], ecx;
            lodsw; load into ax the next word from s
            test ax, ax; test the word
            js negative; if the word is negative we jump to a label
            
            positive:
                mov ecx, 16; go through all the bits of the word
                mov bl, 0; here we keep the count of ones
                count1:
                    sar ax, 1;get the next bit into CF
                    jnc itsazero;if the CF is a 0, then we dont count it
                    
                    inc bl;increment our counter for number of 1s
                    
                    itsazero:
                loop count1;
                jmp done;
                
            negative:
                mov ecx, 16; go through all the bits of the word
                mov bl, 0; here we keep the count of zeroes
                count0: 
                    sar ax, 1; get the next bit into CF
                    jc itsaone; if the CF is a 1, then we dont count it
                    
                    inc bl;increment the counter for number of 0s
                    
                    itsaone:
                loop count0;
            done:
            mov al, bl;
            stosb;
            
            mov ecx, dword [x];
        loop structure;
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
