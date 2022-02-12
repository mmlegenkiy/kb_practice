# scritpt to write to file
# for tail -f testing
i=1
while true
do 
	if [ $i -eq 10 ]
	then
		echo template >> $1
		i=0
	else
		echo text >> $1
	fi
	if [ $i -eq 3 ]
	then
		echo "../" >> $1
	fi
	if [ $i -eq 7 ]
	then
		echo "cmd.exe" >> $1
	fi
	if [ $i -eq 5 ]
	then
		echo "etc/passwd" >> $1
	fi
	let i++
	sleep 0.1
done
