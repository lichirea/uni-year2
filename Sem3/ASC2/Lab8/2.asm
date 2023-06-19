bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
extern fopen
extern fread
extern fclose
extern printf
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
import fopen msvcrt.dll
import fread msvcrt.dll
import printf msvcrt.dll
import fclose msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    ;A text file is given. Read the content of the file, determine the digit with the highest frequency and display the digit along with its frequency on the screen. The name of text file is defined in the data segment.
    file_name db "input.txt", 0;
    access_mode db "r", 0;
    fd dd 0;
    
    max_len equ 100;
    text times max_len db 0;
    len db 0;
    
    freq db 0, 0, 0, 0, 0, 0, 0, 0, 0, 0;
    
    max_digit db 0;
    max_freq db 0;
    
    format db "Digit %d has the highest frequency, equal to %d", 0;
    
; our code starts here
segment code use32 class=code
    start:
        ; ...
        ;FILE * fopen(const char* file_name, const char * access_mode) ; open the file
        push dword access_mode;
        push dword file_name;
        call [fopen];
        add esp, 4 * 2;
        
        ;now in EAX we have the filedescriptor
        cmp eax, 0;
        je final;
        mov [fd], eax;
        
        ;we read all of the file 
        push dword [fd];
        push dword max_len;
        push dword 1;
        push dword text;        
        call [fread];
        add esp, 4*4
        ;now in eax we have the number of chars that we read
        mov [len], al;
        
        ;int fclose(FILE * descriptor); close the file
        push dword [fd];
        call [fclose];
        add esp, 4 * 1;
        
        ; we parse all the chars of the text
        mov ecx, 0
        mov cl, [len];
        mov esi, text;
        mov edi, freq;
        structure:
            lodsb; get next byte of the text
            ;check if its a digit
            cmp al, '0';
            jl not_a_number;
            cmp al, '9';
            jg not_a_number;
            
            sub al, '0'; convert to number from ASCII code
            cbw;
            cwde;
            mov edi, eax; convert the number to a dword and put in in EDI so we can use it as an index
            
            inc byte [freq + edi];at the position index = digit's value, we keep the freq of the digit
            
            
            mov bl, [max_freq];
            mov dl, [freq + edi];
            
            cmp bl, dl; check if the freq of the current digit is the max
            jge no_change;if it is, then change the corresponding variables
                mov byte [max_freq], dl;
                mov byte [max_digit], al;
            no_change:
            not_a_number:
        loop structure;
       
        
        mov al, [max_digit]; convert the bytes into dword to give as parameters
        cbw;
        cwde;
        mov edx, eax;
        mov al, [max_freq];
        cbw;
        cwde;
        
        ;int printf(const char * format, variable_1, constant_2, ...);
        ; pushing the parameter on the stack
        push dword eax;
        push dword edx;
        push dword format;  
		call [printf]       ; calling the printf function
		add esp, 4 * 3     ; cleaning the parameters from the stack
        
        final:
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
