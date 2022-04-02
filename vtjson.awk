# Bash и кибербезопасность
# vtjson.awk
#
# Описание:
# Поиск вредоносных программ в файле JSON
#
# Использование:
# vtjson.awk <json file>
# <json file> Файл с результатами VirusTotal
#

FN="${1:-Calc_VirusTotal.txt}"
sed -e 's/{"scans": {/&\n /' -e 's/},/&\n/g' "$FN" |
awk '
NF == 9 {
	COMMA=","
	QUOTE="\""
	if ( $3 == "true" COMMA ) {
		VIRUS=$1
		gsub(QUOTE, "", VIRUS)

		RESLT=$7
		gsub(QUOTE, "", RESLT)
		gsub(COMMA, "", RESLT)
	print VIRUS, "- result:", RESLT
	}
}'
