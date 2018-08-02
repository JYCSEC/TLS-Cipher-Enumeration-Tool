#!/bin/bash
#JYC
#

#Give IP if not given
if [ -z "$1" ]
then
	echo "Gimme IP:"
	read eyep
else
	eyep=$1
fi

#Give Port if not given
if [ -z "$2" ]
then
	echo "Gimme port:" 
	read p
else
	p=$2
fi

if [ -z "$3" ]
then
	fs="13"
else
	fs="1337"
fi

#Makes Outputfile and formats if not failsafe'd
if [ $fs="13" ]
then
echo "cipher,TLS1,TLS1_1,TLS1_2" >> output_$eyep":"$p.csv
fi
tlssy=("tls1" "tls1_1" "tls1_2")
ciphers=("AES128-GCM-SHA256" "AES128-SHA" "AES128-SHA256" "AES256-GCM-SHA384" "AES256-SHA" "AES256-SHA256" "DHE-PSK-AES128-CBC-SHA" "DHE-PSK-AES128-CBC-SHA256" "DHE-PSK-AES128-GCM-SHA256" "DHE-PSK-AES256-CBC-SHA" "DHE-PSK-AES256-CBC-SHA384" "DHE-PSK-AES256-GCM-SHA384" "DHE-PSK-CHACHA20-POLY1305" "DHE-RSA-AES128-GCM-SHA256" "DHE-RSA-AES128-SHA" "DHE-RSA-AES128-SHA256" "DHE-RSA-AES256-GCM-SHA384" "DHE-RSA-AES256-SHA" "DHE-RSA-AES256-SHA256" "DHE-RSA-CHACHA20-POLY1305" "ECDHE-ECDSA-AES128-GCM-SHA256" "ECDHE-ECDSA-AES128-SHA" "ECDHE-ECDSA-AES128-SHA256" "ECDHE-ECDSA-AES256-GCM-SHA384" "ECDHE-ECDSA-AES256-SHA" "ECDHE-ECDSA-AES256-SHA384" "ECDHE-ECDSA-CHACHA20-POLY1305" "ECDHE-PSK-AES128-CBC-SHA" "ECDHE-PSK-AES128-CBC-SHA256" "ECDHE-PSK-AES256-CBC-SHA" "ECDHE-PSK-AES256-CBC-SHA384" "ECDHE-PSK-CHACHA20-POLY1305" "ECDHE-RSA-AES128-GCM-SHA256" "ECDHE-RSA-AES128-SHA" "ECDHE-RSA-AES128-SHA256" "ECDHE-RSA-AES256-GCM-SHA384" "ECDHE-RSA-AES256-SHA" "ECDHE-RSA-AES256-SHA384" "ECDHE-RSA-CHACHA20-POLY1305" "PSK-AES128-CBC-SHA" "PSK-AES128-CBC-SHA256" "PSK-AES128-GCM-SHA256" "PSK-AES256-CBC-SHA" "PSK-AES256-CBC-SHA384" "PSK-AES256-GCM-SHA384" "PSK-CHACHA20-POLY1305" "RSA-PSK-AES128-CBC-SHA" "RSA-PSK-AES128-CBC-SHA256" "RSA-PSK-AES128-GCM-SHA256" "RSA-PSK-AES256-CBC-SHA" "RSA-PSK-AES256-CBC-SHA384" "RSA-PSK-AES256-GCM-SHA384" "RSA-PSK-CHACHA20-POLY1305" "SRP-AES-128-CBC-SHA" "SRP-AES-256-CBC-SHA" "SRP-RSA-AES-128-CBC-SHA" "SRP-RSA-AES-256-CBC-SHA")
if [ $fs -eq 1337 ]
then
while IFS='' read -r line || [[ -n "$line" ]]
do
	echo $line
		for t in "${tlssy[@]}"
		do
		n="0"
		while [ $n -lt 5 ]
		do
			sleep 0.05
			result=$(openssl s_client -connect $eyep\:$p -$t -cipher $line < /dev/null 2>&1)
			if [[ $? -eq 0 ]]
			then
				te=$t
				declare "state_$te"="PASS"
				n="6"
			else
				n=$[$n+1]
			if [ $n -eq 5 ]
			then
				te=$t
				declare "state_$te"="FAIL"
				n="6"
			fi
			fi
			done
		echo "$line,$state_tls1,$state_tls1_1,$state_tls1_2" >> output_$eyep":"$p.csv
		sed -i '/'$line'/d' failsafe.csv 
	done
done < "$3"
echo "Done"
else
for c in "${ciphers[@]}"
do
	echo $c >> failsafe.csv
done
	for c in "${ciphers[@]}"
	do
	echo $c
		for t in "${tlssy[@]}"
		do
		n="0"
		while [ $n -lt 5 ]
		do
			sleep 0.05
			result=$(openssl s_client -connect $eyep\:$p -$t -cipher $c < /dev/null 2>&1)
			if [[ $? -eq 0 ]]
			then
				te=$t
				declare "state_$te"="PASS"
				n="6"
			else
				n=$[$n+1]
			if [ $n -eq 5 ]
			then
				te=$t
				declare "state_$te"="FAIL"
				n="6"
			fi
			fi
			done
		done
		echo "$c,$state_tls1,$state_tls1_1,$state_tls1_2" >> output_$eyep":"$p.csv
		sed -i '/'$c'/d' failsafe.csv 
	done
echo "Done"
fi
