#!/bin/bash -
#
# Bash и кибербезопасность
# scan.sh
#
# Описание:
# Сканирование порта указанного хоста
#
# Использование: ./scan.sh <output file>
# <output file> Файл, куда сохраняются результаты
#
function scan ()
{
	host=$1
       	printf '%s' "$host"
       	for ((port=1;port<1024;port++))
	do
       		# порядок перенаправления важен по двум причинам
		echo >/dev/null 2>&1 < /dev/tcp/${host}/${port}
		if (($? == 0)) ; then printf ' %d' "${port}" ; fi
	done
	echo # или вывести '\n'
}

#
# основной цикл
# читать имя каждого узла (из stdin)
# и искать открытые порты
# сохранить результаты в файл,
# имя которого указано в качестве аргумента,
# или задать имя по умолчанию на основе текущей даты
#

printf -v TODAY 'scan_%(%F)T' -1 # например, scan_2017-11-27
OUTFILE=${1:-$TODAY}

while read HOSTNAME
do
	scan $HOSTNAME
done > $OUTFILE
