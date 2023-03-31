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
      
## 集群重启说明：
    
    集群重启以后，需要把pv的数据删除，不然会出现问题
    sudo rm -rf /opt/rabbitmq_data*
    
## MQTT配置支持：

    qiteck@server:~/program/rabbitmq/3.11.11/k8s$ sudo kubectl exec -it rabbitmq-0 -n rabbitmq -- /bin/bash
    
    mqtt服务已经添加，但是mqtt用户需要手动添加
    admin_user=mqtt_admin
    admin_passwd=rbmqmqtt_07231816
    rabbitmqctl add_user $admin_user $admin_passwd
    rabbitmqctl set_user_tags mqtt_admin administrator
    rabbitmqctl set_permissions -p / mqtt_admin ".*" ".*" ".*"
    
    // 这个不支持，后面看下怎么弄
    rabbitmqadmin -u $admin_user -p $admin_passwd declare exchange --vhost='/' name=exchange_mqtt_topic type=topic auto_delete=false durable=true;
  
    
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

### 集群验证-rabbitmqctl cluster_status：
    root@rabbitmq-0:/# rabbitmqctl cluster_status
    Cluster status of node rabbit@rabbitmq-0.rabbitmq-internal.rabbitmq.svc.cluster.local ...
    Basics
    
    Cluster name: rabbit@rabbitmq-0.rabbitmq-internal.rabbitmq.svc.cluster.local
    Total CPU cores available cluster-wide: 6
    
    Disk Nodes
    
    rabbit@rabbitmq-0.rabbitmq-internal.rabbitmq.svc.cluster.local
    rabbit@rabbitmq-1.rabbitmq-internal.rabbitmq.svc.cluster.local
    rabbit@rabbitmq-2.rabbitmq-internal.rabbitmq.svc.cluster.local
    
    Running Nodes
    
    rabbit@rabbitmq-0.rabbitmq-internal.rabbitmq.svc.cluster.local
    rabbit@rabbitmq-1.rabbitmq-internal.rabbitmq.svc.cluster.local
    rabbit@rabbitmq-2.rabbitmq-internal.rabbitmq.svc.cluster.local
    
    Versions
    
    rabbit@rabbitmq-0.rabbitmq-internal.rabbitmq.svc.cluster.local: RabbitMQ 3.11.11 on Erlang 25.3
    rabbit@rabbitmq-1.rabbitmq-internal.rabbitmq.svc.cluster.local: RabbitMQ 3.11.11 on Erlang 25.3
    rabbit@rabbitmq-2.rabbitmq-internal.rabbitmq.svc.cluster.local: RabbitMQ 3.11.11 on Erlang 25.3
    
    CPU Cores
    
    Node: rabbit@rabbitmq-0.rabbitmq-internal.rabbitmq.svc.cluster.local, available CPU cores: 2
    Node: rabbit@rabbitmq-1.rabbitmq-internal.rabbitmq.svc.cluster.local, available CPU cores: 2
    Node: rabbit@rabbitmq-2.rabbitmq-internal.rabbitmq.svc.cluster.local, available CPU cores: 2
    
    Maintenance status
    
    Node: rabbit@rabbitmq-0.rabbitmq-internal.rabbitmq.svc.cluster.local, status: not under maintenance
    Node: rabbit@rabbitmq-1.rabbitmq-internal.rabbitmq.svc.cluster.local, status: not under maintenance
    Node: rabbit@rabbitmq-2.rabbitmq-internal.rabbitmq.svc.cluster.local, status: not under maintenance


### 集群验证--日志/var/log/rabbitmq/rabbit\@rabbitmq-0.rabbitmq-internal.rabbitmq.svc.cluster.local.log
    tail -f /var/log/rabbitmq/rabbit\@rabbitmq-0.rabbitmq-internal.rabbitmq.svc.cluster.local.log:
    
    Feature flags
    
    Flag: classic_mirrored_queue_version, state: enabled
    Flag: classic_queue_type_delivery_support, state: enabled
    Flag: direct_exchange_routing_v2, state: enabled
    Flag: drop_unroutable_metric, state: enabled
    Flag: empty_basic_get_metric, state: enabled
    Flag: feature_flags_v2, state: enabled
    Flag: implicit_default_bindings, state: enabled
    Flag: listener_records_in_ets, state: enabled
    Flag: maintenance_mode_status, state: enabled
    Flag: quorum_queue, state: enabled
    Flag: stream_queue, state: enabled
    Flag: stream_single_active_consumer, state: enabled
    Flag: tracking_records_in_ets, state: enabled
    Flag: user_limits, state: enabled
    Flag: virtual_host_metadata, state: enabled
    root@rabbitmq-0:/# tail -f /var/log/rabbitmq/rabbit\@rabbitmq-0.rabbitmq-internal.rabbitmq.svc.cluster.local.log
    2023-03-31 08:33:03.820636+00:00 [info] <0.724.0> Server startup complete; 5 plugins started.
    2023-03-31 08:33:03.820636+00:00 [info] <0.724.0>  * rabbitmq_peer_discovery_k8s
    2023-03-31 08:33:03.820636+00:00 [info] <0.724.0>  * rabbitmq_peer_discovery_common
    2023-03-31 08:33:03.820636+00:00 [info] <0.724.0>  * rabbitmq_management
    2023-03-31 08:33:03.820636+00:00 [info] <0.724.0>  * rabbitmq_web_dispatch
    2023-03-31 08:33:03.820636+00:00 [info] <0.724.0>  * rabbitmq_management_agent
    2023-03-31 08:34:03.957323+00:00 [info] <0.638.0> node 'rabbit@rabbitmq-1.rabbitmq-internal.rabbitmq.svc.cluster.local' up
    2023-03-31 08:34:07.136896+00:00 [info] <0.638.0> rabbit on node 'rabbit@rabbitmq-1.rabbitmq-internal.rabbitmq.svc.cluster.local' up
    2023-03-31 08:35:07.762592+00:00 [info] <0.638.0> node 'rabbit@rabbitmq-2.rabbitmq-internal.rabbitmq.svc.cluster.local' up
    2023-03-31 08:35:10.314678+00:00 [info] <0.638.0> rabbit on node 'rabbit@rabbitmq-2.rabbitmq-internal.rabbitmq.svc.cluster.local' up
   