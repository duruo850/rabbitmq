# Introduction



# build

    docker build -t duruo850/rabbitmq:3.11.11-management-alpine --no-cache .


# Environment variables


# Example usage: 


## Secret.yaml里面填的数据需要经过base64处理：
    
    ubuntu下base64处理： echo "rbmqu0101081710" | base64  ==> 这个base64会多个换行符, 解决方案再说
    
    可以找个网站处理一下
    
    
## 集群配置说明：

    参考文档：https://www.rabbitmq.com/cluster-formation.html

      cluster_formation.peer_discovery_backend  = k8s
      cluster_formation.k8s.service_name = rabbitmq-internal
      cluster_formation.k8s.hostname_suffix = .rabbitmq-internal.rabbitmq.svc.cluster.local
      cluster_formation.k8s.address_type = hostname
      
      
      
      cluster_formation.k8s.address_type：从k8s返回的Pod容器列表中计算对等节点列表，这里只能使用主机名，官方示例中是ip，
      但是默认情况下在k8s中pod的ip都是不固定的，因此可能导致节点的配置和数据丢失，后面的yaml中会通过引用元数据的方式固定pod的主机名。
    
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
    

## 集群验证：
    rabbitmqctl cluster_status 
   