#ifndef VAR_H_INCLUDED
#define VAR_H_INCLUDED

#include "str.h"
#include "lista.h"

typedef struct st_var {
    String* key;
    String* value;
} Var;

Var* new_var(const char * key, const char* value) {
    Var* var = (Var*) malloc(sizeof(Var));
    var->key = new_str(key);
    var->value = new_str(value);
    return var;
}

void add_var(Lista* lista, const char* key, const char* value) {
    Var* var = new_var(key, value);
    adicionar(lista, (void*) var);
}

Var* get_var(Lista* lista, const char* key) {
    Var* var = NULL;
    for (Elemento* it = lista->cabeca; it != NULL; it = it->proximo)
        if (it != lista->cabeca) {
            Var* v = (Var*) it->valor;
            if (strcmp(v->key->c_str, key) == 0) {
                var = v;
                break;
            }
        }
    return var;
}

void eraser_var(Var* var) {
    eraser_str(var->key);
    eraser_str(var->value);
    free(var);
}

void eraser_var_list(Lista* lista, Elemento* elemento) {
    for (Elemento* it = lista->cabeca->proximo; it != NULL; it = it->proximo) {
        Var* var = (Var*) it->valor;
        eraser_var(var);
    }

    removerLista(lista, lista->cabeca);
}

#endif // VAR_H_INCLUDED