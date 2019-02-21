#!/bin/bash

echo "" > rewrites
while read line
do
	ORIG_NAME=`echo "$line" | awk '{print $2}'`
	PROXY_NAME=`echo "$line" | awk '{print $1}'`
	PASS_NAME=`echo "$line" | awk '{print $3}'`


	echo "proxy_redirect https://"$ORIG_NAME"/ https://"$PROXY_NAME"/;" >> rewrites
	echo "proxy_redirect http://"$ORIG_NAME"/ http://"$PROXY_NAME"/;" >> rewrites
	echo "sub_filter '"$ORIG_NAME"' '"$PROXY_NAME"';" >> rewrites

done < list

while read line
do
	ORIG_NAME=`echo "$line" | awk '{print $2}'`
	PROXY_NAME=`echo "$line" | awk '{print $1}'`
	PASS_NAME=`echo "$line" | awk '{print $3}'`
	

	cat template_head > ${ORIG_NAME}.conf
	cat rewrites >> $ORIG_NAME.conf
	cat template_bottom >> $ORIG_NAME.conf

	sed -i "s/{servername-to-replace}/$PROXY_NAME/g" $ORIG_NAME.conf
	sed -i "s/{pass-host-to-replace}/$ORIG_NAME/g" $ORIG_NAME.conf
	sed -i "s/{pass-to-replace}/$PASS_NAME/g" $ORIG_NAME.conf
done < list


