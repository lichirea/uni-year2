bits 32
; informing the assembler of the exitence of the function _readString and the variable _str3

; in Windows, the nasm directive import can be used only for obj files!! we will create a win32 file, the printf function will be imported as follows (according to the NASM documentation)
extern _printf
; informing the assembler that we want to make the _asmConcat function available for other modules
global _asmConcat
; the linkeditor can use the public data segment also for data from outside
segment data public data use32
    StringAddress2        dd        0
    StringAddress1        dd        0
    StringAddress3        dd        0
    resultString          dd 0;
; the assembly code is included in segment public, possible to be shared with another extern code
segment code public code use32
; stdcall convention
_asmConcat:
    ; creating a stack frame for the called program
    push ebp
    mov ebp, esp
                 

    
    mov eax, [ebp + 20]
    mov [resultString], eax
    mov eax, [ebp + 16]
    mov [StringAddress3], eax
    mov eax, [ebp + 12]
    mov [StringAddress2], eax
    mov eax, [ebp + 8]
    mov [StringAddress1], eax

    

    cld
    mov edi, [resultString]
    mov esi, [StringAddress1]
    mov ecx, 100
    rep1:
        lodsb
        mov bl, 0;
        cmp bl, al
        je rep1done
        dec esi
        movsb
    loop rep1
    rep1done:

    
    mov esi, [StringAddress2]
    mov ecx, 100
    rep2:
        lodsb
        mov bl, 0;
        cmp bl, al
        je rep2done
        dec esi
        movsb
    loop rep2
    rep2done:

    
    mov esi, [StringAddress3]
    mov ecx, 100
    rep3:
        lodsb
        mov bl, 0;
        cmp bl, al
        je rep3done
        dec esi
        movsb
    loop rep3
    rep3done:
    


    mov esp, ebp
    pop ebp
    ; the two instruction which restore the stack frame can be replaced with the instruction leave
    ; return the address of the obtained string as a result in eax 
    mov eax, resultString
    ret
    ; stdcall convention - it is the responsibility of the caller program to free the parameters of the function from the stack