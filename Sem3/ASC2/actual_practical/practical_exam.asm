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
;Read from the keyboard a number n and a number m. Then read from the keyboard m words separated by spaces. Write in file output.txt only the words that contain less than n consonants.

    n dd 0;
    m dd 0;
    text times 50 db 0;
    decimal_format db "%d",0;
    
    string_format db "%s", 0;
    fd dd -1;
    access_mode db 'a', 0;
    file_name db "output.txt", 0;
    
    printing_format db "%s ", 0;
    
    x dd 0;
    
; our code starts here
segment code use32 class=code
    start:
        ; ...
        
        ;create output file
        push dword access_mode;
        push dword file_name;
        call [fopen];
        add esp, 4 * 2;
        mov [fd], eax; save the file descriptor
        
        
        ;read n and then m
        
        push dword n;
        push dword decimal_format;
        call [scanf]
        add esp, 4*2
        
        push dword m;
        push dword decimal_format;
        call [scanf]
        add esp, 4*2
    
        mov ecx, dword [m]; read m words
        bigloop:
            mov dword [x], ecx;save it because ecx is changed by calling functions
            
            ;read a word
            push dword text;
            push dword string_format;
            call [scanf]
            add esp, 4*2
            
            
            ;count the consonants
            
            mov esi, text;
            mov ecx, 49;max length of a word read
            mov ebx, 0;
            counter:
                lodsb
                cmp al, 'a'
                je vowel
                cmp al, 'e'
                je vowel
                cmp al, 'i'
                je vowel
                cmp al, 'o'
                je vowel
                cmp al, 'u'
                je vowel
                cmp al, 0;
                je word_is_over;
                inc ebx
                vowel:
            loop counter
            
            word_is_over:
            
            
            cmp ebx, [n];
            jge failed
            
            ;print the word if it's ok
            push dword text;
            push dword printing_format;
            push dword [fd];
            call [fprintf];
            add esp, 4*3
            
            failed:
            
            mov ecx, dword [x];
        loop bigloop
        
        ;close the file
        push dword [fd]
        call [fclose];
        add esp, 4*1
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
