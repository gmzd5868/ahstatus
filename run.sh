#!/bin/bash

#DEBUG=1
#请把SITE改为自己的缩写，会存入influxdb，建议用学校域名缩写，如ustc, pku 等
#SITE set by docker run

[ -z ${SITE} ] && echo you must set SITE env && exit

if [ -f /my-sec-key.txt ]; then
	gpg --import /my-sec-key.txt
else
	echo you must provide /my-sec-key.txt
	exit
fi

if [ $SLEEP ] ; then
	echo SLEEP=$SLEEP
else
	SLEEP=60
fi

echo SLEEP time: $SLEEP

while true; do
[ $DEBUG ] &&	date
	bash runahstatus.sh
[ $DEBUG ] &&	echo sleep $SLEEP
	sleep $SLEEP
[ $DEBUG ] &&	echo 
done
