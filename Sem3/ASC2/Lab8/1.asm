bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
extern printf
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import scanf msvcrt.dll 
import printf msvcrt.dll ; IMPORT PRINTF 
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions
                          


; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    ;Two natural numbers a and b (a: dword, b: dword, defined in the data segment) are given. Calculate 
    ;a/b and display the quotient in the following format: "<a>/<b> = <quotient>". Example: for a = 200, 
    ;b = 5 it will display: "200/5 = 40".
    ;The values will be displayed in decimal format (base 10) with sign.
    
    a dd 200;
    b dd 5;
    format db "%d/%d = %d", 0; 

; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov eax, dword [a]; move a into eax
        cdq; convert eax into edx:eax
        idiv dword [b]; eax = edx:eax / [b]
        
        
        ;int printf(const char * format, variable_1, constant_2, ...);
        ; pushing the parameter on the stack
        push eax;
        push dword [b];
        push dword [a];
        push dword format;  
		call [printf]       ; calling the printf function
		add esp, 4 * 4     ; cleaning the parameters from the stack

        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
