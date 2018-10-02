%{
	#include <stdio.h>
	#include <string.h>
	#include "lista.h"
	#include "str.h"
	#include "var.h"

	int yylex();
	void yyerror(char *s){
		printf("%s\n",s);
	}

	Lista* vars;

	void clear() {
		eraser_var_list(vars, vars->cabeca);
	}
%}

%union {
	char* Str;
}

%token LET WRITE FIM S ENDL;
%token <Str> ID;
%token <Str> VALUE;
%type <Str> ely;

%%
	ely: LET ID ENDL ely {
			puts("yaya 1");
			add_var(vars, $2, "");
		}
		| LET ID '=' VALUE ENDL ely {
			puts("yaya 2");
			add_var(vars, $2, $4);
		} | ID '=' VALUE ENDL ely {
			puts("yaya 3");
			Var* var = get_var(vars, $1);
			
			if (var == NULL) {
				printf("Erro! Variável %s não encontrada!", $1);
				clear();
				exit(100);
			}

			set_str(var->value, $3);
		} | WRITE ID ENDL ely {
			puts("yaya 4");
			Var* var = get_var(vars, $2);

			if (var == NULL) {
				printf("Erro! Variável %s não encontrada!", $2);
				clear();
				exit(100);
			}

			printf("%s\n", var->value->c_str);
		} | FIM { puts("yaya 5"); } ;

%%

#include "lex.yy.c"

int main(){
	vars = cria_lista();
	yyparse();
}