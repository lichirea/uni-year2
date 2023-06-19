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
;A byte string S is given. Obtain the string 
;D by concatenating the elements found on the even positions of S 
;and then the elements found on the odd positions of S.
s db 1, 2, 3, 4, 5, 6, 7, 8
ls equ $-s-1
d resb 16

x resd 1

; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov ecx, ls ; loop counter
        mov esi, 0 ; index for S
        mov ebx, 0 ; index for D
        jecxz loopend1 ; in case the string is empty
        structure1: ; concates the even positions
            mov al, [s+esi];get the element from S
            mov dword [x], esi; store the index of S
            mov esi, ebx; get the index of D
            mov [d+esi], al ; store the element in D
            mov esi, dword [x] ; get back the index of S
            
            inc esi  ; increment the index of S and D
            inc esi
            inc ebx
            
            dec ecx ; decrement it by 2; checking to make sure the number doesnt become negative
            JECXZ loopend1
            dec ecx
            JECXZ loopend1
            jmp structure1
        
        loopend1:
        
        
        mov ecx, ls
        mov esi, 1 ; its the same but it starts from 1 instead of 0
        jecxz loopend2 ; in case the string is empty
        structure2: ; concates the odd positions
            mov al, [s+esi];get the element from S
            mov dword [x], esi ; store the index of S
            mov esi, ebx ; get the index of D
            mov [d+esi], al ; store the element in D
            mov esi, dword [x] ; get back the index od S
            
            inc esi ; increment the index of S and D
            inc esi
            inc ebx
            
            dec ecx
            JECXZ loopend2
            dec ecx
            JECXZ loopend2
            jmp structure2
        
        loopend2:
        
        
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
