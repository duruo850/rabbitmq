# Introduction



# build

    docker build -t duruo850/rabbitmq:3.11.11-management-alpine --no-cache .


# Environment variables


# Example usage: 


## Secret.yaml里面填的数据需要经过base64处理：
    
    ubuntu下base64处理： echo "rbmqu0101081710" | base64  ==> 这个base64会多个换行符, 解决方案再说
    
    可以找个网站处理一下
    
    
    
## pod起来以后可以exec -it进入查看Secret 配置的export信息：
    qiteck@server:~/program/rabbitmq/3.11.11/k8s$ sudo kubectl exec -it rabbitmq-0 -n rabbitmq -- /bin/bash
    Defaulted container "rabbitmq" out of: rabbitmq, fix-readonly-config (init)
    root@rabbitmq-0:/#
    root@rabbitmq-0:/# export
    declare -x HOME="/var/lib/rabbitmq"
    declare -x HOSTNAME="rabbitmq-0"
    declare -x KUBERNETES_PORT="tcp://10.96.0.1:443"
    declare -x KUBERNETES_PORT_443_TCP="tcp://10.96.0.1:443"
    declare -x KUBERNETES_PORT_443_TCP_ADDR="10.96.0.1"
    declare -x KUBERNETES_PORT_443_TCP_PORT="443"
    declare -x KUBERNETES_PORT_443_TCP_PROTO="tcp"
    declare -x KUBERNETES_SERVICE_HOST="10.96.0.1"
    declare -x KUBERNETES_SERVICE_PORT="443"
    declare -x KUBERNETES_SERVICE_PORT_HTTPS="443"
    declare -x LANG="C.UTF-8"
    declare -x LANGUAGE="C.UTF-8"
    declare -x LC_ALL="C.UTF-8"
    declare -x OLDPWD
    declare -x PATH="/opt/rabbitmq/sbin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
    declare -x POD_NAME="rabbitmq-0"
    declare -x POD_NAMESPACE="rabbitmq"
    declare -x PWD="/"
    declare -x RABBITMQ_DATA_DIR="/var/lib/rabbitmq"
    declare -x RABBITMQ_DEFAULT_PASS="rbmqu0101081710"
    declare -x RABBITMQ_DEFAULT_USER="system"
    declare -x RABBITMQ_ERLANG_COOKIE="123j19uedas7dad81023j139dja"
    
   