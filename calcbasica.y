%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tabela.h"

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
        printf("AAA %s\n", yylval.string);
        processaDeclaracao(yylval.string);
    }
    | lista_variaveis VIRGULA VARIAVEL {
        printf("AAA %s\n", yylval.string);
        processaDeclaracao(yylval.string);
    }
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
    ;

acesso_lista:
    ABRE_COLCHETE expressao FECHA_COLCHETE
    ;

condicao:
    SE expressao ENTAO comandos FIM_SE
    ;

repeticao:
    ENQUANTO expressao comandos FIM_ENQUANTO
    ;

atribuicao:
    VARIAVEL ATRIBUICAO expressao {
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
    LEIA ABRE_PARENTESE VARIAVEL FECHA_PARENTESE
    | LEIA VARIAVEL
    ;

expressao:
    CONSTANTE_INTEIRA
    | CONSTANTE_REAL
    | VARIAVEL
    | expressao PRODUTO expressao
    | expressao DIVISAO expressao
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
    if (!buscaSimbolo(&tabela, var)) {
        fprintf(stderr, "Erro: Variável '%s' não declarada.\n", var);
    } else {
        printf("Atribuição: %s := %s\n", var, valor);
    }
}