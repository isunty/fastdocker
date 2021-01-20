#!/bin/bash

CONTAIN=SSR
PASSWORD=123456

function run()
{
    A=docker ps -a | grep ${CONTAIN}

    if [[ -z ${A} ]] ; then
        echo "开始启动."

        cat > config.json << EOF
{
    "server":"0.0.0.0",
    "server_port":9000,
    "local_address":"127.0.0.1",
    "local_port":1080,
    "password":"${PASSWORD}",
    "timeout":120,
    "method":"chacha20-ietf",
    "protocol":"auth_aes128_md5",
    "protocol_param":"",
    "obfs":"http_simple",
    "obfs_param":"",
    "redirect":"",
    "dns_ipv6":false,
    "fast_open":true,
    "workers":1
}
EOF

        docker run --name ${CONTAIN} -d \
        --restart always \
        -p 96:9000 -p 96:9000/udp \
        -v `pwd`/config.json:/etc/shadowsocks-r/config.json \
        teddysun/shadowsocks-r:3.2.2 /usr/local/shadowsocks/server.py -c /etc/shadowsocks-r/config.json
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
