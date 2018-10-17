%{
	#include <stdio.h>
	#include <string.h>
	#include "lista.h"
	#include "str.h"
	#include "var.h"
	#include "util.h"

	int lineno = 1;

	Lista* vars;
	Lista* stack;
	Lista* tokensStr;

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
		apagarLista(tokensStr, tokensStr->cabeca);
	}

	int yylex();
	void yyerror(char *s){
		printf("Error %s in line %d\n", s, lineno);
		clear();
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
	start: ely ENDL start
			| FIM { /*puts("yaya 5");*/ }
		    | FIM ENDL { /*puts("yaya 6");*/ }
		    | ENDL start { /*puts("yaya 7");*/ };
	ely: LET ID {
			// puts("yaya 1");

			Var* var = get_var(vars, $2);

			if (var != NULL) {
				printf("Erro na linha %d! Variável '%s' já declarada!\n", lineno-1, $2);
				clear();
				exit(102);
			}

			add_var(vars, $2, "");
			// puts("end Yaya 1");
		}
		| LET ID '=' e {
			// puts("yaya 2");

			Var* var = get_var(vars, $2);

			if (var != NULL) {
				printf("Erro na linha %d! Variável '%s' já declarada!\n", lineno-1, $2);
				clear();
				exit(102);
			}

			String* e = removerTopo(stack);
			// printf("adiconando variavél  $2 = %s, $4 = %s\n", $2, e->c_str);
			add_var(vars, $2, e->c_str);
			eraser_str(e);
			// puts("end Yaya 2");
		} | ID '=' e {
			// puts("yaya 3");

			Var* var = get_var(vars, $1);

			if (var == NULL) {
				printf("Erro na linha %d! Variável '%s' não encontrada!\n", lineno-1, $1);
				clear();
				exit(101);
			}

			String* e = removerTopo(stack);

			set_str(var->value, e->c_str);
			eraser_str(e);
			// puts("end yaya 3");
		} | WRITE e {
			// puts("yaya 4");
			String* e = removerTopo(stack);
			printf("%s\n", e->c_str);
			eraser_str(e);
			// puts("end Yaya 4");
		} ;
	e: exp e_ | exp;
	e_: CONCAT exp e_ {
			// puts("Concatenação");
			String* fator = (String*) removerTopo(stack);
			String* r = (String*) removerTopo(stack);
			// printf("%s..%s\n", fator->c_str, r->c_str);
			String* result = new_str(r->c_str);
			cat_str(result, fator->c_str);
			adicionarTopo(stack, (void*) result);
			eraser_str(fator);
			eraser_str(r);
			// puts("end Concatenação");
		} | CONCAT exp {
			// puts("Concatenação");
			String* fator = (String*) removerTopo(stack);
			String* r = (String*) removerTopo(stack);
			// printf("%s..%s\n", fator->c_str, r->c_str);
			String* result = new_str(r->c_str);
			cat_str(result, fator->c_str);
			adicionarTopo(stack, (void*) result);
			eraser_str(fator);
			eraser_str(r);
			// puts("end Concatenação");
		};
	exp: t exp_ | t;
	exp_: '+' t exp_ {
			// puts("SOMA");
			String* termo = (String*) removerTopo(stack);
			String* r = (String*) removerTopo(stack);
			// printf("%s+%s\n", termo->c_str, r->c_str);
			double e1, e2;
			sscanf(termo->c_str, "%lf", &e1);
			sscanf(r->c_str, "%lf", &e2);
			double result = e2 + e1;
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
			double result = e2 + e1;
			char result_str[ len_double(result, PRECISION_DEFAULT) + 1 ];
			sprintf(result_str, "%lf", result);
			adicionarTopo(stack, (void*) new_str(result_str));
			eraser_str(termo);
			eraser_str(r);
			// puts("end Soma");
		} | '-' t exp_ {
			// puts("Subtração");
			String* termo = (String*) removerTopo(stack);
			String* r = (String*) removerTopo(stack);
			// printf("%s-%s\n", termo->c_str, r->c_str);
			double e1, e2;
			sscanf(termo->c_str, "%lf", &e1);
			sscanf(r->c_str, "%lf", &e2);
			double result = e2 - e1;
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
			// printf("%s-%s\n", termo->c_str, r->c_str);
			double e1, e2;
			sscanf(termo->c_str, "%lf", &e1);
			sscanf(r->c_str, "%lf", &e2);
			double result = e2 - e1;
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
			// printf("%s*%s\n", fator->c_str, r->c_str);
			double e1, e2;
			sscanf(fator->c_str, "%lf", &e1);
			sscanf(r->c_str, "%lf", &e2);
			double result = e2 * e1;
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
			double result = e2 * e1;
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

			if (e1 >= -PRECISION_DEFAULT && e1 <= PRECISION_DEFAULT) {
				printf("Erro na linha %d! Divisão por zero inválida!", lineno-1);
				eraser_str(fator);
				eraser_str(r);
				clear();
				exit(100);
			}

			double result = e2 / e1;
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

			if (e1 >= -PRECISION_DEFAULT && e1 <= PRECISION_DEFAULT) {
				printf("Erro na linha %d! Divisão por zero inválida!", lineno-1);
				eraser_str(fator);
				eraser_str(r);
				clear();
				exit(100);
			}

			double result = e2 / e1;
			char result_str[ len_double(result, PRECISION_DEFAULT) + 1 ];
			sprintf(result_str, "%lf", result);
			adicionarTopo(stack, (void*) new_str(result_str));
			eraser_str(fator);
			eraser_str(r);
			// puts("End Divisão");
		};
	f: '(' e ')'
		| VALUE {
			// puts("Value");
			adicionarTopo(stack, (void*) new_str($1));
			// puts("end Value");
		} | NUM {
			// puts("Num");
			adicionarTopo(stack, (void*) new_str($1));
			// puts("end Num");
		} | ID {
			// puts("Id");
			Var* var = get_var(vars, $1);

			if (var == NULL) {
				// puts("WTF!");
				printf("Erro na linha %d! A Variável '%s' não foi declarada!\n", lineno-1, $1);
				// puts("WTW!");
				clear();
				exit(101);
			}
			// puts("2");

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
	tokensStr = cria_lista();
	yyparse();
	clear();
}