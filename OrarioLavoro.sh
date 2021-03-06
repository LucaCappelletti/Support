#!/usr/bin/env sh
#
# calcola tempo di lavoro 1.2
# fornisci orario di ingresso ed uscita e ritorna orario di lavoro
#
# Luca Cappelletti (2015)
#
# prototipo alpha

[ -z $1 ] && echo "uso: "$0" ORA_IN:MINUTI_IN ORA_OUT:MINUTI_OUT" && exit 1

[ -x $( which bc) ] || exit 1

ingr=$1
usci=$2

ore_di_lavoro=8
minuti_mensa=45

ora_ingr=$(echo $ingr | cut -d":" -f 1)
minuti_ingr=$(echo $ingr | cut -d":" -f 2)

if [ -z $2 ]
then

ora_usci=$(echo $ora_ingr"+"$ore_di_lavoro | bc)


minuti_tot=$(($minuti_ingr+$minuti_mensa))

echo "minuti_tot = "$minuti_tot


        minuti=$(($minuti_tot-60))
        ora=$(($ora_usci+1))



echo "Orario di uscita = "$ora":"$minuti
exit

else
:
fi

ora_usci=$(echo $usci | cut -d":" -f 1)
minuti_usci=$(echo $usci | cut -d":" -f 2)

delta=$(echo "scale=2; entrata=("$ora_ingr"+("$minuti_ingr"/60)); uscita=("$ora_usci"+("$minuti_usci"/60)); tempo=uscita-entrata; tempo" | bc)

#echo "delta = "$delta

delta_ora=$(echo $delta | cut -d"." -f 1)
delta_decimali=$(echo $delta | cut -d"." -f 2)

delta_minuti=$(echo "scale=2; 60/(100/"$delta_decimali")" | bc | cut -d"." -f 1)

echo "delta_ora = "$delta_ora
echo "delta_decimali = "$delta_decimali
echo "delta_minuti = "$delta_minuti

minuti_tot=$(($delta_minuti+$minuti_mensa))

echo "minuti_tot = "$minuti_tot

if [ "$minuti_tot" -ge 60 ] && [ "$minuti_tot" -le 129 ]
then

	minuti=$(($minuti_tot-60))
	ora=$(($delta_ora+1))

else

	echo "Uè..stai dicendo che hai fatto "$minuti_mensa" minuti di mensa??"
	echo ""
	echo "...fila a lavura pelandrun!!!"
	exit 1

fi

#echo "Tempo di lavoro = "$delta_ora":"$delta_minuti
echo "Tempo di lavoro = "$ora":"$minuti

