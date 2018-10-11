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
			String* e = removerTopo(stack);
      log("LET ID(=%s) = e(=%s) ENDL", $2, e->c_str);
			add_var(vars, $2, e->c_str);
			free($2);
			eraser_str(e);
		} | ID '=' e ENDL ely {
			String* e = removerTopo(stack);
      log("ID(=%s) = e(=%s) ENDL", $1, e->c_str);

			Var* var = get_var(vars, e->c_str);

			free($1);
			
			if (var == NULL) {
				error("Variável %s não encontrada!\n", $1);
				clear();
				eraser_str(e);
				exit(101);
			}

			set_str(var->value, e->c_str);
			eraser_str(e);
		} | WRITE e ENDL ely {
			String* e = removerTopo(stack);
      log("WRITE e(=%s) ENDL", e->c_str);
			eraser_str(e);
		} | FIM { log("FIM"); }
		  | FIM ENDL { log("FIM ENDL"); }
		  | ENDL ely { log("ely"); } ;
	e: t e_ | t;
	e_: '+' t e_ {
			String* termo = (String*) removerTopo(stack);
			String* r = (String*) removerTopo(stack);
      log("+ t(=%s) e_(=%s)", termo->c_str, r->c_str);

			double e1, e2;
			sscanf(termo->c_str, "%lf", &e1);
			sscanf(r->c_str, "%lf", &e2);

			double result = e1 + e2;
			char result_str[ len_double(result, PRECISION_DEFAULT) + 1 ];
			sprintf(result_str, "%lf", result);

			adicionarTopo(stack, (void*) new_str(result_str));
			eraser_str(termo);
			eraser_str(r);
		} | '+' t {
			String* termo = (String*) removerTopo(stack);
			String* r = (String*) removerTopo(stack);
      log("+ t(=%s) e_(=%s)", termo->c_str, r->c_str);

			double e1, e2;
			sscanf(termo->c_str, "%lf", &e1);
			sscanf(r->c_str, "%lf", &e2);

			double result = e1 + e2;
			char result_str[ len_double(result, PRECISION_DEFAULT) + 1 ];
			sprintf(result_str, "%lf", result);

			adicionarTopo(stack, (void*) new_str(result_str));
			eraser_str(termo);
			eraser_str(r);
		} | '-' t e_ {
			String* termo = (String*) removerTopo(stack);
			String* r = (String*) removerTopo(stack);
      log("- t(=%s) e_(=%s)", termo->c_str, r->c_str);

			double e1, e2;
			sscanf(termo->c_str, "%lf", &e1);
			sscanf(r->c_str, "%lf", &e2);

			double result = e1 - e2;
			char result_str[ len_double(result, PRECISION_DEFAULT) + 1 ];
			sprintf(result_str, "%lf", result);

			adicionarTopo(stack, (void*) new_str(result_str));
			eraser_str(termo);
			eraser_str(r);
		} | '-' t {
			String* termo = (String*) removerTopo(stack);
			String* r = (String*) removerTopo(stack);
      log("+ t(=%s) e_(=%s)", termo->c_str, r->c_str);
			
      double e1, e2;
			sscanf(termo->c_str, "%lf", &e1);
			sscanf(r->c_str, "%lf", &e2);
			
      double result = e1 - e2;
			char result_str[ len_double(result, PRECISION_DEFAULT) + 1 ];
			sprintf(result_str, "%lf", result);
			
      adicionarTopo(stack, (void*) new_str(result_str));
			eraser_str(termo);
			eraser_str(r);
		} ;
	t: f t_ | f;
	t_: '*' f t_ {
			String* fator = (String*) removerTopo(stack);
			String* r = (String*) removerTopo(stack);
      log("* f(=%s) t_(=%s)", fator->c_str, r->c_str);
			
      double e1, e2;
			sscanf(fator->c_str, "%lf", &e1);
			sscanf(r->c_str, "%lf", &e2);
			
      double result = e1 * e2;
			char result_str[ len_double(result, PRECISION_DEFAULT) + 1 ];
			sprintf(result_str, "%lf", result);
			
      adicionarTopo(stack, (void*) new_str(result_str));
			eraser_str(fator);
			eraser_str(r);
		} | '*' f {
			String* fator = (String*) removerTopo(stack);
			String* r = (String*) removerTopo(stack);
      log("* f(=%s) e_(=%s)", fator->c_str, r->c_str);
			
      double e1, e2;
			sscanf(fator->c_str, "%lf", &e1);
			sscanf(r->c_str, "%lf", &e2);
			
      double result = e1 * e2;
			char result_str[ len_double(result, PRECISION_DEFAULT) + 1 ];
			sprintf(result_str, "%lf", result);
			
      adicionarTopo(stack, (void*) new_str(result_str));
			eraser_str(fator);
			eraser_str(r);
		} | '/' f t_ {
			String* fator = (String*) removerTopo(stack);
			String* r = (String*) removerTopo(stack);
      log("/ f(=%s) e_(=%s)", fator->c_str, r->c_str);
			
      double e1, e2;
			sscanf(fator->c_str, "%lf", &e1);
			sscanf(r->c_str, "%lf", &e2);

			if (e2 >= -PRECISION_DEFAULT && e2 <= PRECISION_DEFAULT) {
				error("Divisão por zero inválida!");
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
		} | '/' f {
			String* fator = (String*) removerTopo(stack);
			String* r = (String*) removerTopo(stack);
      log("/ f(=%s) e_(=%s)", fator->c_str, r->c_str);
			
      double e1, e2;
			sscanf(fator->c_str, "%lf", &e1);
			sscanf(r->c_str, "%lf", &e2);

			if (e2 >= -PRECISION_DEFAULT && e2 <= PRECISION_DEFAULT) {
				error("Divisão por zero inválida!");
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
		} | CONCAT f t_ {
			String* fator = (String*) removerTopo(stack);
			String* r = (String*) removerTopo(stack);
      log(".. f(=%s) e_(=%s)", fator->c_str, r->c_str);
			
      String* result = new_str(fator->c_str);
			cat_str(result, r->c_str);
			
      adicionarTopo(stack, (void*) result);
			eraser_str(fator);
			eraser_str(r);
		} | CONCAT f {
			String* fator = (String*) removerTopo(stack);
			String* r = (String*) removerTopo(stack);
      log(".. f(=%s) e_(=%s)", fator->c_str, r->c_str);
			
      String* result = new_str(fator->c_str);
			cat_str(result, r->c_str);
			
      adicionarTopo(stack, (void*) result);
			eraser_str(fator);
			eraser_str(r);
		};
	f: '(' e ')'
		| VALUE {
      log("VALUE(=%s)", $1);
			adicionarTopo(stack, (void*) new_str($1));
			free($1);
		} | NUM {
      log("NUM(=%s)", $1);
			adicionarTopo(stack, (void*) new_str($1));
			free($1);
		} | ID {
      log("ID(=%s)", $1);
			Var* var = get_var(vars, $1);

			if (var == NULL) {
				error("A Variável '%s' não foi declarada!\n", $1);
				free($1);
				clear();
				exit(101);
			}

			free($1);
			adicionarTopo(stack, (void*) new_str(var->value->c_str));
		} ;

%%

#include "lex.yy.c"

int main(){
	vars = cria_lista();
	stack = cria_lista();
	yyparse();
	clear();
}
