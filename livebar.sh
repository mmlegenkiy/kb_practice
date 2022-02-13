#!/bin/bash -
#
# Bash и кибербезопасность
# livebar.sh
#
# Описание:
# Создание горизонтальной гистограммы «живых» данных
#
# Использование:
# <output from other script or program> | bash livebar.sh
#
function pr_bar ()
{
	local raw maxraw scaled
	raw=$1
	maxraw=$2
	((scaled=(maxbar*raw)/maxraw))
	((scaled == 0)) && scaled=1
	# гарантированный минимальный размер
	for((i=0; i<scaled; i++)) ; do printf '#' ; done
	printf '\n'
} # pr_bar

maxbar=60
# наибольшее количество символов в строке
MAX=60
while read dayst timst qty
do
	if (( qty > MAX ))
	then
		let MAX=$qty+$qty/4
		# предоставляем немного места
		echo "              **** rescaling: MAX=$MAX"
	fi
	printf '%6.6s %6.6s %4d:' $dayst $timst $qty
	pr_bar $qty $MAX
done
