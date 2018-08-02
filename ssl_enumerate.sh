#!/bin/bash
#JYC
#
#
#
#

#Prints Target IP
echo Target IP: $1

#Makes Outputfile and formats
echo "PORT,TLS1,TLS1_1,TLS1_2,DTLS1,DTLS1_2" >> Output_$1.csv

#i="80"
i="1"
while [ $i -lt 65535]
do
#TLS1 Test
n="0"
while [ $n -lt 5]
do
result=$(openssl s_client -connect $1 -tls1 < /dev/null 2>&1)
if [[ $? -eq 0 ]];then
TLS1_state="PASS"
n="5"
else
TLS1_state="FAIL"
n=$[$n+1]
fi
done
#TLS1_1 Test
n="0"
while [ $n -lt 5]
do
result=$(openssl s_client -connect $1 -tls1_1 < /dev/null 2>&1)
if [ $? -eq 0 ];then
TLS1_1_state="PASS"
n="5"
else
TLS1_1_state="FAIL"
n=$[$n+1]
fi
#TLS1_2 Test
n="0"
while [ $n -lt 5]
do
result=$(openssl s_client -connect $1 -tls1_2 < /dev/null 2>&1)
if [ $? -eq 0 ];then
TLS1_2_state="PASS"
n="5"
else
TLS1_2_state="FAIL"
n=$[$n+1]
fi
#DTLS1 Test
n="0"
while [ $n -lt 5]
do
result=$(openssl s_client -connect $1 -dtls1 < /dev/null 2>&1)
if [[ $? -eq 0 ]];then
DTLS1_state="PASS"
n="5"
else
DTLS1_state="FAIL"
n=$[$n+1]
fi
#DTLS1_2 Test
n="0"
while [ $n -lt 5]
do
result=$(openssl s_client -connect $1 -dtls1_2 < /dev/null 2>&1)
if [[ $? -eq 0 ]];then
DTLS1_2_state="PASS"
n="5"
else
DTLS1_2_state="FAIL"
n=$[$n+1]
fi
#Check if any passed to print
if [ "$TLS1_state" -eq "PASS"] || [ "$TLS1_1_state" -eq "PASS"] || [ "$TLS1_2_state" -eq "PASS"] || [ "$DTLS1_state" -eq "PASS"] || [ "$DTLS1_2_state" -eq "PASS"] ||;then
echo "$i,$TLS1_state,$TLS1_1_state,$TLS1_2_state" >> Output_$1.csv
fi
i=$[$i+1]
done
echo "Done"

