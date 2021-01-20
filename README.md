# README

这个项目是一个快速的docker启动项目，用于一个脚本直接启动一个快速使用的服务。
例如，数据库，nginx等



目前支持直接启动包括：

1. mqtt - 消息队列
2. mysql - 数据库
3. postgresql - 数据库
4. redis - 数据库
5. mongodb - 数据库
6. nginx - http服务器
7. pyiserver - python仓库
8. registry - docker仓库
9. shadowsocksR - SSR代理



## 基本使用

每一个脚本都可以接收一个参数，包括

```sh
run    # 启动容器
stop   # 停止容器
ps     # 查询容器
```

