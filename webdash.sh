#!/bin/bash -
#
# Rapid Cybersecurity Ops
# webdash.sh
#
# Описание:
# Создание информационной панели
# Заголовок
# --------------
# Однострочный вывод
# --------------
# Вывод из пяти строк
# ...
# --------------
# Метки столбцов, а затем
# восемь строк гистограммы
# ...
# --------------
#

# некоторые важные постоянные строки
UPTOP=$(tput cup 0 0)
ERAS2EOL=$(tput el)
REV=$(tput rev)		# негативное изображение
OFF=$(tput sgr0)	# общий сброс
SMUL=$(tput smul)	# режим подчеркивания включен (пуск)
RMUL=$(tput rmul)	# режим подчеркивания выключен (сброс)
COLUMNS=$(tput cols)	# ширина нашего окна
# DASHES(ТИРЕ)='------------------------------------'
printf -v DASHES '%*s' $COLUMNS '-'
DASHES=${DASHES// /-}

#
# prSection – напечатать фрагмент экрана
#	напечатать $1-many строк из stdin
#	каждая строка представляет собой полную строку текста
#	с последующим стиранием до конца строки
#	разделы заканчиваются штриховой линией
#
function prSection ()
{
	local -i i
	for((i=0; i < ${1:-5}; i++))
	do
		read aline
		printf '%s%s\n' "$aline" "${ERAS2EOL}"
		done
	printf '%s%s\n%s' "$DASHES" "${ERAS2EOL}" "${ERAS2EOL}"
}

function cleanup()
{
	if [[ -n $BGPID ]]
	then
		kill %1
		rm -f $TMPFILE
	fi
} &> /dev/null

trap cleanup EXIT

# запустить процесс bg
TMPFILE=$(tempfile)
{ bash tailcount.sh $1 | \

	bash livebar.sh > $TMPFILE ; } &
BGPID=$!

clear
while true
do
	printf '%s' "$UPTOP"
	# заголовок:
	echo "${REV}Rapid Cyber Ops Ch. 12 -- Security Dashboard${OFF}" \
	| prSection 1
	#----------------------------------------
	{
		printf 'connections:%4d %s\n' \
		$(netstat -an | grep 'ESTAB' | wc -l) "$(date)"
	} | prSection 1
	#----------------------------------------
	tail -5 /var/log/syslog | cut -c 1-16,45-105 | prSection 5
	#----------------------------------------
	{ echo "${SMUL}yymmdd${RMUL}" \
		"${SMUL}hhmmss${RMUL}" \
		"${SMUL}count of events${RMUL}"
	tail -8 $TMPFILE
	} | prSection 9
	sleep 3
done
