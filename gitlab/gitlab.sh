#!/bin/bash

CONTAIN=gitlab

function run()
{
    A=docker ps -a | grep ${CONTAIN}

    if [[ -z ${A} ]] ; then
        echo "开始启动."
        CONFIGPATH=$HOME/gitlab/config   # 配置文件路径
        if [ ! -d "$CONFIGPATH" ]; then
            mkdir -p $HOME/gitlab/logs $HOME/gitlab/data $CONFIGPATH
            sudo openssl req -new -x509 -days 36500 -nodes -out $CONFIGPATH/nginx.pem \
                 -keyout $CONFIGPATH/nginx.key -subj "/C=US/CN=gitlab/O=gitlab.com"
        fi

        docker run -itd --name ${CONTAIN} \
        --restart always \
        -p 8443:8443 -p 2222:22 \
        -v $HOME/gitlab/logs:/var/log/gitlab \
        -v $HOME/gitlab/data:/var/opt/gitlab \
        -v $HOME/gitlab/config:/etc/gitlab \
        gitlab/gitlab-ce:13.12.10-ce.0
        echo -e "启动完成，请修改你自定义配置 \n\
        docker exec -it gitlab vim /etc/gitlab/gitlab.rb \n\
        docker restart gitlab \n\
        "

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
