#!/bin/bash

CONTAIN=mqtt

function run()
{
    A=docker ps -a | grep ${CONTAIN}

    if [[ -z ${A} ]] ; then
        echo "开始启动."
        docker run --name mqtt -d \
        --restart always \
        -p 1883:1883 -p 9001:9001 \
        -v `pwd`/mqtt_start.sh:/mqtt_start.sh \
        -v /usr/share/zoneinfo/Asia/Shanghai:/etc/localtime \
        eclipse-mosquitto:2.0.4 /mqtt_start.sh
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
