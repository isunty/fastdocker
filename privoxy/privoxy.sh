#!/bin/bash

CONTAIN=privoxy
PORT=8118
SSR_CONTAIN=SSR_LOCAL
SSR_PORT=1080


function run()
{
    A=docker ps -a | grep ${CONTAIN}

    if [[ -z ${A} ]] ; then
        echo "开始启动http代理客户端."

	cat > config << EOF
listen-address  0.0.0.0:${PORT}
forward-socks5 / SSR_LOCAL:${SSR_PORT} .
EOF

        docker run -d --name ${CONTAIN} \
        --restart=always \
        -p ${PORT}:${PORT} \
        -v `pwd`/config:/etc/privoxy/config \
        --link ${SSR_CONTAIN} \
        splazit/privoxy-alpine:latest --no-daemon --user privoxy /etc/privoxy/config
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
