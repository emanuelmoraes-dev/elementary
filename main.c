#include <stdio.h>
#include "lista.h"
#include "str.h"
#include "var.h"

int main(int argc, char** argv) {

    Lista* vars = cria_lista();

    add_var(vars, "nome", "Emanuel");

    Var* var = get_var(vars, "nome");

    puts(var->value->c_str);

    set_str(var->value, "Emanuel Moraes de Almeida");

    puts(var->value->c_str);

    eraser_var_list(vars, vars->cabeca);

    return 0;
}