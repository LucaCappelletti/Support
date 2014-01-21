#!/usr/bin/env sh
# 
# Plotta.sh - Luca Cappelletti (2013-2014) - License WTF
#
# v1.0
#
# plotta in modo ricorsivo tutti i dati dei files della cartella corrente
#
# tipici tipi di plot:
# lines,points,dots,linespoints
#
# si aspetta in ingresso un file separato da spazi con prima riga le intestazioni delle colonne
#
COLONNA_X=$1
COLONNA_Y=$2
STYLE=$3
COLONNA_Y2=$4
EXT="txt"
TEMPO=100000

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

label_y="Estensimetro"

echo "Colonna X = "$COLONNA_X
echo "Colonna Y = "$COLONNA_Y
echo "Colonna Y2 = "$COLONNA_Y2
echo "Stile = "$STYLE

### PREPROCESSING

# colori da 1 a 9
# 1 - Red, 2 - Green, 3 - Blue, 4 - Magenta, 5 - Lightblue, 6 - Yellow, 7 - Black, 8 - Orange, 9 - Grey
COLORE_Y=$(shuf -i 1-9 -n 1)
echo "DEBUG: COLORE_Y = "$COLORE_Y2

COLORE_Y2=$(shuf -i 1-9 -n 1)
echo "DEBUG: COLORE_Y2 = "$COLORE_Y2

cd $HERE

if [ -z $4 ]
then

    echo "Y2 OFF"
    for new in $(ls *.$EXT)
    do

        fileName=$(basename $new | tr -s ' ' | tr ' ' '_' | cut -d"." -f 1)
        #	gnuplot -persist -e "plot \""$new"\" using 1:2 with lines, '' using 1:3 with lines"
        
        echo "DEBUG: new = "$new
        
        label_x="$(head -n+1 $new | sed -s 's/ /\t/g' | cut -f$COLONNA_X)"
        label_y="$(head -n+1 $new | sed -s 's/ /\t/g' |cut -f$COLONNA_Y)"

        echo "DEBUG: label_x = "$label_x
        echo "DEBUG: label_y = "$label_y 
	
	MIN=$(cat $HERE/$new | tail -n+2 | sed -s 's/ /\t/g' | awk -v COLONNA=$COLONNA_Y -v SECONDI=$TEMPO '{if(NR==SECONDI) {exit}}; {if(min==""){min=$COLONNA}; if($COLONNA<min) {min=$COLONNA};} END {print min}')
	MAX=$(cat $HERE/$new | tail -n+2 | sed -s 's/ /\t/g' | awk -v COLONNA=$COLONNA_Y -v SECONDI=$TEMPO '{if(NR==SECONDI) {exit}}; {if(max==""){max=$COLONNA}; if($COLONNA>max) {max=$COLONNA};} END {print max}')	

#		log_file=$(echo $new | sed 's/.txt/.log/g')
#		echo "DEBUG: logfile = $log_file"
#
#		MIN=$(cat $log_file | grep MIN | cut -d"=" -f 2 | sed 's/ //g')
#		MAX=$(cat $log_file | grep MAX | cut -d"=" -f 2 | sed 's/ //g')

		echo "DEBUG: MIN = "$MIN
		echo "DEBUG: MAX = "$MAX

		min_y=$(echo "$MIN - ($MAX - $MIN)" | bc)
		max_y=$(echo "$MAX + ($MAX - $MIN)" | bc)

        echo "DEBUG: min_y = "$min_y
        echo "DEBUG: max_y = "$max_y        

        [ -f $new ]  && (file $new | grep $EXT) && gnuplot -persist -e "set terminal png size 1280,1024; set output \""$new"__"$label_y"__.png\"; set key autotitle columnheader; set xlabel \""$label_x"\";set ylabel \""$label_y"\";set key default; set yrange ["$min_y":"$max_y"];plot \""$new"\" using "$COLONNA_X":"$COLONNA_Y" title \""$label_y"\" with "$STYLE" ls \"$COLORE_Y\" "


    done
    printf "\n"
    exit

else

    echo "Y2 ON"
    for new in $(ls *.$EXT)
    do

        fileName=$(basename $new | tr -s ' ' | tr ' ' '_' | cut -d"." -f 1)
        #	gnuplot -persist -e "plot \""$new"\" using 1:2 with lines, '' using 1:3 with lines"
        label_y="$(head -n+1 $new | cut -f$COLONNA_Y | grep [0-9][A-Z])"
        [ -f $new ]  && (file $new | grep text) && gnuplot -persist -e "set terminal png size 1280,1024; set output \""$new"__"$label_y"__.png\"; set key autotitle columnheader; plot \""$new"\" using "$COLONNA_X":"$COLONNA_Y" title \""$label_y"\" with "$STYLE", '' using "$COLONNA_X":"$COLONNA_Y2" with "$STYLE

    done
    printf "\n"
    exit

fi    




# http://jswails.wikidot.com/using-gnuplot
# http://www.gnuplotting.org