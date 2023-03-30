#!/usr/bin/env bash
(sleep 20; \
admin_user=mqtt_admin;\
admin_passwd=rbmqmqtt_07231816;\
rabbitmq-plugins enable --online rabbitmq_mqtt rabbitmq_web_mqtt; \
rabbitmqctl add_user $admin_user $admin_passwd; \
rabbitmqctl set_user_tags mqtt_admin administrator; \
rabbitmqctl set_permissions -p / mqtt_admin ".*" ".*" ".*"; \
rabbitmqadmin -u $admin_user -p $admin_passwd declare exchange --vhost='/' name=exchange_mqtt_topic type=topic auto_delete=false durable=true;\
) &

# Call original entrypoint
exec docker-entrypoint.sh rabbitmq-server $@
