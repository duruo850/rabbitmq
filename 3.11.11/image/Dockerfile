FROM rabbitmq:3.11.11-management-alpine

MAINTAINER Zhan ChenJin


COPY ./rabbitmq.conf /etc/rabbitmq/
COPY wrapper-entrypoint.sh /

# 开启插件 + 设置mqtt登录用户和权限
RUN chmod a+x /wrapper-entrypoint.sh

EXPOSE 1883 8883 15675

ENTRYPOINT ["/wrapper-entrypoint.sh"]