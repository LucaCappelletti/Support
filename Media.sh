#!/usr/bin/env sh
#
# Calcola la media di una colonna di numeri passati in streaming come input (i.e.: pipe da un cat)

[ -z $1 ] && echo "devi passare il nome di un file ed eventualmente la colonna di riferimento se il file è multicolonna separato da TAB" && exit 1

[ ! -z $2 ] && colonna=$2 || colonna=1

cat $1 | awk -v colonna=$colonna '{sum+=$colonna} END {print sum/NR}'
