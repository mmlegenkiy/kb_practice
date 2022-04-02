#!/bin/bash -
#
# Bash и кибербезопасность
# baseline.sh
#
# Описание:
# Создает базовый файл или сравнивает текущее состояние
# файловой системы с предыдущим базовым файлом
#
# Использование: ./baseline.sh [-d path] <file1> [<file2>]
# -d Стартовый каталог для базового файла
# <file1> Если указан только один файл, создать новый базовый файл
# [<file2>] Предыдущий базовый файл для сравнения
#

function usageErr()
{
	echo 'usage: baseline.sh [-d path] file1 [file2]'
	echo 'creates or compares a baseline from path'
	echo 'default for path is /'
	exit 2
} >&2

function dosumming ()
{
	find "${DIR[@]}" -type f | xargs -d '\n' sha1sum
}

function parseArgs()
{
#	echo "number of args $#"
	while getopts "d:" MYOPT
	do
		echo "option -d found"
		# не проверяется MYOPT, так как существует только один вариант
		DIR+=( "$OPTARG" )
	done
	# shift $((OPTIND-1))
	return $((OPTIND-1))

	# нет аргументов? слишком много?
#	(( $# == 0 || $# > 2 )) && usageErr

#	(( ${#DIR[*]} == 0 )) && DIR=( "/" )
}

declare -a DIR

# создайте базовый файл (предоставляется только одно имя файла)
# либо сделайте вторичные краткие выводы (при наличии двух имен файлов)

#echo "we have $# args"
	while getopts "d:" MYOPT
	do
#		echo "option -d found"
		# не проверяется MYOPT, так как существует только один вариант
		DIR+=( "$OPTARG" )
	done
	 shift $((OPTIND-1))
	
#echo "we have $# args"
	# нет аргументов? слишком много?
	(( $# == 0 || $# > 2 )) && usageErr

	(( ${#DIR[*]} == 0 )) && DIR=( "/" )

#echo "I am here!"
BASE="$1"
B2ND="$2"

if (( $# == 1 )) # только один аргумент
then
	# создание "$BASE"
	dosumming > "$BASE"
	# все сделано для базового файла
	exit
fi

if [[ ! -r "$BASE" ]]
then
	usageErr
fi

# если второй файл существует, сравнить оба файла
# иначе создать/заполнить его
if [[ ! -e "$B2ND" ]]
then
	echo creating "$B2ND"
	dosumming > "$B2ND"
fi
# что мы имеем: создано два файла sha1sum
declare -A BYPATH BYHASH INUSE
# ассоциативные массивы

# в качестве базового загрузите первый файл
while read HNUM FN
do
	BYPATH["$FN"]=$HNUM
	BYHASH[$HNUM]="$FN"
	INUSE["$FN"]="X"
done < "$BASE"

# ------ теперь начинаем вывод
# смотрим, есть ли каждое имя файла, указанное во втором файле,
# по такому же месторасположению (пути), что и в первом (базовом файле)

printf '<filesystem host="%s" dir="%s">\n' "$HOSTNAME" "${DIR[*]}"

while read HNUM FN
do
	WASHASH="${BYPATH[${FN}]}"
	# нашел ли он его? если нет, то это будет null
	if [[ -z $WASHASH ]]
	then
		ALTFN="${BYHASH[$HNUM]}"
		if [[ -z $ALTFN ]]
		then
			printf ' <new>%s</new>\n' "$FN"
		else
			printf ' <relocated orig="%s">%s</relocated>\n' "$ALTFN" "$FN"
			INUSE["$ALTFN"]='_' # пометить как просмотренное
		fi
	else
		INUSE["$FN"]='_' # пометить как просмотренное
		if [[ $HNUM == $WASHASH ]]
		then
			continue; # ничего не изменилось;
		else
			printf ' <changed>%s</changed>\n' "$FN"
		fi
	fi
done < "$B2ND"

for FN in "${!INUSE[@]}"
do
	if [[ "${INUSE[$FN]}" == 'X' ]]
	then
		printf ' <removed>%s</removed>\n' "$FN"
	fi
done

printf '</filesystem>\n'
