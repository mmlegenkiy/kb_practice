#!/bin/bash -
#
# Bash и кибербезопасность
# winlogs.sh
#
# Описание:
# Собираем копии файлов журнала Windows
#
# Использование:
# winlogs.sh [-z]
#
# -z Заархивировать вывод
#
TGZ=0
if (( $# > 0 ))

then
if [[ ${1:0:2} == '-z' ]]

then
TGZ=1 # флаг tgz для tar/zip-архивирования лог-файлов
shift
fifi
SYSNAM=$(hostname)
LOGDIR=${1:-/tmp/${SYSNAM}_logs}

mkdir -p $LOGDIR
cd ${LOGDIR} || exit -2 
wevtutil el | while read ALOG
do
ALOG="${ALOG%$'\r'}"
echo "${ALOG}:"
SAFNAM="${ALOG// /_}"
SAFNAM="${SAFNAM//\//-}"
wevtutil epl "$ALOG" "${SYSNAM}_${SAFNAM}.evtx"
done 
if (( TGZ == 1 ))
then
tar -czvf ${SYSNAM}_logs.tgz *.evtx
fi
