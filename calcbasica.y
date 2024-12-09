%{
#include <stdio.h>
#include <stdlib.h>

void yyerror(const char *s);
int yylex(void);
extern FILE *yyin;
%}

/* Declaração dos tokens */
%token PROGRAMA SE ENQUANTO ENTAO ESCREVA FIM_SE FIM_ENQUANTO FIM INICIO LEIA
%token ADICAO ATRIBUICAO DIVISAO PRODUTO SUBTRACAO IGUAL MAIOR
%token TIPO_CARACTER TIPO_INTEIRO TIPO_LISTA_INT TIPO_LISTA_REAL TIPO_REAL
%token ABRE_PARENTESE FECHA_PARENTESE ABRE_COLCHETE FECHA_COLCHETE VIRGULA
%token CONSTANTE_INTEIRA CONSTANTE_REAL VARIAVEL CADEIA

y
/* Declaração de Precedência e Associatividade */
%left IGUAL MAIOR
%left ADICAO SUBTRACAO
%left PRODUTO DIVISAO

%%

programa:
    PROGRAMA VARIAVEL bloco FIM { printf("Programa válido!\n"); }
    ;

bloco:
    INICIO declaracoes comandos
    ;

declaracoes:
    tipo lista_variaveis
    | declaracoes tipo lista_variaveis
    ;

tipo:
    TIPO_INTEIRO
    | TIPO_REAL
    | TIPO_CARACTER
    ;

lista_variaveis:
    VARIAVEL
    | lista_variaveis VIRGULA VARIAVEL
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
    ;

condicao:
    SE expressao ENTAO comandos FIM_SE
    ;

repeticao:
    ENQUANTO expressao comandos FIM_ENQUANTO
    ;

atribuicao:
    VARIAVEL ATRIBUICAO expressao { printf("Atribuição.\n"); }
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
    LEIA ABRE_PARENTESE VARIAVEL FECHA_PARENTESE { printf("Leitura.\n"); }
    | LEIA VARIAVEL
    ;

expressao:
    CONSTANTE_INTEIRA
    | CONSTANTE_REAL
    | VARIAVEL
    | expressao ADICAO expressao
    | expressao SUBTRACAO expressao
    | expressao PRODUTO expressao
    | expressao DIVISAO expressao
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