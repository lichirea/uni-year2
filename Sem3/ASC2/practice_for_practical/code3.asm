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

    message db 'Hello! Adsa', 0
    format db 'Hello';
    format2 db 'Its me';
; our code starts here
segment code use32 class=code
    start:
        ; ...
         push dword format
         call [printf]
         add esp, 4 * 2
         push dword format2
         call [printf]
         add esp, 4 * 2
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
