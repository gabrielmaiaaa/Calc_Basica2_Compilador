# Calc_Basica2_Compilador


Como rodar o compilador:

- flex calcbasica.lex

- bison -Wcounterexamples -d calcbasica.y OU bison -d -Wall -v calcbasica.y

- gcc calcbasica.tab.c lex.yy.c tabela.c -o calcbasica

- ./calcbasica exemplo.calc

Esses foram todos comandos utilizados para conseguir rodar o compilador com sucesso