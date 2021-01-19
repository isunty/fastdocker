#!/bin/bash

CONTAIN=postgresql

function run()
{
    A=docker ps -a | grep ${CONTAIN}

    if [[ -z ${A} ]] ; then
        echo "开始启动."
        docker run -d --name ${CONTAIN} \
        --restart always \
        --user postgres \
        -v /usr/share/zoneinfo/Asia/Shanghai:/etc/localtime \
        -p 5432:5432 \
        -e POSTGRES_USER=postgres \
        -e POSTGRES_PASSWORD=bB9v7j9xv77## \
        -e POSTGRES_DB=fidodb \
        postgres:10.15-alpine
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
