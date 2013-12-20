#!/usr/bin/env sh
# 
# Plotta.sh - Luca Cappelletti (2013) - License WTF
# plotta in modo ricorsivo tutti i dati dei files della cartella corrente
#
# tipici tipi di plot:
# lines,points,dots,linespoints
#
COLONNA_X=$1
COLONNA_Y=$2
STYLE=$3
COLONNA_Y2=$4
EXT="csv.txt"

if [ $COLONNA_X = "--help" ] 
then

	printf "\nPlotta.sh 1.0 - Luca Cappelletti (2013) - License WTF\n\nuso:\n"$0" X Y stile_plot [lines,dots,points,linespoints]\n\n" 
	exit 1
else
:
fi

[ -z $1 ] && COLONNA_X=1
[ -z $2 ] && COLONNA_Y=2
[ -z $3 ] && STYLE=lines
[ -z $4 ] && COLONNA_Y2=""

HERE="$(pwd)"

echo "Colonna X = "$COLONNA_X
echo "Colonna Y = "$COLONNA_Y
echo "Colonna Y2 = "$COLONNA_Y2
echo "Stile = "$STYLE

cd $HERE

if [ -z $4 ]
then

    echo "Y2 OFF"
    for new in $(ls *.$EXT)
    do

        fileName=$(basename $new | tr -s ' ' | tr ' ' '_' | cut -d"." -f 1)
        #	gnuplot -persist -e "plot \""$new"\" using 1:2 with lines, '' using 1:3 with lines"
        [ -f $new ]  && (file $new | grep text) && gnuplot -persist -e "set terminal png size 1280,1024; set output \""$fileName".png\"; set key autotitle columnheader; plot \""$new"\" using "$COLONNA_X":"$COLONNA_Y" with "$STYLE &

    done
    printf "\n"
    exit
    
else

    echo "Y2 ON"
    for new in $(ls *.$EXT)
    do

        fileName=$(basename $new | tr -s ' ' | tr ' ' '_' | cut -d"." -f 1)
        #	gnuplot -persist -e "plot \""$new"\" using 1:2 with lines, '' using 1:3 with lines"
        [ -f $new ]  && (file $new | grep text) && gnuplot -persist -e "set terminal png size 1280,1024; set output \""$fileName".png\"; set key autotitle columnheader; plot \""$new"\" using "$COLONNA_X":"$COLONNA_Y" with "$STYLE", '' using "$COLONNA_X":"$COLONNA_Y2" with "$STYLE &

    done
    printf "\n"
    exit

fi    
