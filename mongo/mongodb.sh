#!/bin/bash

CONTAIN=mongodb
PASSWORD=123456

function run()
{
    A=docker ps -a | grep ${CONTAIN}

    if [[ -z ${A} ]] ; then
        echo "开始启动."
        echo "默认加密方式是: SCRAM-SHA-256"
        docker run -d --name ${CONTAIN} \
        --restart always \
        --user mongodb \
        -p 27017:27017 \
        -e MONGO_INITDB_ROOT_USERNAME=root \
        -e MONGO_INITDB_ROOT_PASSWORD=${PASSWORD} \
        mongo:4.2.11-bionic mongod
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
