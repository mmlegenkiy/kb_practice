# Bash и кибербезопасность
# pagereq.sh
#
# Описание:
# Подсчет с помощью bash количества запросов страниц для данного IP-адреса
#
# Использование:
# pagereq <ip address> < inputfile
# <ip address> IP-адрес для поиска
#
declare -A cnt
while read addr d1 d2 datim gmtoff getr page therest
do
	if [[ $1 == $addr ]] ; then let cnt[$page]+=1 ; fi
done
for id in ${!cnt[@]}
do
	printf "%8d %s\n" ${cnt[$id]} $id
done
