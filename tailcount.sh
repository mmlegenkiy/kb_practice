#!/bin/bash -
#
# Bash и кибербезопасность
# tailcount.sh
#
# Описание:
# Подсчет строк каждые n секунд
#
# Использование: ./tailcount.sh [filename]
#
filename: проанализировать looper.sh
#
# очистка — другие процессы на выходе
function cleanup ()
{
	[[ -n $LOPID ]] && kill $LOPID
}

trap cleanup EXIT
bash looper.sh $1 &
LOPID=$!
# даем возможность начать
sleep 3

while true
do
	kill -SIGUSR1 $LOPID
	sleep 5
done >&2
