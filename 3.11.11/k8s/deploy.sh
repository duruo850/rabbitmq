#!/bin/bash

build(){
    sudo docker build -t duruo850/rabbitmq:3.11.11-management-alpine --no-cache image/
}
push(){
    sudo docker push $project:$tag
}
start() {
    echo "start..."
    sudo kubectl create -f Namespace.yaml
    sudo kubectl create -f LimitRange.yaml
    sudo kubectl create -f PersistentVolume.yaml
    sudo kubectl create -f Rbac.yaml
    sudo kubectl create -f Secret.yaml
    sudo kubectl create -f Config.yaml
    sudo kubectl create -f Statefulset.yaml
    sudo kubectl create -f Service.yaml
}

stop() {
    echo "stop..."
    sudo kubectl delete -f Service.yaml
    sudo kubectl delete -f LimitRange.yaml
    sudo kubectl delete -f Statefulset.yaml

    # pvc需要手动删除
    # 1.23以后可以通过persistentVolumeClaimRetentionPolicy控制
    sudo kubectl delete pvc rabbitmq-data-rabbitmq-0 rabbitmq-data-rabbitmq-1 rabbitmq-data-rabbitmq-2 -n rabbitmq

    sudo kubectl delete -f Config.yaml
    sudo kubectl delete -f Secret.yaml
    sudo kubectl delete -f Rbac.yaml
    sudo kubectl delete -f PersistentVolume.yaml
    sudo rm -rf /opt/rabbitmq_data*
}

clear() {
    echo "clear..."
    stop
    sudo docker system prune -a -f
}

restart() {
    stop
    start
}

cmd=$1
case $cmd in
build)
        build
;;
push)
        push
;;
start)
        start
;;
stop)
        stop
;;
clear)
        clear
;;
restart)
        restart
;;
esac
exit 0
