#!/bin/bash

CONTAIN=mysql

function run()
{
    A=docker ps -a | grep ${CONTAIN}

    if [[ -z ${A} ]] ; then
        echo "开始启动."
        docker run -dt --name mysql \
        --restart always \
        --user mysql \
        -e TZ=Asia/Shanghai \
        -e MYSQL_ROOT_PASSWORD='bB9v7j9xv77##' \
        -e MYSQL_USER=fido \
        -e MYSQL_PASSWORD="fido1231" \
        -e MYSQL_DATABASE="fidodb" \
        -p 3306:3306 \
        mysql:5.7 --defaults-file=/etc/mysql/mysql.conf.d/mysqld.cnf --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
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
