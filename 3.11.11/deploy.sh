#!/bin/bash

build(){
    sudo docker build -t duruo850/rabbitmq:3.11.11-management-alpine --no-cache image/
}
push(){
    sudo docker push $project:$tag
}
start() {
    echo "start..."
    sudo kubectl create -f namespace.yaml
    sudo kubectl create -f rabbitmq.yaml
    sudo kubectl create -f rabbitmq.ui.yaml
}

stop() {
    echo "stop..."
    sudo kubectl delete -f rabbitmq.ui.yaml
    sudo kubectl delete -f rabbitmq.yaml
    sudo kubectl delete -f namespace.yaml
    sudo rm -rf /opt/kafka_data*
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
