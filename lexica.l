%{
    #include <string.h>
    #include "log.h"

    void token(const char *tipo, const char *valor) { log("<<%s>>\t : %s", tipo, valor); }
%}

W [a-zA-Z_]
C [a-zA-Z_0-9]
D [0-9]

%%

"let" { 
    token("let", yytext);
    return LET;
}
"\n" {
    token("ENDL", "<quebra de linha>");
    return ENDL;
}
"=" { 
    token("=", yytext);
    return '=';
}
"write" { 
    token("WRITE", yytext);
    return WRITE;
}
"@" {
    token("FIM", yytext);
    return FIM;
}
{W}{C}* {
    token("ID", yytext);
    int len = strlen(yytext);
    yylval.Str = (char*) malloc(sizeof(char) * len + 1);
    strcpy(yylval.Str, yytext);
    return ID;
}
"\"".*"\"" {
    token("VALUE", yytext);
    int len = strlen(yytext);
    yylval.Str = (char*) malloc(sizeof(char) * len + 1);
    strcpy(yylval.Str, yytext+1);
    yylval.Str[len-2] = '\0';
    return VALUE;
}
{D}+(\.{D}+)? {
    token("NUM", yytext);
    int len = strlen(yytext);
    yylval.Str = (char*) malloc(sizeof(char) * len + 1);
    strcpy(yylval.Str, yytext);
    return NUM;
}
"+" {
    token("+", yytext);
    return '+';
}
"-" {
    token("-", yytext);
    return '-';
}
"*" {
    token("*", yytext);
    return '*';
}
"/" {
    token("/", yytext);
    return '/';
}
".." {
    token("..", yytext);
    return CONCAT;
}
"(" {
    token("(", yytext);
    return '(';
}
")" {
    token(")", yytext);
    return ')';
}
%%
