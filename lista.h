#ifndef LISTA_H_INCLUDED
#define LISTA_H_INCLUDED

#include <stdlib.h>
#include <string.h>

// funções que manipulam a lista

// criando um elemento da lista
typedef struct st_elemento {
    void* valor;
    struct st_elemento* proximo;
} Elemento;

// cria tipo lista
typedef struct st_lista {
    Elemento* cabeca;
    Elemento* ultimo;
    int tamanho;
} Lista;


// retorna um novo elemento vazio para lista
Elemento* cria_elemento() {
    Elemento* elemento = (Elemento*) malloc(sizeof(Elemento));

    elemento->valor = NULL;
    elemento->proximo = NULL;

    return elemento;
}

// cria e retorna uma nova lista vazia
Lista* cria_lista() {
    Lista* lista = (Lista*) malloc(sizeof(Lista));
    lista->cabeca = cria_elemento();
    lista->ultimo = lista->cabeca;
    lista->tamanho = 0;
    return lista;
}

// adiciona um elemento na lista
void adicionar(Lista* lista, void* valor) {
    lista->ultimo->proximo = cria_elemento();
    lista->ultimo->proximo->valor = valor;
    lista->ultimo = lista->ultimo->proximo;
    lista->tamanho++;
}

// busca um elemento da lista que possui a posição fornecida pelo usuario
Elemento* buscarPorPosicao(Lista* lista, int posicao) {
    int id = -1; // Mudado! Linha ainda para testar!
    for (Elemento* it = lista->cabeca; it != NULL; it = it->proximo)
        if (id++ == posicao)
            return it;
    return NULL;
}

// adiciona um elemento na lista na posicao informada
void adicionarEm(Lista* lista, void* valor, int posicao) {
    Elemento* ant = buscarPorPosicao(lista, posicao-1);
    Elemento* prx = ant->proximo;
    ant->proximo = cria_elemento();
    ant->proximo->valor = valor;
    ant->proximo->proximo = prx;
    if (prx == NULL)
        lista->ultimo = ant->proximo;
    lista->tamanho++;
}

// apaga da memoria o elemento que vem depois do elemento recebido
void apagarProximo(Lista* lista, Elemento* elemento) {
    if (lista->tamanho == 0)
        return;
    Elemento* alvo = elemento->proximo; // Elemento que eu quero remover
    elemento->proximo = alvo->proximo; // Alvo é excluido da lista
    free(alvo->valor); // Valor do alvo é excluido da memória
    free(alvo); // Alvo é excluido da memária RAM
    lista->tamanho--;
}

// apaga da memoria o elemento recebido, o elemento mesmo
void apagarPorElemento(Lista* lista, void* valor) {
    for (Elemento* it = lista->cabeca; it->proximo != NULL; it = it->proximo) {
        if (it->proximo->valor == valor) {
            apagarProximo(lista, it);
            break;
        }
    }
}

// apaga elemento da memoria que possui o id recebido , o elemento mesmo
void apagarPorPosicao(Lista* lista, int posicao) {
    Elemento* c = buscarPorPosicao(lista, posicao-1);
    apagarProximo(lista, c);
}

// remove da lista sem remover da memoria o elemento que vem depois do elemento recebido
void* removerProximo(Lista* lista, Elemento* elemento) {
    if (lista->tamanho == 0)
        return NULL;
    Elemento* alvo = elemento->proximo; // Elemento que eu quero remover
    elemento->proximo = alvo->proximo; // Alvo é excluido da lista
    void* valor = alvo->valor;
    free(alvo); // Alvo é excluido da memária RAM
    lista->tamanho--;
    return valor;
}

// remove  da lista sem remover da memoria o elemento recebido, o elemento mesmo
void* removerPorElemento(Lista* lista, void* valor) {
    for (Elemento* it = lista->cabeca; it->proximo != NULL; it = it->proximo) {
        if (it->proximo->valor == valor) {
            return removerProximo(lista, it);
        }
    }
}

// remove da lista sem remover da memoria o elemento que possui o id recebido 
void* removerPorPosicao(Lista* lista, int posicao) {
    Elemento* c = buscarPorPosicao(lista, posicao-1);
    return removerProximo(lista, c);
}

// apaga a lista e os elementos da lista da memoria
void apagarLista(Lista* lista, Elemento* elemento) {
    if (elemento == NULL) return;
    if (elemento->proximo == NULL) return;
    apagarLista(lista, elemento->proximo);
    apagarProximo(lista, elemento);
}

void apagarListaDestrutor(Lista* lista, Elemento* elemento, void (*destrutor)(void*)) {
    if (elemento == NULL) return;
    if (elemento->proximo == NULL) return;
    apagarListaDestrutor(lista, elemento->proximo, destrutor);
    void* valor = removerProximo(lista, elemento);
    destrutor(valor);
}

// remove a lista da memoria sem remover os contatdos da lista da memoria
void removerLista(Lista* lista, Elemento* elemento) {
    if (elemento == NULL) return;
    if (elemento->proximo == NULL) return;
    removerLista(lista, elemento->proximo);
    removerProximo(lista, elemento);
}

// Adiciona no topo da lista
void adicionarTopo(Lista* lista, void* valor) {
    adicionarEm(lista, valor, 0);
}

// Retorna o valor do topo da lista
void* topo(Lista* lista) {
    if (lista->tamanho == 0)
        return NULL;
    return lista->cabeca->proximo->valor;
}

// Remove elemento do topo da lista
void* removerTopo(Lista* lista) {
    return removerProximo(lista, lista->cabeca);
}

// Remove e apaga da memória elemento do topo da lista
void apagarTop(Lista* lista) {
    apagarProximo(lista, lista->cabeca);
}

#endif // LISTA_H_INCLUDED