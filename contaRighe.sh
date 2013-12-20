#!/usr/bin/env sh

[ -z $1 ] && echo "$0 NOME_FILE" && exit 1

cat $1 | awk '{} END {print NR}'
