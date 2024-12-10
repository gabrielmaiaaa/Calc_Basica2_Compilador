#include "tabela.h"

// Inicializa a tabela de símbolos
void inicializaTabela(TabelaSimbolos *tabela) {
    tabela->primeiro = NULL;
}

// Adiciona um símbolo à tabela
void adicionaSimbolo(TabelaSimbolos *tabela, const char *nome, const char *tipo) {
    Simbolo *novo = (Simbolo *)malloc(sizeof(Simbolo));
    if (!novo) {
        fprintf(stderr, "Erro de alocação de memória\n");
        exit(1);
    }
    novo->nome = strdup(nome);
    novo->tipo = strdup(tipo);
    novo->prox = tabela->primeiro;
    tabela->primeiro = novo;
}

// Busca um símbolo na tabela
Simbolo* buscaSimbolo(TabelaSimbolos *tabela, const char *nome) {
    Simbolo *atual = tabela->primeiro;
    while (atual) {
        if (strcmp(atual->nome, nome) == 0) {
            return atual;
        }
        atual = atual->prox;
    }
    return NULL;
}

// Libera a tabela de símbolos
void liberaTabela(TabelaSimbolos *tabela) {
    Simbolo *atual = tabela->primeiro;
    while (atual) {
        Simbolo *temp = atual;
        atual = atual->prox;
        free(temp->nome);
        free(temp->tipo);
        free(temp);
    }
    tabela->primeiro = NULL;
}

// Exibe os símbolos da tabela
void exibeTabela(TabelaSimbolos *tabela) {
    Simbolo *atual = tabela->primeiro;
    printf("\nTabela de Símbolos:\n");
    while (atual) {
        printf("Nome: %s, Tipo: %s\n", atual->nome, atual->tipo);
        atual = atual->prox;
    }
}

// Checa se a variável já foi declarada
void checaDeclaracaoDuplicada(TabelaSimbolos *tabela, const char *nome, const char *tipo) {
    if (buscaSimbolo(tabela, nome)) {
        fprintf(stderr, "Erro: Variável '%s' já declarada!\n", nome);
        exit(1);
    } else {
        adicionaSimbolo(tabela, nome, tipo);
    }
}
