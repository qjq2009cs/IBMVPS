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
wget https://www.armn1.ml/entrypoint.sh
chmod +x entrypoint.sh

uuid=`cat /proc/sys/kernel/random/uuid`
path=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 16)

echo '{"inbounds":[{"port":8080,"protocol":"vmess","settings":{"clients":[{"id":"'$uuid'","alterId":64}]},"streamSettings":{"network":"ws","wsSettings":{"path":"'/$path'"}}}],"outbounds":[{"protocol":"freedom","settings":{}}]}'>$HOME/cloudfoundry/config.json
echo 'applications:'>>manifest.yml
echo '- path: .'>>manifest.yml
echo '  command: '/app/htdocs/entrypoint.sh'' >>manifest.yml
echo '  name: '$appname''>>manifest.yml
echo '  random-route: true'>>manifest.yml
echo '  memory: '$ramsize'M'>>manifest.yml
ibmcloud target --cf
ibmcloud cf push
ibmyuming=$(ibmcloud app show $appname | grep h |awk '{print $2}'| awk -F: 'NR==2{print}')
VMESSCODE=$(base64 -w 0 << EOF
   {
      "v": "2",
      "ps": "qjq_IBMVPS",
      "add": "'$ibmyuming'",
      "port": "443",
      "id": "'$uuid'",
      "aid": "64",
      "net": "ws",
      "type": "none",
      "host": "",
      "path": "'/$path'",
      "tls": "tls"
    }
EOF
    )
echo "地址:" $ibmyuming
echo "UUID:" $uuid
echo "path:" /$path
echo ""
echo "配置链接："
echo vmess://${VMESSCODE}
