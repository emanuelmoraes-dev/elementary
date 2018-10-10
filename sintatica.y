%{
	#include <stdio.h>
	#include <string.h>
	#include "lista.h"
	#include "str.h"
	#include "var.h"

	int lineno = 0;

	int yylex();
	void yyerror(char *s){
		printf("%s\n in %d\n", s, lineno);
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
%token <Str> NUM;
%type <Str> ely;

%%
	ely: LET ID ENDL ely {
			// puts("yaya 1");
			add_var(vars, $2, "");
			free($2);
		}
		| LET ID '=' VALUE ENDL ely {
			// puts("yaya 2");
			// printf("adiconando variavél  $2 = %s, $4 = %s\n", $2,$4);
			add_var(vars, $2, $4);
			free($2);
			free($4);
		} | ID '=' VALUE ENDL ely {
			// puts("yaya 3");

			Var* var = get_var(vars, $1);

			free($1);
			
			if (var == NULL) {
				printf("Erro! Variável %s não encontrada!\n", $1);
				clear();
				free($3);
				exit(100);
			}

			set_str(var->value, $3);
			free($3);
		} | WRITE ID ENDL ely {
			// puts("yaya 4");
			Var* var = get_var(vars, $2);

			free($2);

			// printf("tamanho da lista = %d\n", vars->tamanho);

			if (var == NULL) {
				printf("Erro! Variável %s não encontrada!\n", $2);
				clear();
				exit(100);
			}

			printf("%s\n", var->value->c_str);
		} 
		| LET ID '=' NUM ENDL ely {
			// puts("yaya 2");
			// printf("adiconando variavél  $2 = %s, $4 = %s\n", $2,$4);
			add_var(vars, $2, $4);
			free($2);
			free($4);
		} | ID '=' NUM ENDL ely {
			// puts("yaya 3");

			Var* var = get_var(vars, $1);

			free($1);
			
			if (var == NULL) {
				printf("Erro! Variável %s não encontrada!\n", $1);
				clear();
				free($3);
				exit(100);
			}

			set_str(var->value, $3);
			free($3);
		} | WRITE NUM ENDL ely {
			// puts("yaya 4");
			Var* var = get_var(vars, $2);

			free($2);

			// printf("tamanho da lista = %d\n", vars->tamanho);

			if (var == NULL) {
				printf("Erro! Variável %s não encontrada!\n", $2);
				clear();
				exit(100);
			}

			printf("%s\n", var->value->c_str);
		} | FIM { /*puts("yaya 5");*/ clear(); }
		  | FIM ENDL { /*puts("yaya 6");*/ clear(); }
		  | ENDL ely { /*puts("yaya 7");*/ };

%%

#include "lex.yy.c"

int main(){
	vars = cria_lista();
	yyparse();
}