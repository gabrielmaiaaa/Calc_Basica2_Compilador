%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tabela.h"

#define LIMITE_VETOR 100  // Defina o tamanho máximo desejado para o vetor

void yyerror(const char *s);
int yylex(void);
extern FILE *yyin;

// Tabela de símbolos
TabelaSimbolos tabela;

// Tipo atual para as declarações
char *tipoAtual;

// Funções auxiliares para lidar com declarações e comandos
void processaDeclaracao(char *nome);
void processaAtribuicao(char *var, char *valor);
%}

%union {
    int inteiro;
    float real;
    char *string;
}

/* Declaração dos tokens */
%token PROGRAMA SE ENQUANTO ENTAO ESCREVA FIM_SE FIM_ENQUANTO FIM INICIO LEIA ALFABETO
%token ADICAO ATRIBUICAO DIVISAO PRODUTO SUBTRACAO IGUAL MAIOR
%token TIPO_CARACTER TIPO_INTEIRO TIPO_LISTA_INT TIPO_LISTA_REAL TIPO_REAL
%token ABRE_PARENTESE FECHA_PARENTESE ABRE_COLCHETE FECHA_COLCHETE VIRGULA
%token CONSTANTE_INTEIRA CONSTANTE_REAL VARIAVEL CADEIA

%type <string> VARIAVEL
%type <inteiro> CONSTANTE_INTEIRA
%type <real> CONSTANTE_REAL


/* Declaração de Precedência e Associatividade */
%left IGUAL MAIOR
%left ADICAO SUBTRACAO
%left PRODUTO DIVISAO

%%

programa:
    PROGRAMA VARIAVEL bloco  FIM { 
        printf("Programa válido!\n");
        exibeTabela(&tabela); 
        }
    ;

bloco:
    INICIO declaracoes comandos
    ;

declaracoes:
    tipo lista_variaveis
    | declaracoes tipo lista_variaveis
    ;

tipo:
    TIPO_INTEIRO    { tipoAtual = "INTEIRO"; }
    | TIPO_REAL     { tipoAtual = "REAL"; }
    | TIPO_CARACTER { tipoAtual = "CARACTER"; }
    | TIPO_LISTA_INT { tipoAtual = "LISTA_INT"; }
    | TIPO_LISTA_REAL { tipoAtual = "LISTA_REAL"; }
    ;

lista_variaveis:
    VARIAVEL {
        processaDeclaracao(yylval.string);
    }
    | lista_variaveis VIRGULA VARIAVEL {
        processaDeclaracao(yylval.string);
    }
    | lista_variaveis VIRGULA CADEIA
    ;

comandos:
    comando
    | comandos comando
    ;

comando:
    atribuicao
    | escrita
    | leitura
    | condicao
    | repeticao
    | acesso_lista
    | dividir
    | CADEIA
    ;

acesso_lista:
    ABRE_COLCHETE CONSTANTE_INTEIRA FECHA_COLCHETE {
        int indice = yylval.inteiro;
        if (indice < 0 || indice >= LIMITE_VETOR) {
            yyerror("Erro: Índice do vetor fora dos limites.");
            exit(1); 
        }
    }
    | ABRE_COLCHETE VARIAVEL FECHA_COLCHETE {
        if (yylval.string != NULL && yylval.string[0] != '\0') {
            if (!buscaSimbolo(&tabela, yylval.string)) {
                fprintf(stderr, "Erro: Variável '%s' não declarada.\n", yylval.string);
                exit(1);
            }
        }
        int indice = yylval.inteiro;
        if (indice < 0 || indice >= LIMITE_VETOR) {
            yyerror("Erro: Índice do vetor fora dos limites.");
            exit(1); 
        }
    }

condicao:
    SE expressao ENTAO comandos FIM_SE
    ;

repeticao:
    ENQUANTO expressao comandos FIM_ENQUANTO
    ;

dividir:
    expressao VARIAVEL
    ;

atribuicao:
    VARIAVEL ATRIBUICAO expressao {
        if (yylval.string != NULL && yylval.string[0] != '\0') {
            if (!buscaSimbolo(&tabela, yylval.string)) {
                fprintf(stderr, "Erro: Variável '%s' não declarada.\n", yylval.string);
                exit(1);
            }
        }
        processaAtribuicao(yylval.string, "expressao");
    }
    ;

escrita:
    ESCREVA ABRE_PARENTESE lista_argumentos FECHA_PARENTESE
    | ESCREVA lista_argumentos
    ;

lista_argumentos:
    expressao
    | CADEIA
    | lista_argumentos VIRGULA expressao
    ;

leitura:
    LEIA ABRE_PARENTESE VARIAVEL FECHA_PARENTESE {
        if (yylval.string != NULL && yylval.string[0] != '\0') {
            if (!buscaSimbolo(&tabela, yylval.string)) {
                fprintf(stderr, "Erro: Variável '%s' não declarada.\n", yylval.string);
                exit(1);
            }
        }
    }
    | LEIA ABRE_COLCHETE VARIAVEL FECHA_COLCHETE {
        if (yylval.string != NULL && yylval.string[0] != '\0') {
            if (!buscaSimbolo(&tabela, yylval.string)) {
                fprintf(stderr, "Erro: Variável '%s' não declarada.\n", yylval.string);
                exit(1);
            }
        }
    }
    | LEIA VARIAVEL {
        if (yylval.string != NULL && yylval.string[0] != '\0') {
            if (!buscaSimbolo(&tabela, yylval.string)) {
                fprintf(stderr, "Erro: Variável '%s' não declarada.\n", yylval.string);
                exit(1);
            }
        }
    }
    ;

expressao:
    CONSTANTE_INTEIRA
    | CONSTANTE_REAL
    | VARIAVEL {
        if (yylval.string != NULL && yylval.string[0] != '\0') {
            if (!buscaSimbolo(&tabela, yylval.string)) {
                fprintf(stderr, "Erro: Variável '%s' não declarada.\n", yylval.string);
                exit(1);
            }
        }
    }
    | expressao PRODUTO expressao
    | expressao DIVISAO CONSTANTE_INTEIRA {
        if (yylval.inteiro == 0) {
            yyerror("Erro: Divisão por zero.");
            exit(1); 
        }
    }
    | expressao DIVISAO CONSTANTE_REAL {
        if (yylval.real == 0.0) {
            yyerror("Erro: Divisão por zero.");
            exit(1); 
        }
    }
    | expressao ADICAO expressao
    | expressao SUBTRACAO expressao
    | expressao IGUAL expressao
    | expressao MAIOR expressao
    ;


%%

void yyerror(const char *s) {
    fprintf(stderr, "Erro: %s\n", s);
}

int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Uso: %s <arquivo>\n", argv[0]);
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if (!yyin) {
        perror("Erro ao abrir o arquivo");
        return 1;
    }

    yyparse();
    fclose(yyin);
    return 0;
}

/* Funções auxiliares */

void processaDeclaracao(char *nome) {
    adicionaSimbolo(&tabela, nome, tipoAtual);
}


void processaAtribuicao(char *var, char *valor) {
    if (var != NULL && var[0] != '\0') {
        if (!buscaSimbolo(&tabela, var)) {
            fprintf(stderr, "Erro: Variável '%s' não declarada.\n", var);
            exit(1);   
        }
    } 
}