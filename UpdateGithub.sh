#!/usr/bin/env sh

[ -z $1 ] && echo "passare user.name e user.email" && exit 1

USER=$1
EMAIL=$2

git config --global user.name "$USER"
git config --global user.email $EMAIL

echo "Aggiungo i cambiamenti al database locale"
git add .

echo "Eseguo la finalizzazione dei cambiamenti in locale"
git commit -a -m "$(date +%s)"

echo "Invio i cambiamenti locali al deposito remoto..."
git push origin master
echo "ok"
