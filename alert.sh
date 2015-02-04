#!/usr/bin/env sh
# alert.sh 1.1
# Luca Cappelletti (2015) <luca.cappelletti@gmail.com
#
# AI_0_PRESSIONE_1 AI_1_TEMPERATURA_4 AI_2_TEMPERATURA_2 AI_3_TEMPERATURA_1
## AI_0_PRESSIONE_1 AI_1_TEMPERATURA_4 AI_2_TEMPERATURA_3 AI_3_TEMPERATURA_1#

# SET
p1_set=40
t1_set=40
t2_set=40
t4_set=40

# ERROR
p1_err=3
t1_err=3
t2_err=3
t4_err=3

NOME_MITTENTE=""
EMAIL_MITTENTE=""

        lst=$(ls *.txt -tr | tail -n 2 | sort | tail -n 1)
        id=$(echo $lst | cut -d"_" -f 1)
        head=$(awk 'NR==22 {print $3,$4,$5,$6}' $lst)
        first=$(awk 'NR==23 {print $2,$3,$4,$5}' $lst)
        middle=$(awk 'NR==1800 {print $2,$3,$4,$5}' $lst)
        last=$(awk '{}END{print $2,$3,$4,$5}' $lst)

        p1=$(echo $head | cut -d" " -f 1 | cut -d"_" -f 3,4 | tr '_' ' ')
        t1=$(echo $head | cut -d" " -f 4 | cut -d"_" -f 3,4 | tr '_' ' ')
        t2=$(echo $head | cut -d" " -f 3 | cut -d"_" -f 3,4 | tr '_' ' ')
        #t3=$(echo $head | cut -d" " -f 3 | cut -d"_" -f 3,4 | tr '_' ' ')
        t4=$(echo $head | cut -d" " -f 2 | cut -d"_" -f 3,4 | tr '_' ' ')

        mittente=$EMAIL_MITTENTE
        soggetto=$lst

        TAB="$(printf '\t')"

	p1_val=$(echo $last | awk '{print $1}')
        t1_val=$(echo $last | awk '{print $4}')
        t2_val=$(echo $last | awk '{print $3}')
        t4_val=$(echo $last | awk '{print $2}')

        for destinatario in "DESTINATARIO_1" "DESTINATARIO_2" "DESTINATARIO_3"
        do

msmtp --debug -a default $destinatario<<EOF
From: "$NOME MITTENTE" <$mittente>
To: $destinatario
Subject: $soggetto
corpo del messaggio

ID:${TAB}$id
Nome file:${TAB}$lst

valori ricavati dall'ultima riga del file

$p1:${TAB}$p1_val
$t1:${TAB}$t1_val
$t2:${TAB}$t2_val
$t4:${TAB}$t4_val

.
EOF
        wait
        sleep 2

	done

MESS=">>>> WARNING <<<<"
WARNING=0

[ $p1_val -ge $(($p1_set+$p1_err)) ] || [ $p1_val -le $(($p1_set-$p1_err)) ] && WARNING=1 && WARNING_p1=1 && MESS_p1=$(cat <<FINE
WARNING p1 = $p1_val
FINE
)
[ $t1_val -ge $(($t1_set+$t1_err)) ] || [ $t1_val -le $(($t1_set-$t1_err)) ] && WARNING=1 && WARNING_t1=1 && MESS_t1=$(cat <<FINE
WARNING t1 = $t1_val
FINE
)
[ $t2_val -ge $(($t2_set+$t2_err)) ] || [ $t2_val -le $(($t2_set-$t2_err)) ] && WARNING=1 && WARNING_t2=1 && MESS_t2=$(cat <<FINE
WARNING t2 = $t2_val
FINE
)
[ $t4_val -ge $(($t4_set+$t4_err)) ] || [ $t4_val -le $(($t4_set-$t4_err)) ] && WARNING=1 && WARNING_t4=1 && MESS_t4=$(cat <<FINE
WARNING t4 = $t4_val
FINE
)

if [ $WARNING = 1 ]
then
        echo ""
        echo $MESS_p1
        echo $MESS_t1
        echo $MESS_t2
        echo $MESS_t4


        for destinatario in "DESTINATARIO_1" "DESTINATARIO_2" "DESTINATARIO_3"
        do

msmtp --debug -a default $destinatario<<EOF
From: "NOME MITTENTE" <$mittente>
To: $destinatario
Subject: $MESS

ATTENZIONE!

ID:${TAB}$id
Nome file:${TAB}$lst

 $MESS_p1_val
 $MESS_t1_val
 $MESS_t2_val
 $MESS_t4_val

.
EOF

else
:
fi
