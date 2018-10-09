#!/bin/bash

# Inverte linhas
function adapter {
    python2 -c "\
arq = open('$1', 'r')
texto = arq.readlines()
texto.reverse()
texto.append('@')
for s in texto: 
    if s[-1] == '\n':
       s = s[:-1]
    print s"
}

clear
flex -i lexica.l
bison sintatica.y
gcc -o compilador sintatica.tab.c -lfl
# adapter entrada.ely
adapter entrada.ely | ./compilador
# ./compilador < entrada.ely