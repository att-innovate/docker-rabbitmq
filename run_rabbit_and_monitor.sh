#!/bin/bash
sed -i -e "s/{{LICENSE_KEY}}/$LICENSE_KEY/g" /newrelic_pivotal_agent-pivotal_agent-1.0.5/config/newrelic_plugin.yml
echo "Set the Rabbit MQ New Relic License key ?$"

sed -i -e "s/{{RABBIT_MQ_SERVER_NAME}}/$RABBIT_MQ_SERVER_NAME/g" /newrelic_pivotal_agent-pivotal_agent-1.0.5/config/newrelic_plugin.yml
echo "Set the Rabbit MQ New Relic Server Name ?$"

cp /etc/hosts /etc/hosts_2
sed -i -e "s/127.0.0.1\slocalhost/127.0.0.1	localhost	$RABBIT_MQ_SERVER_NAME/g"  /etc/hosts_2
cp /etc/hosts_2 /etc/hosts
echo "Set the Rabbit MQ New Relic Server Name for hosts file?$"

/usr/sbin/rabbitmq-server >/dev/null 2>&1 &
if [ $? -eq 0 ] ; then 
	/newrelic_pivotal_agent-pivotal_agent-1.0.5/pivotal_agent > /var/log/newrelic_rabbitmq.log 2>&1 &
	tail -F /var/log/newrelic_rabbitmq.log 
fi
