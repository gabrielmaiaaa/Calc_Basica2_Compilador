#ifndef TABELA_H
#define TABELA_H

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Estrutura para representar um símbolo
typedef struct Simbolo {
    char *nome;         // Nome da variável
    char *tipo;         // Tipo da variável (ex: "INTEIRO", "REAL")
    struct Simbolo *prox; // Ponteiro para o próximo símbolo (para lista encadeada)
} Simbolo;

// Estrutura para a tabela de símbolos
typedef struct {
    Simbolo *primeiro; // Ponteiro para o primeiro símbolo
} TabelaSimbolos;

// Inicializa a tabela de símbolos
void inicializaTabela(TabelaSimbolos *tabela);

// Adiciona um símbolo à tabela
void adicionaSimbolo(TabelaSimbolos *tabela, const char *nome, const char *tipo);

// Verifica se um símbolo existe na tabela
Simbolo* buscaSimbolo(TabelaSimbolos *tabela, const char *nome);

// Função para liberar a tabela de símbolos
void liberaTabela(TabelaSimbolos *tabela);

// Exibe todos os símbolos da tabela
void exibeTabela(TabelaSimbolos *tabela);

// Função para checar declarações duplicadas
void checaDeclaracaoDuplicada(TabelaSimbolos *tabela, const char *nome, const char *tipo);

#endif // TABELA_H
