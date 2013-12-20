#!/usr/bin/env sh
#
# Calcola Statistica

[ -z $1 ] && echo "devi passare il nome di un file ed eventualmente la colonna di riferimento se il file è multicolonna separato da TAB" && exit 1


[ ! -z $2 ] && colonna=$2 || colonna=1

#media=$(cat $1 | awk -v COLONNA=$colonna '{sum+=$COLONNA} END {print sum/NR}')

media=63

#cat $1 | awk -v Y=$colonna -v MEDIA=$media '{ if(min=="") {min=MEDIA}; if($Y<min && $Y<MEDIA) {min=$Y; print min} ; if($Y>min && $Y<MEDIA) {}; } END {}'

#cat $1 | awk -v Y=$colonna -v MEDIA=$media '{ if(min=="") {min=MEDIA}; if($Y<min && $Y<MEDIA) {min=$Y; print $Y} } END {}'

#echo "[Shell] MEDIA : "$media

# inizializzazione
#se min=="" allora min=MEDIA
#se dir=="" allora dir=DOWN

# run
#se dir==DOWN e Y<min allora min=Y 
#se dir==DOWN e Y>min allora print min e min=Y e dir=UP
#se dir==UP e Y>min allora min=Y
#se dir==UP e Y<min allora min=Y e dir=DOWN
#
# dir: 0 DOWN - 1 UP


#cat $1 | awk -v y=$colonna -v MEDIA=$media '{ Y=$y; if(Z>MEDIA) {Y=MEDIA}; Y=(Y-MEDIA); if(min=="") {min=MEDIA}; if(dir=="") {dir=0}; if(dir==0 && Y<min) {min=Y; print "DOWN :: Y<min"}; if(dir==0 && Y>min) {print min,"DOWN :: Y>min -- min=Y -- dir=UP"; min=Y; dir=1;}; if(dir==1 && Y>min) {min=Y; print "UP :: Y>min"}; if(dir==1 && Y<min) {min=Y; dir=0; print "UP :: Y<min -- min=Y -- dir=DOWN"};} END {}'

cut=74.5

cat $1 | awk -v CUT=$cut -v y=$colonna -v MEDIA=$media '{ Y=$y; if(Y<MEDIA) {Y=MEDIA}; if(Y>CUT) {Y=CUT}; if(min=="") {max=MEDIA}; if(dir=="") {dir=1}; if(dir==1 && Y>min) {min=Y;}; if(dir==1 && Y<min) {print $1,min; min=Y; dir=0;}; if(dir==0 && Y<min) {min=Y;}; if(dir==0 && Y>min) {min=Y; dir=1;};} END {}'