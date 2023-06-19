bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

extern exit,printf,scanf
import exit msvcrt.dll
import printf msvcrt.dll
import scanf msvcrt.dll  
                          
extern concat
                          
; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    ;Three strings (of characters) are read from the keyboard. Identify and display the result of their concatenation.
    
    format db "%s", 0;
    
    s1 times 100 db 0;
    s2 times 100 db 0;
    s3 times 100 db 0;
    
    sr times 300 db 0;
    
segment code use32 class=code
    start:
        ; ...
        
         push dword s1       
         push dword format
         call [scanf]       
         add esp, 4 * 2
         
         push dword s2       
         push dword format
         call [scanf]       
         add esp, 4 * 2
         
         push dword s3      
         push dword format
         call [scanf]       
         add esp, 4 * 2
         
         push dword sr
         push dword s3
         push dword s2
         push dword s1
         call concat
         
         
         push dword sr
         push dword format
         call [printf]
         add esp, 2*4
                          
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
