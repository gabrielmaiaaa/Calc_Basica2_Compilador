%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TABLE_SIZE 100

// Definindo os tipos possíveis de variáveis
typedef enum { INTEIRO, REAL, CARACTER, LISTA_INT, LISTA_REAL } TipoVariavel;

// União para armazenar os valores das variáveis
typedef union {
    int inteiro;
    float real;
    char caracter;
} ValorVariavel;

// Estrutura para representar uma entrada na tabela de símbolos
typedef struct EntradaSimbolo {
    char nome[50];
    TipoVariavel tipo;
    ValorVariavel valor;
    struct EntradaSimbolo *next;
} EntradaSimbolo;

// Função de hash para a tabela de símbolos
unsigned int hash(char *nome) {
    unsigned int h = 0;
    for (int i = 0; nome[i] != '\0'; i++) {
        h = (h * 31) + nome[i];
    }
    return h % TABLE_SIZE;
}

// Estrutura da tabela de símbolos
EntradaSimbolo *tabelaSimbolos[TABLE_SIZE];

// Função para inicializar a tabela de símbolos
void inicializaTabela() {
    for (int i = 0; i < TABLE_SIZE; i++) {
        tabelaSimbolos[i] = NULL;
    }
}

// Função para adicionar uma variável à tabela de símbolos
void adicionaSimbolo(char *nome, TipoVariavel tipo) {
    unsigned int index = hash(nome);
    EntradaSimbolo *novo = (EntradaSimbolo *)malloc(sizeof(EntradaSimbolo));
    strcpy(novo->nome, nome);
    novo->tipo = tipo;
    novo->next = tabelaSimbolos[index];
    tabelaSimbolos[index] = novo;
}

// Função para buscar uma variável na tabela de símbolos
EntradaSimbolo *buscaSimbolo(char *nome) {
    unsigned int index = hash(nome);
    EntradaSimbolo *entry = tabelaSimbolos[index];
    while (entry != NULL) {
        if (strcmp(entry->nome, nome) == 0) {
            return entry;
        }
        entry = entry->next;
    }
    return NULL;
}

// Função para imprimir a tabela de símbolos
void imprimeTabela() {
    for (int i = 0; i < TABLE_SIZE; i++) {
        EntradaSimbolo *entry = tabelaSimbolos[i];
        while (entry != NULL) {
            printf("Nome: %s, Tipo: %d\n", entry->nome, entry->tipo);
            entry = entry->next;
        }
    }
}


void yyerror(const char *s);
int yylex(void);
extern FILE *yyin;
%}

%union {
    int inteiro;
    float real;
    char caracter;
    char *string;
}

/* Declaração dos tokens */
%token PROGRAMA SE ENQUANTO ENTAO ESCREVA FIM_SE FIM_ENQUANTO FIM INICIO LEIA ALFABETO
%token ADICAO ATRIBUICAO DIVISAO PRODUTO SUBTRACAO IGUAL MAIOR
%token TIPO_CARACTER TIPO_INTEIRO TIPO_LISTA_INT TIPO_LISTA_REAL TIPO_REAL
%token ABRE_PARENTESE FECHA_PARENTESE ABRE_COLCHETE FECHA_COLCHETE VIRGULA
%token CONSTANTE_INTEIRA CONSTANTE_REAL VARIAVEL CADEIA

%type <string> VARIAVEL
%type <inteiro> expressao lista_variaveis tipo

/* Declaração de Precedência e Associatividade */
%left IGUAL MAIOR
%left ADICAO SUBTRACAO
%left PRODUTO DIVISAO

%%

programa:
    PROGRAMA VARIAVEL bloco  FIM { printf("Programa válido!\n"); }
    ;

bloco:
    INICIO declaracoes comandos
    ;

declaracoes:
    tipo lista_variaveis {
        char *listaVariaveis[$2]; // Aloca espaço para armazenar os nomes das variáveis
        for (int i = 0; i < $2; i++) {
            adicionaSimbolo(listaVariaveis[i], $1); // Passa o tipo e o nome
        }
    }
    | declaracoes tipo lista_variaveis
;


tipo:
    TIPO_INTEIRO { $$ = INTEIRO; }
    | TIPO_REAL { $$ = REAL; }
    | TIPO_CARACTER { $$ = CARACTER; }
    | TIPO_LISTA_INT { $$ = LISTA_INT; }
    | TIPO_LISTA_REAL { $$ = LISTA_REAL; }
;

lista_variaveis:
    VARIAVEL {
        $$ = 1; // Uma variável foi processada
        if (buscaSimbolo($1) != NULL) {
            yyerror("Variável já declarada");
        } else {
            adicionaSimbolo($1, $<inteiro>0); // Aqui $<inteiro>0 é o tipo propagado
        }
    }
    | lista_variaveis VIRGULA VARIAVEL {
        $$ = $1 + 1; // Incrementa o contador de variáveis
        if (buscaSimbolo($3) != NULL) {
            yyerror("Variável já declarada");
        } else {
            adicionaSimbolo($3, $<inteiro>0); // Usa o tipo propagado
        }
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
        // Verifique se a variável foi declarada
        EntradaSimbolo *entry = buscaSimbolo($1);
        if (entry == NULL) {
            yyerror("Variável não declarada");
        } else {
            // Verifique se os tipos são compatíveis entre o tipo da variável e o tipo da expressão
            if (entry->tipo != $3) {
                yyerror("Tipos incompatíveis na atribuição");
            }
        }
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
    CONSTANTE_INTEIRA {
        $$ = INTEIRO;
    }
    | CONSTANTE_REAL {
        $$ = REAL;
    }
    | VARIAVEL {
        // Verifique se a variável foi declarada
        EntradaSimbolo *entry = buscaSimbolo($1);
        if (entry == NULL) {
            yyerror("Variável não declarada");
        } else {
            $$ = entry->tipo; // Atribui o tipo da variável
        }
    }
    | expressao PRODUTO expressao {
        // Verifique a compatibilidade dos tipos
        if ($1 != $3) {
            yyerror("Tipos incompatíveis no produto");
        }
        $$ = $1; // O tipo da expressão do produto será o tipo de $1
    }
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

    inicializaTabela();
    yyparse();
    fclose(yyin);
    imprimeTabela(); // Para ver os símbolos na tabela
    return 0;
}