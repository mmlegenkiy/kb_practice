# Bash и кибербезопасность
# countem.awk
# Описание:
# Подсчет количества экземпляров элемента с помощью команды awk
# Использование:
# countem.awk < inputfile
awk '{ cnt[$1]++ }
END { for (id in cnt) {
	printf "%d %s\n", cnt[id], id
	}
}'
