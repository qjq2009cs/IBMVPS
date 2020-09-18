#!/bin/sh
read -p "请输入应用程序名称:" appname
read -p "请设置你的容器内存大小(默认256):" ramsize
if [ -z "$ramsize" ];then
	ramsize=256
fi
rm -rf phpcf
mkdir phpcf
cd phpcf
echo '<!DOCTYPE html> '>>index.php
echo '<html> '>>index.php
echo '<body>'>>index.php
echo '<?php '>>index.php
echo 'echo "Hello World!"; '>>index.php
echo '?> '>>index.php
echo '<body>'>>index.php
echo '</html>'>>index.php

wget https://github.com/v2ray/v2ray-core/releases/latest/download/v2ray-linux-64.zip
unzip -d v2ray1 v2ray-linux-64.zip
cd v2ray1
chmod 777 *
cd ..
rm -rf v2ray-linux-64.zip
mv $HOME/cloudfoundry/v2ray1/v2ray $HOME/cloudfoundry/v2ray
mv $HOME/cloudfoundry/v2ray1/v2ctl $HOME/cloudfoundry/v2ctl
rm -rf $HOME/cloudfoundry/v2ray1
uuid=`cat /proc/sys/kernel/random/uuid`
path=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 16)

wget https://www.armn1.ml/entrypoint.sh
chmod +x entrypoint.sh
echo 'applications:'>>manifest.yml
echo '- path: .'>>manifest.yml
echo '  command: '/app/htdocs/entrypoint.sh'' >>manifest.yml
echo '  name: '$appname''>>manifest.yml
echo '  random-route: true'>>manifest.yml
echo '  memory: '$ramsize'M'>>manifest.yml
ibmcloud target --cf
ibmcloud cf push
ibmyuming=$(ibmcloud app show $appname | grep h |awk '{print $2}'| awk -F: 'NR==2{print}')
vmess=`echo '{"add":"'$ibmyuming'","aid":"64","host":"","id":"'$uuid'","net":"ws","path":"/'$path'","port":"443","ps":"qjq_IBMVPS","tls":"tls","type":"none","v":"2"}' | base64 -w 0`
cd ..
    echo "Telegram：@bigfangfang"
    echo "Telegram Group：https://t.me/dafangbigfang"
    echo "Telegram Channal：https://t.me/dafangbigfangC"
    echo ""
    echo "YouTube IBMVPS教程：https://bit.ly/3ibq1JI"
    echo "Thanks @CCChieh @不愿透露神秘大佬"
    echo ""
echo 配置信息
echo 地址: $ibmyuming
echo UUID: $uuid
echo path: /$path
echo ""
echo 配置成功
echo vmess://$vmess
