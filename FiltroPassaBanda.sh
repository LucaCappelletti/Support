#!/usr/bin/env sh
#
# Normalizza

[ -z $1 ] && printf "devi passare il nome di un file ed eventualmente la colonna di riferimento se il file ha multicolonne separato da TAB \n$0 NOMEFILE NUMERO_COLONNA\n" && exit 1

[ ! -z $2 ] && colonna=$2 || colonna=1

media=$(cat $1 | awk -v colonna=$colonna '{sum+=$colonna} END {print sum/NR}')

deviazione=$(cat $1 | awk -v colonna=$colonna '{sum+=$colonna;sumsq+=$colonna*$colonna} END {print sqrt(sumsq/NR - (sum/NR)^2)}')

# tempo in secondi
tempo=1000

MIN=$(cat $1 | awk -v COLONNA=$colonna -v SECONDI=$tempo '{if(NR==SECONDI) {exit}}; {if(min==""){min=$COLONNA}; if($COLONNA<min) {min=$COLONNA};} END {print min}')
MAX=$(cat $1 | awk -v COLONNA=$colonna -v SECONDI=$tempo '{if(NR==SECONDI) {exit}}; {if(max==""){max=$COLONNA}; if($COLONNA>max) {max=$COLONNA};} END {print max}')

cat $1 | awk -v MEDIA=$media -v y=$colonna -v MASSIMO=$MAX -v MINIMO=$MIN '{ Y=$y; if(Y>MASSIMO) {dYmax=(Y-MASSIMO); Y=MASSIMO}; if(Y<MINIMO) {dYmin=(MINIMO-Y);Y=MINIMO}; if(Y<MASSIMO && Y>MEDIA) {Y=(Y+dYmin)}; if(Y>MINIMO && Y<MEDIA) {Y=(Y+dYmax)}; print $1,Y,$4} END {}'
