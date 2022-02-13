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
# filename: проанализировать looper.sh
#
# очистка — другие процессы на выходе
function cleanup ()
{
	[[ -n $LOPID ]] && kill $LOPID
}

ind=5
while getopts ':i:' opt; do
	case "${opt}" in
		i) # option -i is obtained
			ind="$OPTARG"
			;;
		*) # option -i is not obtained
			echo "Wrong option"
			exit 2
			;;
	esac
done
shift $((OPTIND - 1))

trap cleanup EXIT
bash looper.sh $1 &
LOPID=$!
# даем возможность начать
sleep 3

while true
do
	kill -SIGUSR1 $LOPID
	sleep $ind
done >&2
