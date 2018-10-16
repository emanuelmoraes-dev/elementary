#!/bin/bash

clear
flex -i lexica.l
bison sintatica.y
gcc -o compilador sintatica.tab.c -lfl
./compilador < entrada.ely