#include <stdio.h>
#include "lista.h"
#include "str.h"
#include "var.h"

int main(int argc, char** argv) {

    Lista* vars = cria_lista();

    add_var(vars, "nome", "Emanuel");
    add_var(vars, "idade", "21");

    Var* nome = get_var(vars, "nome");
    Var* idade = get_var(vars, "idade");

    puts(nome->value->c_str);
    puts(idade->value->c_str);

    set_str(idade->value, "22");

    puts(idade->value->c_str);

    eraser_var_list(vars, vars->cabeca);

    return 0;
}