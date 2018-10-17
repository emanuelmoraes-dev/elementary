# Elementary

Esta linguagem, desenvolvida no trabalho de compiladores, no Instituto Federal de Educação, Ciência e Tecnologia do Ceará, possui a declaração de variáveis, atribuição de variáveis, expressões matemáticas e print de expressões.  O último comando da linguagem deve ser o comando "end". Nesta linguagem todos os valores são Strings e as operações matemáticas são feitas em cimas das Strings. Esta linguagem não está completa e ainda precisa de alguns reparos.

## Declaração de Variável (Exemplo)

let nome

## Declaração de Variável com atribuição (Exemplo)

let nome = "Emanuel"
let idade = 20
let valor = 7+4*2

## Expressão de Soma (Exemplo)

let a = 2
let valor = a+4

## Expressão de Subtração (Exemplo)

let a = 7
let valor = a-2

## Expressão de Multiplicação (Exemplo)

let a = 3
let valor = a*5

## Expressão de Divisão (Exemplo)

let a = 10
let valor = a/5

## Expressão de Concatenação (Exemplo)

let a = 3
let b = 20
let resultado = a.."+"..b.."="..a+b

## Print (Exemplo)

let a = 3
let b = 20
write "resultado = "..a.."+"..b.."="..a+b

## Exemplo de Código Completo

let a = 20
let b = a*2
write a.."+"..b.."="..(a+b)
let c
c = a+b.." concatenado com isto"
write c
end

## Execução

Para gerar o compilador da linguagem deve-se executar os seguintes comandos:

flex -i lexica.l
bison sintatica.y
gcc -o compilador sintatica.tab.c -lfl
./compilador < entrada.ely

sendo o "entrada.ely" um programa desenvolvido com a linguagem Elementary.

## Execução de arquivo de teste do repositório

Dentro do repositório está presente o arquivo "entrada.ely". Para gerar o compilador da linguagem e executar este arquivo de teste, basta executar (no linux) o arquivo "run.sh".

## Dependências da geração do compilador

Para gerar o compilador é nescessário que tenha-se instalado em sua máquina os pacotes (yacc e bison). No linux (em distribuições baseadas no ubuntu) basta executar osseguintes comandos:

sudo apt-get update

sudo apt-get install flex bison

sudo apt-get install libfl2 libfl-dev