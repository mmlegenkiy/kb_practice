#!/bin/bash -
#
# Bash и кибербезопасность
# smtpconnect.sh
#
# Описание:
# Подключение к SMTP-серверу и печать приветственного баннера
#
# Использование:
# smtpconnect.sh <host>
# <host> SMTP-сервер для соединения
#

exec 3<>/dev/tcp/"$1"/25
echo -e 'quit\r\n' >&3
cat <&3
