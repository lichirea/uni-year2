bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf, scanf, fopen, fclose, fprintf, fread
import exit msvcrt.dll  
import printf msvcrt.dll
import scanf msvcrt.dll
import fopen msvcrt.dll
import fprintf msvcrt.dll
import fread msvcrt.dll
import fclose msvcrt.dll

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
;A file name and a text (defined in data segment) are given. The text contains lowercase letters, uppercase letters, digits and special characters. Replace all spaces from the text with character 'S'. Create a file with the given name and write the generated text to file.

    
    text db "buna siara am venit sa va ANTREB daca vindeti porumb BONDUELLE la 15! reducere", 0
    lentext db $-text;
    file_name db 'code2.out', 0
    fd dd -1;
    access_mode db 'a', 0
    format db '%s', 0
    
; our code starts here
segment code use32 class=code
    start:
        ; ...
        mov ecx, 0;
        mov cl, [lentext];
        mov esi, text;
        cld;
        schimba:
            lodsb;
            cmp al, ' '
            jne nueboss
                mov byte [esi-1], 'S'
            nueboss:
        
        loop schimba
        
        push dword access_mode
        push file_name
        call [fopen]
        add esp, 4 * 2
        
        mov [fd] ,eax;
        
        push dword text
        push dword [fd]
        call [fprintf]
        add esp, 4 * 2
        
        
        push dword [fd]
        call [fclose]
        add esp, 4 * 2
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
