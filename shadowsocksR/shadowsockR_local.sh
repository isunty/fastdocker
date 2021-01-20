#!/bin/bash

CONTAIN=SSR_LOCAL
HOST=192.168.66.127
PORT=96
PASSWORD=123456


function run()
{
    A=docker ps -a | grep ${CONTAIN}

    if [[ -z ${A} ]] ; then
        echo "开始启动ssr客户端."

	cat > local_config.json << EOF
{
    "server":"${HOST}",
    "server_port":${PORT},
    "local_address":"0.0.0.0",
    "local_port":1080,
    "password":"${PASSWORD}",
    "timeout":120,
    "method":"chacha20-ietf",
    "protocol":"auth_aes128_md5",
    "protocol_param":"",
    "obfs":"http_simple",
    "obfs_param":"",
    "fast-open":true
}
EOF

    docker run -dt --name ${CONTAIN} \
    --restart=always \
    -p 1080:1080 \
    -v `pwd`/local_config.json:/etc/shadowsocks-r/local_config.json \
    teddysun/shadowsocks-r:3.2.2 /usr/local/shadowsocks/local.py -c /etc/shadowsocks-r/local_config.json start

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
