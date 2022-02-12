# this script translate ip-address to number
# example: 10.124.16.3 translates to 10124016003
# using: ip2num.sh <addr>
addr=$1
num=$(echo $addr| cut -d'.' -f4)
num=$(($num+1000*$(echo $addr| cut -d'.' -f3)))
num=$(($num+1000000*$(echo $addr| cut -d'.' -f2)))
num=$(($num+1000000000*$(echo $addr| cut -d'.' -f1)))
echo $num
