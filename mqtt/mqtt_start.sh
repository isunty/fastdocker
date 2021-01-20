#!/bin/sh

USER=fido
PASSWORD=123456

cat > /mosquitto/config/mosquitto.conf << EOF
user mosquitto
listener 1883
protocol mqtt
listener 9001
protocol websockets
persistence true
persistence_location /mosquitto/data
allow_anonymous false
password_file /mosquitto/config/passwd
acl_file /mosquitto/config/acl
EOF
echo "完成更新配置文件"

cat > /mosquitto/config/acl << EOF
user ${USER}
topic readwrite #
EOF
echo "完成更新权限"


mosquitto_passwd -c -b /mosquitto/config/passwd ${USER} ${PASSWORD}
echo "完成创建用户"

echo "启动mqtt"
/usr/sbin/mosquitto -c /mosquitto/config/mosquitto.conf -v
