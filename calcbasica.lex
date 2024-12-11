%option noyywrap

%{
#include "calcbasica.tab.h"  // Inclui os tokens gerados pelo Bison
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tabela.h"
%}

/* Definições de Tokens */
NUMERO                  [0-9]+
CONSTANTE_INTEIRA       {NUMERO}
CONSTANTE_REAL          {NUMERO}"."{NUMERO}+
ALFABETO                [a-zA-Z]
VARIAVEL                {ALFABETO}({ALFABETO}|{NUMERO}|_)* 
CADEIA                  (\'[^\']+\')|(\"[^\"]+\")
COMENTARIOS             \{[^}]*\}
ESPACOS                 [ \t\n]+

%%

"PROGRAMA"              { salvar_token(yytext, "PROGRAMA"); return PROGRAMA; }
"SE"                    { salvar_token(yytext, "SE"); return SE; }
"ENQUANTO"              { salvar_token(yytext, "ENQUANTO"); return ENQUANTO; }
"ENTAO"                 { salvar_token(yytext, "ENTAO"); return ENTAO; }
"ESCREVA"               { salvar_token(yytext, "ESCREVA"); return ESCREVA; }
"FIM_SE"                { salvar_token(yytext, "FIM_SE"); return FIM_SE; }
"FIM_ENQUANTO"          { salvar_token(yytext, "FIM_ENQUANTO"); return FIM_ENQUANTO; }
"FIM"                   { salvar_token(yytext, "FIM"); return FIM; }
"INICIO"                { salvar_token(yytext, "INICIO"); return INICIO; }
"LEIA"                  { salvar_token(yytext, "LEIA"); return LEIA; }
"+"                     { salvar_token(yytext, "ADICAO"); return ADICAO; }
":="                    { salvar_token(yytext, "ATRIBUICAO"); return ATRIBUICAO; }
"/"                     { salvar_token(yytext, "DIVISAO"); return DIVISAO; }
"*"                     { salvar_token(yytext, "PRODUTO"); return PRODUTO; }
"-"                     { salvar_token(yytext, "SUBTRACAO"); return SUBTRACAO; }
".I."                   { salvar_token(yytext, "IGUAL"); return IGUAL; }
".M."                   { salvar_token(yytext, "MAIOR"); return MAIOR; }
"CARACTER"              { salvar_token(yytext, "TIPO_CARACTER"); return TIPO_CARACTER; }
"INTEIRO"               { salvar_token(yytext, "TIPO_INTEIRO"); return TIPO_INTEIRO; }
"LISTA_INT"             { salvar_token(yytext, "TIPO_LISTA_INT"); return TIPO_LISTA_INT; }
"LISTA_REAL"            { salvar_token(yytext, "TIPO_LISTA_REAL"); return TIPO_LISTA_REAL; }
"REAL"                  { salvar_token(yytext, "TIPO_REAL"); return TIPO_REAL; }
"("                     { salvar_token(yytext, "ABRE_PARENTESE"); return ABRE_PARENTESE; }
")"                     { salvar_token(yytext, "FECHA_PARENTESE"); return FECHA_PARENTESE; }
"["                     { salvar_token(yytext, "ABRE_COLCHETE"); return ABRE_COLCHETE; }
"]"                     { salvar_token(yytext, "FECHA_COLCHETE"); return FECHA_COLCHETE; }
","                     { salvar_token(yytext, "VIRGULA"); return VIRGULA; }                     

{VARIAVEL} {
    yylval.string = strdup(yytext);
    salvar_token(yytext, "VARIAVEL");
    return VARIAVEL;
}

{CONSTANTE_INTEIRA} {
    yylval.inteiro = atoi(yytext);
    salvar_token(yytext, "CONSTANTE_INTEIRA");
    return CONSTANTE_INTEIRA;
}

{CONSTANTE_REAL} {
    yylval.real = atof(yytext);
    salvar_token(yytext, "CONSTANTE_REAL");
    return CONSTANTE_REAL;
}

{CADEIA}                { salvar_token(yytext, "CADEIA"); return CADEIA; }
{COMENTARIOS}           { /* Ignora comentários */ }
{ESPACOS}               { /* Ignora espaços em branco */ }

.                       { printf("Caractere desconhecido: %s\n", yytext); }

%%