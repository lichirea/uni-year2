bits 32 ; assembling for the 32 bits architecture
extern _printf
; informing the assembler that we want to make the _asmPrint function available for other modules
global _asmPrint
; our data is declared here (the variables needed by our program)
segment data public data use32
    ; ...

; our code starts here
segment code public code use32
;asmPrint(char[])
_asmPrint:
        ; creating a stack frame for the called program
        push ebp
        mov ebp, esp

        ; at the location [ebp+4] we have the return address (the value of EIP at the moment of the call)
        ; at the location [ebp] we have the value of ebp for the caller
        mov eax, [ebp + 8]

        push dword eax
        call _printf
        add esp, 4*1

        mov esp, ebp
        pop ebp
        ; the two instruction which restore the stack frame can be replaced with the instruction leave
        ret