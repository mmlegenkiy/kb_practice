#!/bin/bash -
#
# Bash и кибербезопасность
# looper.sh
#
# Описание:
# Подсчет строк в файле
#
# Использование: ./looper.sh [filename]
# filename — имя файла, который должен проверяться,
# по умолчанию: log.file
#
function interval ()
{
	echo $(date '+%y%m%d %H%M%S') $cnt
	cnt=0
}

declare -i cnt=0

trap interval SIGUSR1

shopt -s lastpipe 

tail -f --pid=$$ ${1:-log.file} | while read aline
do
	let cnt++
done
