#!/bin/bash -
#
# Bash и кибербезопасность
# histogram_plain.sh
#
# Описание:
# Создание горизонтальной гистограммы с указанными данными без использования
# ассоциативных массивов, хорошо подходит для старых версий bash
#
# Использование: ./histogram_plain.sh
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
	printf '\n'
} # pr_bar
#
# "main"
#
declare -a RA_key RA_val
declare -i max ndx
max=0
MAXBAR=50 # размер самой длинной строки

ndx=0
while read labl val
do
	RA_key[$ndx]=$labl
	RA_val[$ndx]=$val
	# сохранить наибольшее значение; для масштабирования
	(( val > max )) && max=$val
	let ndx++
done

# масштабировать и вывести
for ((j=0; j<ndx; j++))
do
	printf '%-20.20s ' ${RA_key[$j]}
	pr_bar ${RA_val[$j]} $max
done
