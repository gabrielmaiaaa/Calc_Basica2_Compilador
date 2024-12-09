%option noyywrap

%{
#include "calcbasica.tab.h"  // Inclui os tokens gerados pelo Bison
#include <stdio.h>
%}

/* Definição de Tokens */
NUMERO                                  [0-9]
CONSTANTE_INTEIRA              {NUMERO}+
CONSTANTE_REAL                   {NUMERO}+(\.{NUMERO}+) 
ALFABETO                                [a-zA-Z]
VARIAVEL                                 {ALFABETO}({ALFABETO}|{NUMERO}|_)*
CADEIA                                    \'[^\']+\'
COMENTARIOS                        \{[^}]*\}
POSSIVEIS_ERROS                    [ \n\t]+

%%

"PROGRAMA"                                    { printf("Token: PROGRAMA\n"); return PROGRAMA; }
"SE"                                                    { printf("Token: SE\n"); return SE; }
"ENQUANTO"                                    { printf("Token: ENQUANTO\n"); return ENQUANTO; }
"ENTAO"                                            { printf("Token: ENTAO\n"); return ENTAO; }
"ESCREVA"                                         { printf("Token: ESCREVA\n"); return ESCREVA; }
"FIM_SE"                                            { printf("Token: FIM_SE\n"); return FIM_SE; }
"FIM_ENQUANTO"                             { printf("Token: FIM_ENQUANTO\n"); return FIM_ENQUANTO; }
"FIM"                                                  { printf("Token: FIM\n"); return FIM; }
"INICIO"                                             { printf("Token: INICIO\n"); return INICIO; }
"LEIA"                                                 { printf("Token: LEIA\n"); return LEIA; }
"+"                                                      { printf("Token: ADICAO\n"); return ADICAO; }
":="                                                     { printf("Token: ATRIBUICAO\n"); return ATRIBUICAO; }
"/"                                                       { printf("Token: DIVISAO\n"); return DIVISAO; }
"*"                                                       { printf("Token: PRODUTO\n"); return PRODUTO; }
"-"                                                       { printf("Token: SUBTRACAO\n"); return SUBTRACAO; }
".I."                                                      { printf("Token: IGUAL\n"); return IGUAL; }
".M."                                                    { printf("Token: MAIOR\n"); return MAIOR; }
"CARACTER"                                       { printf("Token: TIPO_CARACTER\n"); return TIPO_CARACTER; }
"INTEIRO"                                           { printf("Token: TIPO_INTEIRO\n"); return TIPO_INTEIRO; }
"LISTA_INT"                                         { printf("Token: TIPO_LISTA_INT\n"); return TIPO_LISTA_INT; }
"LISTA_REAL"                                       { printf("Token: TIPO_LISTA_REAL\n"); return TIPO_LISTA_REAL; }
"REAL"                                                 { printf("Token: TIPO_REAL\n"); return TIPO_REAL; }
"("                                                        { printf("Token: ABRE_PARENTESE\n"); return ABRE_PARENTESE; }
")"                                                        { printf("Token: FECHA_PARENTESE\n"); return FECHA_PARENTESE; }
"["                                                        { printf("Token: ABRE_COLCHETE\n"); return ABRE_COLCHETE; }
"]"                                                        { printf("Token: FECHA_COLCHETE\n"); return FECHA_COLCHETE; }
","                                                        { printf("Token: VIRGULA\n"); return VIRGULA; }
{CONSTANTE_INTEIRA}                       { printf("Token: CONSTANTE_INTEIRA (%s)\n", yytext); return CONSTANTE_INTEIRA; }
{CONSTANTE_REAL}                            { printf("Token: CONSTANTE_REAL (%s)\n", yytext); return CONSTANTE_REAL; }
{VARIAVEL}                                          { printf("Token: VARIAVEL (%s)\n", yytext); return VARIAVEL; }
{CADEIA}                                             { printf("Token: CADEIA (%s)\n", yytext); return CADEIA; }
{COMENTARIOS}                                 { /* Ignora comentários */ }
{POSSIVEIS_ERROS}                             { /* Ignora espaços em branco */ }
.                                                           { printf("Caractere desconhecido: %s\n", yytext); }

%%