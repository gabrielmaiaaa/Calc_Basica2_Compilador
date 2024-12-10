%option noyywrap

%{
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

"PROGRAMA"                                    { printf("Token: PROGRAMA\n"); }
"SE"                                                    { printf("Token: SE\n"); }
"ENQUANTO"                                    { printf("Token: ENQUANTO\n"); }
"ENTAO"                                            { printf("Token: ENTAO\n"); }
"ESCREVA"                                         { printf("Token: ESCREVA\n"); }
"FIM_SE"                                            { printf("Token: FIM_SE\n");}
"FIM_ENQUANTO"                             { printf("Token: FIM_ENQUANTO\n");}
"FIM"                                                  { printf("Token: FIM\n"); }
"INICIO"                                             { printf("Token: INICIO\n");}
"LEIA"                                                 { printf("Token: LEIA\n"); }
"+"                                                      { printf("Token: ADICAO\n"); }
":="                                                     { printf("Token: ATRIBUICAO\n"); }
"/"                                                       { printf("Token: DIVISAO\n"); }
"*"                                                       { printf("Token: PRODUTO\n"); }
"-"                                                       { printf("Token: SUBTRACAO\n"); }
".I."                                                      { printf("Token: IGUAL\n"); }
".M."                                                    { printf("Token: MAIOR\n"); }
"CARACTER"                                       { printf("Token: TIPO_CARACTER\n"); }
"INTEIRO"                                           { printf("Token: TIPO_INTEIRO\n"); }
"LISTA_INT"                                         { printf("Token: TIPO_LISTA_INT\n"); }
"LISTA_REAL"                                       { printf("Token: TIPO_LISTA_REAL\n"); }
"REAL"                                                 { printf("Token: TIPO_REAL\n"); }
"("                                                        { printf("Token: ABRE_PARENTESE\n"); }
")"                                                        { printf("Token: FECHA_PARENTESE\n"); }
"["                                                        { printf("Token: ABRE_COLCHETE\n"); }
"]"                                                        { printf("Token: FECHA_COLCHETE\n"); }
","                                                        { printf("Token: VIRGULA\n"); }
{CONSTANTE_INTEIRA}                       { printf("Token: CONSTANTE_INTEIRA (%s)\n", yytext); }
{CONSTANTE_REAL}                            { printf("Token: CONSTANTE_REAL (%s)\n", yytext);; }
{VARIAVEL}                                          { printf("Token: VARIAVEL (%s)\n", yytext); }
{CADEIA}                                             { printf("Token: CADEIA (%s)\n", yytext); }
{COMENTARIOS}                                 { /* Ignora comentários */ }
{POSSIVEIS_ERROS}                             { /* Ignora espaços em branco */ }
.                                                           { printf("Caractere desconhecido: %s\n", yytext); }

%%

int main(int argc, char *argv[]) {
    yylex();
    return 0;
}