#!/usr/bin/env sh
#
# calcola tempo di lavoro
# fornisci orario di ingresso ed uscita e ritorna orario di lavoro
#
# Luca Cappelletti (2015)
#
# prototipo alpha

[ -z $1 ] && echo "uso: "$0" ORA_IN:MINUTI_IN ORA_OUT:MINUTI_OUT" && exit 1

ingr=$1
usci=$2

ora_ingr=$(echo $ingr | cut -d":" -f 1)
minuti_ingr=$(echo $ingr | cut -d":" -f 2)

ora_usci=$(echo $usci | cut -d":" -f 1)
minuti_usci=$(echo $usci | cut -d":" -f 2)

delta=$(echo "scale=2; entrata=("$ora_ingr"+("$minuti_ingr"/60)); uscita=("$ora_usci"+("$minuti_usci"/60)); tempo=uscita-entrata; tempo" | bc)

#echo "delta = "$delta

delta_ora=$(echo $delta | cut -d"." -f 1)
delta_decimali=$(echo $delta | cut -d"." -f 2)

delta_minuti=$(echo "scale=2; 60/(100/"$delta_decimali")" | bc | cut -d"." -f 1)

#echo "delta_ora = "$delta_ora
#echo "delta_decimali = "$delta_decimali
#echo "delta_minuti = "$delta_minuti

echo "Tempo di lavoro = "$delta_ora":"$delta_minuti

