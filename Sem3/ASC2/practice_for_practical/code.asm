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
;PRACTICE FOR PRACTICAL EXAM
;A file name (defined in data segment) is given. Create a file with the given name, then read words from the keyboard until character '$' is read from the keyboard. Write only the words that contain at least one digit to file.

    file_name db 'practice.txt', 0
    file_descriptor dd -1;
    access_mode db "a", 0
    
    string_format db "%s", 0
    max_len equ 100;
    text times max_len db 0;
    
    len dw 9999;
    
    digits db '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 0
    digit_check_counter dw 10;
    
; our code starts here
segment code use32 class=code
    start:
        ; ...
        ;create output file
        
        push dword access_mode
        push dword file_name
        call [fopen]
        add esp, 4 * 2
        
        mov [file_descriptor], eax
        
        
        
        mov ecx, 2;
        bigloop:
            ;read a word
            push dword text
            push dword string_format
            call [scanf]
            add esp, 4 * 2
            
            mov ecx, 100;
            
            mov al, '$'
            mov edi, text
            cld
            repne scasb
            je stop
        
            
            
            ;check if it has a digit
            mov esi, digits
            mov dword [digit_check_counter], 10
            checking:
                lodsb
                mov edi, text
                mov ecx, 100;
                cld
                repne scasb
                je writeit
                mov ecx, [digit_check_counter]
                dec ecx;
                mov [digit_check_counter], ecx
                inc ecx
            loop checking;
            
            jmp dontwrite
            writeit:
                push dword text
                push dword [file_descriptor]
                call [fprintf]
                add esp, 4*2
                
            dontwrite:
            mov ecx, 2;
            jmp dontstop
            stop:
                mov ecx, 1;
            dontstop:
        loop bigloop
        
        push dword [file_descriptor]
        call [fclose]
        add esp, 4 * 1
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
