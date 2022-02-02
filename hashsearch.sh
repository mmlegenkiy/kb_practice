#!/bin/bash -
#
# Bash и кибербезопасность
# hashsearch.sh
#
# Описание:
# В указанном каталоге выполняем рекурсивный поиск
# файла по заданному SHA-1
#
# Использование:
#
# hashsearch.sh <hash> <directory>
# hash - Значение хеша SHA-1 разыскиваемого файла
#
# directory - Каталог для поиска
#
HASH=$1
DIR=${2:-.}  #wd, по умолчанию это здесь
# конвертируем путь в абсолютный
function mkabspath ()
{
	if [[ $1 == /* ]]
	then
		ABS=$1
	else
		ABS="$PWD/${1#*/}"
	fi
}
find $DIR -type f |
while read fn
do
	THISONE=$(sha1sum "$fn")
	THISONE=${THISONE%% *}
	if [[ $THISONE == $HASH ]]
	then
		mkabspath "$fn"
		echo $ABS
	fi
done
