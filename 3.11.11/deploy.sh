#!/bin/bash

tag="v3.3.2"
project="duruo850/kafka"


build(){
    sudo docker build -t $project:$tag .
}
push(){
    sudo docker push $project:$tag
}
start() {
    echo "start..."
    sudo kubectl create -f rabbitmq.yaml
    sudo kubectl create -f rabbitmq.ui.yaml
}

stop() {
    echo "stop..."
    sudo kubectl create -f rabbitmq.ui.yaml
    sudo kubectl create -f rabbitmq.yaml
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
