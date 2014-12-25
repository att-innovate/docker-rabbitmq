#!/bin/bash
sed -i -e "s/{{LICENSE_KEY}}/$LICENSE_KEY/g" /etc/newrelic/newrelic-plugin-agent.cfg
echo "Set the Rabbit MQ New Relic License key $?"

sed -i -e "s/{{APP_NAME}}/$APP_NAME/g" /etc/newrelic/newrelic-plugin-agent.cfg 
echo "Set the Rabbit MQ New Relic Server Name $?"

/usr/sbin/rabbitmq-server > /dev/null 2>&1 & 
if [ $? -eq 0 ] ; then 
	/usr/local/bin/newrelic-plugin-agent -c /etc/newrelic/newrelic-plugin-agent.cfg -f 
	echo "Start Rabbit MQ Monitoring status $? Logs under /var/log/newrelic/newrelic-plugin-agent.log"	
fi
