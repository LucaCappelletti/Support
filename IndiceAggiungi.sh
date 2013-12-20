#!/usr/bin/env sh

# aggiunge un indice al file nella prima colonna

[ -z $1 ] && echo "Uso: "$0" un file" && exit 1

IL_FILE=$1

cat $IL_FILE | awk '{if(i==""){i=0};print i,$0;i++}END{}' > $IL_FILE.index
