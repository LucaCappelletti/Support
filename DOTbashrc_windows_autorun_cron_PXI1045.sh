# /etc/bash.bashrc
# .bashrc
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.

if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.  #65623
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize

# Enable history appending instead of overwriting.  #139609
shopt -s histappend

# Change the window title of X terminals 
case ${TERM} in
	xterm*|rxvt*|Eterm|aterm|kterm|gnome*|interix)
		PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\007"'
		;;
	screen)
		PROMPT_COMMAND='echo -ne "\033_${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\033\\"'
		;;
esac

use_color=false

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS.  Try to use the external file
# first to take advantage of user additions.  Use internal bash
# globbing instead of external grep binary.
safe_term=${TERM//[^[:alnum:]]/?}   # sanitize TERM
match_lhs=""
[[ -f ~/.dir_colors   ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs}    ]] \
	&& type -P dircolors >/dev/null \
	&& match_lhs=$(dircolors --print-database)
[[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] && use_color=true

if ${use_color} ; then
	# Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
	if type -P dircolors >/dev/null ; then
		if [[ -f ~/.dir_colors ]] ; then
			eval $(dircolors -b ~/.dir_colors)
		elif [[ -f /etc/DIR_COLORS ]] ; then
			eval $(dircolors -b /etc/DIR_COLORS)
		fi
	fi

	if [[ ${EUID} == 0 ]] ; then
		PS1='\[\033[01;31m\]\h\[\033[01;34m\] \W \$\[\033[00m\] '
	else
		PS1='\[\033[01;32m\]\u@\h\[\033[01;34m\] \w \$\[\033[00m\] '
	fi

	alias ls='ls --color=auto'
	alias grep='grep --colour=auto'
else
	if [[ ${EUID} == 0 ]] ; then
		# show root@ when we do not have colors
		PS1='\u@\h \W \$ '
	else
		PS1='\u@\h \w \$ '
	fi
fi

# Try to keep environment pollution down, EPA loves us.
unset use_color safe_term match_lhs

alias ls='ls --color=auto'
export PS1='\e[1;33;47m\u \e[1;32;47mon \h \e[1;35;47m\d \@\e[0;0m\n\e[1;34m[dir.= \w] \# > \e[0;0m'

# 
#UpdateAltaFrequenza
#Run: C:\WINDOWS\system32\cmd.exe /c ""C:\Program Files\Git\bin\sh.exe" --login -i"
#start in C:\

#schedule: 08 - 18

#Archivio same but
#schedule: 06 - 20

ReqDir=$PWD
Ora=$(date +%H)

echo ""
echo $PWD
echo ""

WORKINGDIR="C:KPR/Acquisizioni/"
SHAREDIR="C:Programmi/LightTPD/htdocs/KPR/"

if [ "$ReqDir" == "/c" ] || [ "$ReqDir" == "/C" ]
then	

    echo "ReqDir = "$ReqDir

	if [ $Ora -gt 01 ] && [ $Ora -lt 23 ]
	then

		# alta frequenza durante la giornata per poter osservare da remoto le evoluzioni
		# gestito da un cron specifico (i.e ogni 2 ore)
		
		cd $WORKINGDIR
		git add -A .
		wait
		git commit -m $(date +%s)
		wait	
		
		sleep 10
	
		cd $SHAREDIR
		git pull
		wait
		
		sleep 10

		rm 000_ULTIMO_AGGIORNAMENTO*
		wait
		touch $(echo "000_ULTIMO_AGGIORNAMENTO_IL-"$(date +%d_%m_%Y)"-ALLE-"$(date +%H_%M"_GMT"))
		wait

		sleep 10
		
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

		
				
    exit
	
	else

		# bassa frequenza serale e mattutino per poter archiviare storicamente il lavoro
		# gestito da un cron specifico (i.e. la sera alle 20 e la mattina alle 7)
			
		cd $WORKINGDIR
		git add -A .
		wait
		git commit -m $(date +%s)
		wait
	
		cd $SHAREDIR
		git pull
		wait
		
		    echo "ReqDir = "$ReqDir

### TODO REFACTORING IN FUNC
		    
        # alert.sh
        # Luca Cappelletti (2015) <luca.cappelletti@gmail.com
        #
        # AI_0_PRESSIONE_1 AI_1_TEMPERATURA_4 AI_2_TEMPERATURA_2 AI_3_TEMPERATURA_1
        #
        
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
		    
		    cd
		    exit

	fi
	
else

    cd $ReqDir
    # directory con tanti files è lentissimo su windows
    #ls --color

fi

# ultimo="$(ls -tr | tail -n 1)"

#.msmtp
#account CSM
#host INDIRIZZO HOST (smtp.fdfdfdfdfd.it)
#from EMAIL
#user UTENTE
#password SOSTITUISCI_AL_TEST
# PROTOTIPO PER SENDMAIL
#echo -e "Subject: Test Mail\r\n\r\nCorpo del messaggio" |msmtp --debug --from=default -t EMAIL_MITTENTE

#destinatari="SEPARATI_DALLE_VIRGOLE"
##mittente=EMAIL_MITTENTE
#soggetto="TEST"$(date +%s)

#msmtp --debug  "$destinatari" <<EOF
#Subject:$soggetto
#From:$mittente
#Example Message
#EOF
