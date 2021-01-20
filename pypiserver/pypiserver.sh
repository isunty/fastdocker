#!/bin/bash

CONTAIN=pypiserver

function run()
{
    A=docker ps -a | grep ${CONTAIN}

    if [[ -z ${A} ]] ; then
        echo "开始启动."

        echo -e "fido:{SHA}fEqNCco3Yq9h5ZUglD3CZJT4lBs=\n" > htpasswd
        echo "默认用户: fido:123456"
        echo "将需要的包cp到: /data/packages即可
        EX: docker cp uvloop-0.14.0-cp37-cp37m-manylinux2010_x86_64.whl pypiserver:/data/packages
        生成htp密码: https://hostingcanada.org/htpasswd-generator/"

        docker run -dt --name ${CONTAIN} \
        --restart always \
        -v /usr/share/zoneinfo/Asia/Shanghai:/etc/localtime \
        -v `pwd`/htpasswd:/data/packages/.htpasswd \
        -p 8080:8080 \
        pypiserver/pypiserver:v1.4.2 -P /data/packages/.htpasswd packages
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
