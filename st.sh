#!/bin/sh
cp /root/tmal-hrk-2/index.html /workspace/index.html
ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime
echo "Asia/Shanghai" > /etc/timezone
sed -i "s/REBOOTDATE/$(date)/g" /workspace/index.html
/usr/bin/supervisord -c /etc/supervisord.conf &
service nginx start
