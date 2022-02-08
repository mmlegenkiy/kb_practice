# Bash и кибербезопасность
# pagereq.awk
# Описание:
# Подсчет количества запросов страниц для данного IP-адреса с помощью awk
# Использование:
# pagereq <ip address> < inputfile
# <ip address> IP-адрес для поиска
# подсчитать количество запросов страниц с адреса ($1)
awk -v page="$1" '{ if ($1==page) {cnt[$7]+=1 } }
END { for (id in cnt) {
printf "%8d %s\n", cnt[id], id
}
}'
