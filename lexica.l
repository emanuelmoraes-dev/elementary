%{
    #include <string.h>
    #include "lista.h"
%}

W [a-zA-Z_]
C [a-zA-Z_0-9]
D [0-9]

%%

"let" { 
    // printf(">> %s, <<let>>\n", yytext);
    return LET;
}
"\n"+ {
    // printf(">> <quebra de linha>, <<ENDL>>\n");
    extern int lineno;
    lineno+=strlen(yytext);
    return ENDL;
}
"=" { 
    // printf(">> %s, <<=>>\n", yytext);
    return '=';
}
"write" { 
    // printf(">> %s, <<write>>\n", yytext); 
    return WRITE;
}
"end" {
    // printf(">> %s, <<FIM>>\n", yytext);
    return FIM;
}
{W}{C}* {
    // printf(">> %s, <<ID>>\n", yytext);
    int len = strlen(yytext);
    yylval.Str = (char*) malloc(sizeof(char) * len + 1);
    strcpy(yylval.Str, yytext);

    extern Lista* tokensStr;
    adicionar(tokensStr, yylval.Str);

    return ID;
}
"\"".*"\"" {
    // printf(">> %s, <<VALUE>>\n", yytext);
    int len = strlen(yytext);
    yylval.Str = (char*) malloc(sizeof(char) * len + 1);
    strcpy(yylval.Str, yytext+1);
    yylval.Str[len-2] = '\0';

    extern Lista* tokensStr;
    adicionar(tokensStr, yylval.Str);

    return VALUE;
}
{D}+(\.{D}+)? {
    // printf(">> %s, <<ID>>\n", yytext);
    int len = strlen(yytext);
    yylval.Str = (char*) malloc(sizeof(char) * len + 1);
    strcpy(yylval.Str, yytext);

    extern Lista* tokensStr;
    adicionar(tokensStr, yylval.Str);

    return NUM;
}
"+" {
    // printf(">> %s, <<+>>\n", yytext);
    return '+';
}
"-" {
    // printf(">> %s, <<+>>\n", yytext);
    return '-';
}
"*" {
    // printf(">> %s, <<+>>\n", yytext);
    return '*';
}
"/" {
    // printf(">> %s, <<+>>\n", yytext);
    return '/';
}
".." {
    // printf(">> %s, <<+>>\n", yytext);
    return CONCAT;
}
"(" {
    // printf(">> %s, <<(>>\n", yytext);
    return '(';
}
")" {
    // printf(">> %s, <<)>>\n", yytext);
    return ')';
}
%%
