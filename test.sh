#!/usr/bin/env sh

p1=42
t1=32
t2=49
t3=44

echo "p1 = "$p1
echo "t1 = "$t1
echo "t2 = "$t2
echo "t3 = "$t3


echo ""
p1_set=40
t1_set=40
t2_set=40
t3_set=40

echo "p1_set = "$p1_set
echo "t1_set = "$t1_set
echo "t2_set = "$t2_set
echo "t3_set = "$t3_set

echo ""
p1_err=3
t1_err=3
t2_err=3
t3_err=3

echo "p1_err = "$p1_err
echo "t1_err = "$t1_err
echo "t2_err = "$t2_err
echo "t3_err = "$t3_err

echo ""
MESS=">>>> WARNING <<<<"
WARNING=0

[ $p1 -ge $(($p1_set+$p1_err)) ] || [ $p1 -le $(($p1_set-$p1_err)) ] && WARNING=1 && WARNING_p1=1 && MESS_p1=$(cat <<FINE
WARNING p1 = $p1
FINE
)
[ $t1 -ge $(($t1_set+$t1_err)) ] || [ $t1 -le $(($t1_set-$t1_err)) ] && WARNING=1 && WARNING_t1=1 && MESS_t1=$(cat <<FINE
WARNING t1 = $t1
FINE
)
[ $t2 -ge $(($t2_set+$t2_err)) ] || [ $t2 -le $(($t2_set-$t2_err)) ] && WARNING=1 && WARNING_t2=1 && MESS_t2=$(cat <<FINE
WARNING t2 = $t2
FINE
)
[ $t3 -ge $(($t3_set+$t3_err)) ] || [ $t3 -le $(($t3_set-$t3_err)) ] && WARNING=1 && WARNING_t3=1 && MESS_t3=$(cat <<FINE
WARNING t3 = $t3
FINE
)

if [ $WARNING = 1 ]
then
	echo ""
	echo $MESS_p1
	echo $MESS_t1
	echo $MESS_t2
	echo $MESS_t3
else
:
fi
