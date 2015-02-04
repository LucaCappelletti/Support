#!/usr/bin/env sh
# alert.sh
# Luca Cappelletti (2015) <luca.cappelletti@gmail.com
#
# AI_0_PRESSIONE_1 AI_1_TEMPERATURA_4 AI_2_TEMPERATURA_2 AI_3_TEMPERATURA_1
## AI_0_PRESSIONE_1 AI_1_TEMPERATURA_4 AI_2_TEMPERATURA_3 AI_3_TEMPERATURA_1#
        
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
        
        mittente=EMAIL_MITTENTE
        soggetto=$lst
        
        TAB="$(printf '\t')"

        for destinatario in "DESTINATARIO_1" "DESTINATARIO_2" "DESTINATARIO_3"
        do

msmtp --debug -a default $destinatario<<EOF
From: "NOME MITTENTE" <$mittente>
To: $destinatario
Subject: $soggetto
corpo del messaggio

ID:${TAB}$id
Nome file:${TAB}$lst

valori ricavati dall'ultima riga del file

$p1:${TAB}$(echo $last | awk '{print $1}')
$t1:${TAB}$(echo $last | awk '{print $4}')
$t2:${TAB}$(echo $last | awk '{print $3}')
$t4:${TAB}$(echo $last | awk '{print $2}')

.
EOF
        wait
        sleep 2

        done
