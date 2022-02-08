#!/bin/bash -
#
# Bash и кибербезопасность
# histogram.sh
#
# Описание:
# Создание горизонтальной гистограммы с указанными данными
#
# Использование: ./histogram.sh
# формат ввода: label value
#
function pr_bar ()
{
	local -i i raw maxraw scaled
	raw=$1
	maxraw=$2
	((scaled=(MAXBAR*raw)/maxraw))
	# гарантированный минимальный размер
	((raw > 0 && scaled == 0)) && scaled=1

	for((i=0; i<scaled; i++)) ; do printf '#' ; done
	printf " $raw"
	printf '\n'
} # pr_bar
#
# "main"
#
declare -A RA
declare -i MAXBAR max
max=0
MAXBAR=50 # размер самой длинной строки

while read labl val
do
	let RA[$labl]=$val
	# сохранить наибольшее значение; для масштабирования
	(( val > max )) && max=$val
done

# масштабировать и вывести
for labl in "${!RA[@]}"
do
	printf '%-20.20s ' "$labl"
	pr_bar ${RA[$labl]} $max
done
