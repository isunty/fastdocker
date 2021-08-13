### 配置以下内容

```sh
gitlab_rails['gitlab_shell_ssh_port'] = 22     # 修改默认的的ssh端口，注意容器的端口映射


# 使用自签证书，设置后，只能通过8443端口访问
external_url 'https://192.168.66.139:8443'     # 大约在32行
nginx['redirect_http_to_https'] = true         # 打开http重定向到https，必须使用https
letsencrypt['enable'] = false                  # 关闭在线验证证书
nginx['ssl_certificate'] = "/etc/gitlab/nginx.pem"       # 设置公钥证书
nginx['ssl_certificate_key'] = "/etc/gitlab/nginx.key"   # 设置私钥证书

# 在git使用时请关闭ssl的自签证书验证，否则会出现 remote: HTTP Basic: Access denied
git config --global http.sslVerify "false"
```
