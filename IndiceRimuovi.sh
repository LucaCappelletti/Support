#!/usr/bin/env sh
#
# presuppone la presenza dell'indice nella prima colonna

[ -z $1 ] && echo "Uso: "$0" file testo" && exit 1

IL_FILE=$1

cat $IL_FILE | sed 's/ /\t/g' | cut -f 1 --complement | sed 's/\t/ /g' | tr -s ' ' > $IL_FILE.noindex

unlink .noindex
