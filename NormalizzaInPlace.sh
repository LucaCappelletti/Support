#!/usr/bin/env sh
#
# Luca Cappelletti (2013)
# <l.cappelletti@c-s-m.it>
# License: WTF
#
# Adegua la curva normalizzandola alla media calcolata nel range_x di riferimento
#
# si aspetta in ingresso un file CVS separato da TAB con la prima riga le intestazioni delle colonne in formato:
# nome nome nome nome nome  
# COLONNA COLONNA COLONNA COLONNA COLONNA ...
#
# in ingresso vengono forniti:
# nome del file, colonna delle X , colonna delle Y
#
# il programma produce in output un nuovo file separato da spazio con la colonna Y rielaborata e sostituita "in place" alla colonna del file originale producedo un nuovo file

[ -z $1 ] && echo "devi passare il nome di un file ed eventualmente le colonna di riferimento X ed Y" && echo $0" NOME_FILE.csv COLONNA_X COLONNA_Y" && exit 1
[ ! -z $2 ] && colonna_x=$2 || colonna_x=1
[ ! -z $3 ] && colonna_y=$3 || colonna_y=2

[ ! -f $1 ] && echo "il file \""$1"\" non lo vedo.." && exit 1

#[ $2 -gt 1 ] || exit 1
#[ $3 -gt 1 ] || exit 1

HERE="$(pwd)"

DATALOG=$(basename $1)
DIRLOG=$(dirname $1)

PREFIX=$HERE"/"$DIRLOG

# DEBUG
#echo "HERE = "$HERE
#echo $PREFIX
#echo $DIRLOG
#echo $DATALOG

#tail -n +4 ./$DATALOG | tr '\t' ' ' > $DATALOG.dat

tail -n +4 $PREFIX/$DATALOG > $HERE/$DATALOG.dat

# calcola la media a X secondi
# se non si vuole considerare il tempo allora porre la variabile a "" o 0
tempo=1000

echo "tempo = "$tempo

tot=$(cat $HERE/$DATALOG.dat | awk '{} END {print NR}')

# DEBUG
echo "tot = "$tot

# media calcolata nel range 0-$tempo
media=$(cat $HERE/$DATALOG.dat | awk -v TOT=$tot -v SECONDI=$tempo -v COLONNA=$colonna_y '{if(SECONDI=="" || SECONDI==0) {SECONDI=TOT}; if(NR==SECONDI) {exit};sum+=$COLONNA} END {print sum/NR}')

# DEBUG
echo "media = "$media

MIN=$(cat $HERE/$DATALOG.dat | awk -v COLONNA=$colonna_y -v SECONDI=$tempo '{if(NR==SECONDI) {exit}}; {if(min==""){min=$COLONNA}; if($COLONNA<min) {min=$COLONNA};} END {print min}')
MAX=$(cat $HERE/$DATALOG.dat | awk -v COLONNA=$colonna_y -v SECONDI=$tempo '{if(NR==SECONDI) {exit}}; {if(max==""){max=$COLONNA}; if($COLONNA>max) {max=$COLONNA};} END {print max}')

# DEBUG
echo "MIN = "$MIN
echo "MAX = "$MAX
echo ""

# quando si necessita un pizzico teoria della complessita...considerare anche:
# random da 0 a 99
#random=$(cat /dev/urandom| tr -dc '0-9' | fold -w 2| head -n 1)

# intervallo di calcolo della media lungo X (adeguare al circa il numero di secondi di un ciclo)
range_x=200

#cat TOOL/header > $HERE/$DATALOG.dat.new.csv
#wait

echo "Timestamp Secondi DAS Corretto" | tr ' ' '\t' > $HERE/$DATALOG.txt
wait

cat $HERE/$DATALOG.dat | awk -v X=$colonna_x -v Y=$colonna_y -v RANGE=$range_x -v MAX=$MAX -v MIN=$MIN -v MEDIA=$media -v TEMPO=$tempo '
{range=RANGE;
COLONNA_Y=Y;
OFS="\t";

if(somma=="") {somma=0};
if(indice=="") {indice=0}; 
if(contatore=="") {contatore=1};
if(min=="") {min=1};
if(max=="") {max=(min+range)}; 

if(contatore==range) {contatore=0; if(NR>=min && NR<=max) {media=somma/range; deltaMedia=MEDIA-media;};min=NR; max=min+range; somma=0;};

Y2=$Y+deltaMedia; 

#if(Y2>$Y) {Y2=$Y};
#if(Y2<$Y) {Y2=$Y};
if(media=="") {media=$Y};
somma+=$Y;
contatore++;
indice++;
}{print $1,$X,$Y,Y2} END {}' | tr -s ' '  | awk '{OFS="\t"; print}END{}' >> $HERE/$DATALOG.txt
wait

#cat $PREFIX/$DATALOG.dat.new.csv.tmp | awk '{OFS="\t"; print}END{}' >> $PREFIX/$DATALOG.dat.new.csv
#wait

unlink $HERE/$DATALOG.dat
wait

###############################################
#RANDOM=system("cat /dev/urandom| tr -dc '0-9' | fold -w 2| head -n 1");

#srand(system("cat /dev/urandom| tr -dc '0-9' | fold -w 2| head -n 1"));

#RANDOM=system("date +%N");
