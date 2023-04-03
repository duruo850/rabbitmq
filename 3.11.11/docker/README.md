# Introduction

rabbitmq 3.11.11  支持mqtt转amqp协议

容器启动的时候默认创建一个topic：exchange_mqtt_topic，type=topic auto_delete=false durable=true

rabbitmq管理员帐号密码：aaaaaa 111111

rabbitmq mqtt管理员帐号密码： bbbbbb 111111

默认允许匿名登录

# build

    docker build -t duruo850/rabbitmq:3.11.11-management-alpine --no-cache .


# Environment variables


# Example usage: 

## Common

    # 简单启动rabbitmq，用户密码为aaaaa:111111, 虚拟地址为/
    docker run -d --name rabbitmq --restart=always -p 1883:1883 -p 5672:5672 -p 15672:15672 -p 15675:15675 duruo850/rabbitmq:3.11.11-management-alpine
   