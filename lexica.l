%{
    #include <string.h>
%}

W [a-zA-Z_]
C [a-zA-Z_0-9]
CS [a-zA-Z_0-9 ]

%%

"let" { 
    // printf(">> %s\n", yytext);
    return LET;
}
"\n" {
    // printf(">> <quebra de linha>\n");
    extern int lineno; 
    lineno++;
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
"@" {
    // printf(">> %s\n", yytext);
    return FIM;
}
{W}{C}* {
    // printf(">> %s ID\n", yytext);
    int len = strlen(yytext);
    yylval.Str = (char*) malloc(sizeof(char) * len + 1);
    strcpy(yylval.Str, yytext);
    return ID;
}
"\""{CS}*"\"" {
    // printf(">> %s VALUE\n", yytext);
    int len = strlen(yytext);
    yylval.Str = (char*) malloc(sizeof(char) * len + 1);
    strcpy(yylval.Str, yytext+1);
    yylval.Str[len-2] = '\0';
    return VALUE;
}
%%
