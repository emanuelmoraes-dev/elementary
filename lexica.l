%{
    #include <string.h>
%}

W [a-zA-Z_]
C [a-zA-Z_0-9]

%%

"let" { 
    // printf(">> %s\n", yytext);
    return LET;
}
"\n" { 
    // printf(">> <quebra de linha>\n");
    return ENDL;
}
"=" { 
    // printf(">> %s\n", yytext);
    return '=';
}
"write" { 
    // printf(">> %s\n", yytext); 
    return WRITE;
}
"FIM" {
    // printf(">> %s\n", yytext);
    return FIM;
}
{W}{C}* {
    // printf(">> %s\n", yytext);
    int len = strlen(yytext);
    yylval.Str = (char*) malloc(sizeof(char) * len + 1);
    strcpy(yylval.Str, yytext);
    return ID;
}
{C}* {
    // printf(">> %s\n", yytext);
    int len = strlen(yytext);
    yylval.Str = (char*) malloc(sizeof(char) * len + 1);
    strcpy(yylval.Str, yytext);
    return VALUE; 
}
%%
