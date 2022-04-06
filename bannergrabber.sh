#!/bin/bash -
#
# Bash и кибербезопасность
# bannergrabber.sh
#
# Описание:
# Автоматическое извлечение баннеров с HTTP-, SMTP- и FTP-серверов
#
# Использование: ./bannergrabber.sh hostname [scratchfile]
# scratchfile используется во время обработки, но удаляется;
# по умолчанию: "scratch.file" или сгенерированное имя
#
#
function isportopen ()
{
	(( $# < 2 )) && return 1
	local host port
	host=$1
	port=$2
	echo >/dev/null 2>&1 < /dev/tcp/${host}/${port}
	return $?
}

function cleanup ()
{
	rm -f "$SCRATCH"
}

ATHOST="$1"
SCRATCH="$2"
if [[ -z $2 ]]
then
	if [[ -n $(type -p tempfile) ]]
	then
		SCRATCH=$(tempfile)
	else
		SCRATCH='scratch.file'
	fi
fi

trap cleanup EXIT
touch "$SCRATCH"

if isportopen $ATHOST 21	# FTP
then
	# например, ftp -n $ATHOST
	exec 3<>/dev/tcp/${ATHOST}/21
	echo -e 'quit\r\n' >&3
	cat <&3 >> "$SCRATCH"
fi

if isportopen $ATHOST 25	# SMTP
then
	# например, telnet $ATHOST 25
	exec 3<>/dev/tcp/${ATHOST}/25
	echo -e 'quit\r\n' >&3
	cat <&3 >> "$SCRATCH"
fi

if isportopen $ATHOST 80	# HTTP
then
	curl -LIs "https://${ATHOST}" >> "$SCRATCH"
fi

cat "$SCRATCH"
