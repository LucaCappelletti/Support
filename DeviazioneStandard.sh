#!/usr/bin/env sh
#
# Calcola la media di una colonna di numeri passati in streaming come input (i.e.: pipe da un cat)

[ -z $1 ] && echo "devi passare il nome di un file ed eventualmente la colonna di riferimento se il file è multicolonna separato da TAB" && exit 1

[ ! -z $2 ] && colonna=$2 || colonna=1


#printf "Media: "
media=$(cat $1 | awk -v colonna=$colonna '{sum+=$colonna} END {print sum/NR}')
#printf "\n"

#printf "Deviazione Standard: "
deviazione=$(cat $1 | awk -v colonna=$colonna '{sum+=$colonna;sumsq+=$colonna*$colonna} END {print sqrt(sumsq/NR - (sum/NR)^2)}')
#printf "\n"
#{sum+=$colonna;sumsq+=$colonna*$colonna} END {print sqrt(sumsq/NR - )}

echo "Media: "$media" ( +/-"$deviazione" )"
