#!/bin/bash -
#
# Bash и кибербезопасность
# autoscan.sh
#
# Описание:
# Автоматическое сканирование портов (с помощью сценария scan.sh)
# Сравнение вывода с предыдущими результатами и e-mail пользователя
# Предполагается, что сценарий scan.sh находится в текущем каталоге
#
# Использование: ./autoscan.sh
#

./scan.sh < hostlist

FILELIST=$(ls scan_* | tail -2)
FILES=( $FILELIST )

TMPFILE=$(tempfile)

./fd2.sh ${FILES[0]} ${FILES[1]} > $TMPFILE

if [[ -s $TMPFILE ]]
# не пустой
then
	echo "mailing today's port differences to $USER"
	mail -s "today's port differences" $USER < $TMPFILE
fi
# очистка
rm -f $TMPFILE
