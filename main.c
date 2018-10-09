#include <stdio.h>
#include "lista.h"
#include "str.h"
#include "var.h"

void apagarVar(void* v) {
    Var* var = (Var*) v;
    eraser_var(var);
}

int main(int argc, char** argv) {

    Lista* vars = cria_lista();

    add_var(vars, "nome", "Emanuel");

    Var* var = get_var(vars, "nome");

    puts(var->value->c_str);

    set_str(var->value, "Emanuel Moraes de Almeida");

    puts(var->value->c_str);

    apagarListaDestrutor(vars, vars->cabeca, apagarVar);

    return 0;
}