#!/bin/bash -
#
# Bash и кибербезопасность
# typesearch.sh
#
# Описание:
# Поиск в файловой системе файлов указанного типа.
# Выводим путь, когда найдем.
#
# Использование:
# typesearch.sh [-c dir] [-i] [-R|r] <pattern> <path>
# -c Копировать найденные файлы в каталог
# -i Игнорировать регистр
# -R|r Рекурсивный поиск подкаталогов
# <pattern> Шаблон типа файла для поиска
# <path> Путь для начала поиска

DEEPORNOT="-maxdepth 1"

# анализ аргументов опции:
while getopts 'c:irR' opt; do
	case "${opt}" in
		c) # копировать найденные файлы в указанный каталог
			COPY=YES
			DESTDIR="$OPTARG"
			;;
		i) # игнорировать регистр при поиске
			CASEMATCH='-i'
			;;
		[Rr]) # рекурсивно
			unset DEEPORNOT;;
		*) # неизвестный/неподдерживаемый вариант
			# при получении ошибки mesg от gretops просто выйти
			exit 2 ;;
	esac
done

shift $((OPTIND - 1))

PATTERN=${1:-PDF document}
STARTDIR=${2:-.} # по умолчанию начать здесь

find $STARTDIR $DEEPORNOT -type f | while read FN
do
	file $FN | egrep -q $CASEMATCH "$PATTERN"
	if (( $? == 0 )) # найден один
	then
		echo $FN
		if [[ $COPY ]]
		then
			cp -p $FN $DESTDIR
		fi
	fi
done
