#!/bin/bash

CONTAIN=SS_LOCAL
HOST=141.164.62.30
PORT=26
PASSWORD=Ro7J9C6QT7RUXHCqI5Hf6E4Et


function run()
{
    A=docker ps -a | grep ${CONTAIN}

    if [[ -z ${A} ]] ; then
        echo "开始启动ssr客户端."

	cat > local_config.json << EOF
{
    "mode": "tcp_and_udp",
    "server":"${HOST}",
    "server_port":${PORT},
    "local_address": "0.0.0.0",
    "local_port":1080,
    "password":"${PASSWORD}",
    "timeout":15,
    "method":"aes-256-gcm",
    "fast-open":true
}
EOF

    docker run -dt --name ${CONTAIN} \
    --restart=always \
    --network host \
    -v `pwd`/local_config.json:/etc/local_config.json \
    shadowsocks/shadowsocks-libev:v3.2.5 ss-local -c /etc/local_config.json -u -v

    else
        echo "容器已经存在,退出"
    fi
}


function ps()
{
    echo "当前运行容器"
    docker ps -a | grep ${CONTAIN}
}


function stop()
{
    echo "停止当前容器"
    docker rm -f ${CONTAIN}
}

case $1 in
    -h) echo "run启动, stop停止, ps查看";;
    ps) ps;;
    run) run;;
    stop) stop;;
    *) echo "error: no such option $1.-h for help";;
esac
