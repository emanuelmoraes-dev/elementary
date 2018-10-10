%{
	#include <stdio.h>
	#include <string.h>
	#include "lista.h"
	#include "str.h"
	#include "var.h"
	#include "util.h"
  #include "log.h"

	int yylex();
	void yyerror(char *s){
		error("%s", s);
	}

	Lista* vars;
	Lista* stack;

	void apagarVar(void* v) {
		Var* var = (Var*) v;
		eraser_var(var);
	}

	void apagarString(void* v) {
		String* str = (String*) v;
		eraser_str(str);
	}

	void clear() {
		apagarListaDestrutor(vars, vars->cabeca, apagarVar);
		apagarListaDestrutor(stack, stack->cabeca, apagarString);
	}
%}

%union {
	char* Str;
}

%token LET WRITE FIM S ENDL CONCAT;
%token <Str> ID;
%token <Str> VALUE;
%token <Str> NUM;
%type <Str> ely;

%%
ely: LET ID ENDL ely {
      log("LET ID(=%s) ENDL", $2);
			add_var(vars, $2, "");
			free($2);
		}
		| LET ID '=' e ENDL ely {
			// puts("yaya 2");
			String* e = removerTopo(stack);
			printf("adiconando variavél  $2 = %s, $4 = %s\n", $2, e->c_str);
			add_var(vars, $2, e->c_str);
			free($2);
			eraser_str(e);
			// puts("end Yaya 2");
		} | ID '=' e ENDL ely {
			// puts("yaya 3");

			String* e = removerTopo(stack);

			Var* var = get_var(vars, e->c_str);

			free($1);
			
			if (var == NULL) {
				printf("Erro! Variável %s não encontrada!\n", $1);
				clear();
				eraser_str(e);
				exit(101);
			}

			set_str(var->value, e->c_str);
			eraser_str(e);
			// puts("end yaya 3");
		} | WRITE e ENDL ely {
			// puts("yaya 4");
			String* e = removerTopo(stack);
			printf("%s\n", e->c_str);
			eraser_str(e);
			// puts("end Yaya 4");
		} | FIM { /*puts("yaya 5");*/ }
		  | FIM ENDL { /*puts("yaya 6");*/ }
		  | ENDL ely { /*puts("yaya 7");*/ } ;
	e: t e_ | t;
	e_: '+' t e_ {
			// puts("SOMA");
			String* termo = (String*) removerTopo(stack);
			String* r = (String*) removerTopo(stack);
			// printf("%s+%s\n", termo->c_str, r->c_str);
			double e1, e2;
			sscanf(termo->c_str, "%lf", &e1);
			sscanf(r->c_str, "%lf", &e2);
			double result = e1 + e2;
			char result_str[ len_double(result, PRECISION_DEFAULT) + 1 ];
			sprintf(result_str, "%lf", result);
			adicionarTopo(stack, (void*) new_str(result_str));
			eraser_str(termo);
			eraser_str(r);
			// puts("end Soma");
		} | '+' t {
			// puts("SOMA");
			String* termo = (String*) removerTopo(stack);
			String* r = (String*) removerTopo(stack);
			// printf("%s+%s\n", termo->c_str, r->c_str);
			double e1, e2;
			sscanf(termo->c_str, "%lf", &e1);
			sscanf(r->c_str, "%lf", &e2);
			double result = e1 + e2;
			char result_str[ len_double(result, PRECISION_DEFAULT) + 1 ];
			sprintf(result_str, "%lf", result);
			adicionarTopo(stack, (void*) new_str(result_str));
			eraser_str(termo);
			eraser_str(r);
			// puts("end Soma");
		} | '-' t e_ {
			// puts("Subtração");
			String* termo = (String*) removerTopo(stack);
			String* r = (String*) removerTopo(stack);
			// printf("%s-%s\n", termo->c_str, r->c_str);
			double e1, e2;
			sscanf(termo->c_str, "%lf", &e1);
			sscanf(r->c_str, "%lf", &e2);
			double result = e1 - e2;
			char result_str[ len_double(result, PRECISION_DEFAULT) + 1 ];
			sprintf(result_str, "%lf", result);
			adicionarTopo(stack, (void*) new_str(result_str));
			eraser_str(termo);
			eraser_str(r);
			// puts("end Subtração");
		} | '-' t {
			// puts("Subtração");
			String* termo = (String*) removerTopo(stack);
			String* r = (String*) removerTopo(stack);
			printf("%s-%s\n", termo->c_str, r->c_str);
			double e1, e2;
			sscanf(termo->c_str, "%lf", &e1);
			sscanf(r->c_str, "%lf", &e2);
			double result = e1 - e2;
			char result_str[ len_double(result, PRECISION_DEFAULT) + 1 ];
			sprintf(result_str, "%lf", result);
			adicionarTopo(stack, (void*) new_str(result_str));
			eraser_str(termo);
			eraser_str(r);
			// puts("end Subtração");
		} ;
	t: f t_ | f;
	t_: '*' f t_ {
			// puts("Multiplicação");
			String* fator = (String*) removerTopo(stack);
			String* r = (String*) removerTopo(stack);
			printf("%s*%s\n", fator->c_str, r->c_str);
			double e1, e2;
			sscanf(fator->c_str, "%lf", &e1);
			sscanf(r->c_str, "%lf", &e2);
			double result = e1 * e2;
			char result_str[ len_double(result, PRECISION_DEFAULT) + 1 ];
			sprintf(result_str, "%lf", result);
			adicionarTopo(stack, (void*) new_str(result_str));
			eraser_str(fator);
			eraser_str(r);
			// puts("end Multiplicação");
		} | '*' f {
			// puts("Multiplicação");
			String* fator = (String*) removerTopo(stack);
			String* r = (String*) removerTopo(stack);
			// printf("%s*%s\n", fator->c_str, r->c_str);
			double e1, e2;
			sscanf(fator->c_str, "%lf", &e1);
			sscanf(r->c_str, "%lf", &e2);
			double result = e1 * e2;
			char result_str[ len_double(result, PRECISION_DEFAULT) + 1 ];
			sprintf(result_str, "%lf", result);
			adicionarTopo(stack, (void*) new_str(result_str));
			eraser_str(fator);
			eraser_str(r);
			// puts("end Multiplicação");
		} | '/' f t_ {
			// puts("divisão");
			String* fator = (String*) removerTopo(stack);
			String* r = (String*) removerTopo(stack);
			// printf("%s/%s\n", fator->c_str, r->c_str);
			double e1, e2;
			sscanf(fator->c_str, "%lf", &e1);
			sscanf(r->c_str, "%lf", &e2);

			if (e2 >= -PRECISION_DEFAULT && e2 <= PRECISION_DEFAULT) {
				printf("Erro: Divisão por zero inválida!");
				eraser_str(fator);
				eraser_str(r);
				clear();
				exit(100);
			}

			double result = e1 / e2;
			char result_str[ len_double(result, PRECISION_DEFAULT) + 1 ];
			sprintf(result_str, "%lf", result);
			adicionarTopo(stack, (void*) new_str(result_str));
			eraser_str(fator);
			eraser_str(r);
			// puts("end Divisao");
		} | '/' f {
			// puts("Divisão");
			String* fator = (String*) removerTopo(stack);
			String* r = (String*) removerTopo(stack);
			// printf("%s/%s\n", fator->c_str, r->c_str);
			double e1, e2;
			sscanf(fator->c_str, "%lf", &e1);
			sscanf(r->c_str, "%lf", &e2);

			if (e2 >= -PRECISION_DEFAULT && e2 <= PRECISION_DEFAULT) {
				printf("Erro: Divisão por zero inválida!");
				eraser_str(fator);
				eraser_str(r);
				clear();
				exit(100);
			}

			double result = e1 / e2;
			char result_str[ len_double(result, PRECISION_DEFAULT) + 1 ];
			sprintf(result_str, "%lf", result);
			adicionarTopo(stack, (void*) new_str(result_str));
			eraser_str(fator);
			eraser_str(r);
			// puts("End Divisão");
		} | CONCAT f t_ {
			// puts("Concatenação");
			String* fator = (String*) removerTopo(stack);
			String* r = (String*) removerTopo(stack);
			// printf("%s..%s\n", fator->c_str, r->c_str);
			String* result = new_str(fator->c_str);
			cat_str(result, r->c_str);
			adicionarTopo(stack, (void*) result);
			eraser_str(fator);
			eraser_str(r);
			// puts("end Concatenação");
		} | CONCAT f {
			// puts("Concatenação");
			String* fator = (String*) removerTopo(stack);
			String* r = (String*) removerTopo(stack);
			printf("%s..%s\n", fator->c_str, r->c_str);
			String* result = new_str(fator->c_str);
			cat_str(result, r->c_str);
			adicionarTopo(stack, (void*) result);
			eraser_str(fator);
			eraser_str(r);
			// puts("end Concatenação");
		};
	f: '(' e ')'
		| VALUE {
			// puts("Value");
			adicionarTopo(stack, (void*) new_str($1));
			free($1);
			// puts("end Value");
		} | NUM {
			// puts("Num");
			adicionarTopo(stack, (void*) new_str($1));
			free($1);
			// puts("end Num");
		} | ID {
			// puts("Id");
			Var* var = get_var(vars, $1);

			if (var == NULL) {
				// puts("WTF!");
				printf("Erro: A Variável '%s' não foi declarada!\n", $1);
				free($1);
				// puts("WTW!");
				clear();
				exit(101);
			}
			// puts("2");

			free($1);
			// puts("3");
			adicionarTopo(stack, (void*) new_str(var->value->c_str));
			// puts("4");
			// puts("end Id");
		} ;

%%

#include "lex.yy.c"

int main(){
	vars = cria_lista();
	stack = cria_lista();
	yyparse();
	clear();
}
