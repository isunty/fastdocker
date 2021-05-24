#!/bin/bash

CONTAIN=SS
PASSWORD=Ro7J9C6QT7RUXHCqI5Hf6E4Et

function run()
{
    A=docker ps -a | grep ${CONTAIN}

    if [[ -z ${A} ]] ; then
        echo "开始启动."

        cat > config.json << EOF
{
  "server": "0.0.0.0",
  "mode": "tcp_and_udp",
  "port_password": {
    "26": "${PASSWORD}",
    "27": "${PASSWORD}",
    "28": "${PASSWORD}"
  },
  "method": "aes-256-gcm",
  "timeout": 100,
  "fast_open": true
}

EOF

        docker run --name ${CONTAIN} -d \
        --restart always \
        --network host \
        --user root \
        -v `pwd`/config.json:/etc/ssconfig.json \
        shadowsocks/shadowsocks-libev:v3.2.5 ss-manager --manager-address /tmp/manager.sock --executable ss-server -c /etc/ssconfig.json -vv
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
