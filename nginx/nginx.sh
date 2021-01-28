#!/bin/bash

CONTAIN=nginx

function run()
{
    A=docker ps -a | grep ${CONTAIN}

    if [[ -z ${A} ]] ; then
        echo "开始启动."
        sudo chown 101:101 `pwd`/cert/*
        docker run -d --name ${CONTAIN} \
        --restart always \
        -v /usr/share/zoneinfo/Asia/Shanghai:/etc/localtime \
        -v `pwd`/cert:/usr/local/nginx/conf/cert \
        -v `pwd`/default.conf:/etc/nginx/conf.d/default.conf \
        -v `pwd`/web:/usr/share/nginx/html:ro \
        -p 80:80 -p 443:443 \
        nginx:1.18.0-alpine nginx -g "daemon off;"
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
