/* A Bison parser, made by GNU Bison 3.8.2.  */

/* Bison interface for Yacc-like parsers in C

   Copyright (C) 1984, 1989-1990, 2000-2015, 2018-2021 Free Software Foundation,
   Inc.

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <https://www.gnu.org/licenses/>.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* DO NOT RELY ON FEATURES THAT ARE NOT DOCUMENTED in the manual,
   especially those whose name start with YY_ or yy_.  They are
   private implementation details that can be changed or removed.  */

#ifndef YY_YY_CALCBASICA_TAB_H_INCLUDED
# define YY_YY_CALCBASICA_TAB_H_INCLUDED
/* Debug traces.  */
#ifndef YYDEBUG
# define YYDEBUG 0
#endif
#if YYDEBUG
extern int yydebug;
#endif

/* Token kinds.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
  enum yytokentype
  {
    YYEMPTY = -2,
    YYEOF = 0,                     /* "end of file"  */
    YYerror = 256,                 /* error  */
    YYUNDEF = 257,                 /* "invalid token"  */
    PROGRAMA = 258,                /* PROGRAMA  */
    SE = 259,                      /* SE  */
    ENQUANTO = 260,                /* ENQUANTO  */
    ENTAO = 261,                   /* ENTAO  */
    ESCREVA = 262,                 /* ESCREVA  */
    FIM_SE = 263,                  /* FIM_SE  */
    FIM_ENQUANTO = 264,            /* FIM_ENQUANTO  */
    FIM = 265,                     /* FIM  */
    INICIO = 266,                  /* INICIO  */
    LEIA = 267,                    /* LEIA  */
    ALFABETO = 268,                /* ALFABETO  */
    ADICAO = 269,                  /* ADICAO  */
    ATRIBUICAO = 270,              /* ATRIBUICAO  */
    DIVISAO = 271,                 /* DIVISAO  */
    PRODUTO = 272,                 /* PRODUTO  */
    SUBTRACAO = 273,               /* SUBTRACAO  */
    IGUAL = 274,                   /* IGUAL  */
    MAIOR = 275,                   /* MAIOR  */
    TIPO_CARACTER = 276,           /* TIPO_CARACTER  */
    TIPO_INTEIRO = 277,            /* TIPO_INTEIRO  */
    TIPO_LISTA_INT = 278,          /* TIPO_LISTA_INT  */
    TIPO_LISTA_REAL = 279,         /* TIPO_LISTA_REAL  */
    TIPO_REAL = 280,               /* TIPO_REAL  */
    ABRE_PARENTESE = 281,          /* ABRE_PARENTESE  */
    FECHA_PARENTESE = 282,         /* FECHA_PARENTESE  */
    ABRE_COLCHETE = 283,           /* ABRE_COLCHETE  */
    FECHA_COLCHETE = 284,          /* FECHA_COLCHETE  */
    VIRGULA = 285,                 /* VIRGULA  */
    CONSTANTE_INTEIRA = 286,       /* CONSTANTE_INTEIRA  */
    CONSTANTE_REAL = 287,          /* CONSTANTE_REAL  */
    VARIAVEL = 288,                /* VARIAVEL  */
    CADEIA = 289                   /* CADEIA  */
  };
  typedef enum yytokentype yytoken_kind_t;
#endif

/* Value type.  */
#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
union YYSTYPE
{
#line 85 "calcbasica.y"

    int inteiro;
    float real;
    char caracter;
    char *string;

#line 105 "calcbasica.tab.h"

};
typedef union YYSTYPE YYSTYPE;
# define YYSTYPE_IS_TRIVIAL 1
# define YYSTYPE_IS_DECLARED 1
#endif


extern YYSTYPE yylval;


int yyparse (void);


#endif /* !YY_YY_CALCBASICA_TAB_H_INCLUDED  */
