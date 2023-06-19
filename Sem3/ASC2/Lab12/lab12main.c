#include <stdio.h>

int asmConcat(char* string1, char* string2, char* string3, char* stringConcat);
void asmPrint(char* stringConcat);

int main()
{
    char string1[100], string2[100], string3[100], stringConcat[300];
    printf("Input strings:\n");
    printf("String 1:");
    scanf("%s", &string1);
    printf("String 2:");
    scanf("%s", &string2);
    printf("String 3:");
    scanf("%s", &string3);
    printf("s1=%s s2=%s s3=%s\n", string1, string2, string3);
    
    asmConcat(string1, string2, string3, stringConcat);
    asmPrint(stringConcat);
    
    return 0;
}
