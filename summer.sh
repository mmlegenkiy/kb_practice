#!/bin/bash -
#
# Bash и кибербезопасность
# summer.sh
#
# Описание:
# Суммировать итоговые значения поля 2 для каждого уникального поля 1
#
# Использование: ./summer.sh
# формат ввода: <name> <number>
#
declare -A cnt
# ассоциативный массив
while read id count
do
	let cnt[$id]+=$count
done
for id in "${!cnt[@]}"
do
	printf "%-15s %8d\n" "${id}" "${cnt[${id}]}"
done
