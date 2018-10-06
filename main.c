#include <stdio.h>
#include "lista.h"
#include "str.h"
#include "var.h"

int main(int argc, char** argv) {

    Lista* vars = cria_lista();

    

    eraser_var_list(vars, vars->cabeca);

    return 0;
}