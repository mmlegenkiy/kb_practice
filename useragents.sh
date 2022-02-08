#!/bin/bash -
#
# Bash и кибербезопасность
# useragents.sh
#
# Описание:
# Чтение журнала и поиск неизвестных пользовательских агентов
#
# Использование: ./useragents.sh < <inputfile>
# <inputfile> Журнал веб-сервера Apache
#
# несовпадение — поиск по массиву известных имен
# возвращает 1 (false), если совпадение найдено
# возвращает 0 (true), если совпадений нет
function mismatch ()
{
	local -i i
	for ((i=0; i<$KNSIZE; i++))
	do
		[[ "$1" =~ .*${KNOWN[$i]}.* ]] && return 1
	done
	return 0
}

readarray -t KNOWN < "useragents.txt"
KNSIZE=${#KNOWN[@]}

# предварительная обработка лог-файла (stdin),
# чтобы выбрать IP-адреса и пользовательские агенты
awk -F'"' '{print $1, $6}' | \
while read ipaddr dash1 dash2 dtstamp delta useragent
do
	if mismatch "$useragent"
	then
		echo "anomaly: $ipaddr $useragent"
	fi
done
