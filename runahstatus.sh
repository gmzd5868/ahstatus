#!/bin/bash
# DEBUG=1

[ $DEBUG ] && echo SITE: $SITE

[ -z ${SITE} ] && echo you must set SITE env && exit

grep -v ^# urls1.txt | while read hostname url; do 

[ $DEBUG ] && echo hostname: $hostname
[ $DEBUG ] && echo url: $url

rm -f $$.tmp $$.tmp.gpg
./httptest/httptest -w 2 -i www,site=${SITE},host=${hostname} ${url} > $$.tmp
[ $DEBUG ] && echo -n result:
[ $DEBUG ] && cat $$.tmp

gpg --sign $$.tmp

if [ $DEBUG ]; then
	curl -F "debug=1" -F "report=@$$.tmp.gpg" "http://222.195.81.227/ahstatus/report.php?site=${SITE}" 2>/dev/null
else
	curl -F "report=@$$.tmp.gpg" "http://222.195.81.227/ahstatus/report.php?site=${SITE}" >/dev/null 2>/dev/null
fi

rm -f $$.tmp $$.tmp.gpg

done
