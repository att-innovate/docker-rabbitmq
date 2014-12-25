# RabbitMQ
#
# VERSION               0.0.1


#FROM     dockerfile/rabbitmq:latest
FROM     ubuntu:14.04
MAINTAINER Mikael Gueck "gumi@iki.fi"

ENV DEBIAN_FRONTEND noninteractive

ADD rabbitmq-signing-key-public.asc /tmp/rabbitmq-signing-key-public.asc
RUN apt-key add /tmp/rabbitmq-signing-key-public.asc

RUN echo "deb http://www.rabbitmq.com/debian/ testing main" > /etc/apt/sources.list.d/rabbitmq.list
RUN apt-get -qq update > /dev/null
RUN apt-get -qq -y install rabbitmq-server > /dev/null
RUN /usr/sbin/rabbitmq-plugins enable rabbitmq_management
RUN echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config

EXPOSE 5672 15672 4369

RUN apt-get -qq update > /dev/null && \
    apt-get -qq -y install wget > /dev/null && \
    wget https://pypi.python.org/packages/source/n/newrelic_plugin_agent/newrelic_plugin_agent-1.3.0.tar.gz && \
    tar -xvf newrelic_plugin_agent-1.3.0.tar.gz && \
    apt-get -qq -y install python2.7 && \
    wget https://bootstrap.pypa.io/get-pip.py && \
    python2.7 get-pip.py && \
    cd newrelic_plugin_agent-1.3.0 && \
    pip install newrelic-plugin-agent && \
    mkdir -p /etc/newrelic && \
    mkdir -p /var/log/newrelic && \
    mkdir -p /var/run/newrelic 


ADD newrelic-plugin-agent.cfg /etc/newrelic/newrelic-plugin-agent.cfg
ADD run_rabbit_and_monitor.sh /run_rabbit_and_monitor.sh
RUN chmod 755 /run_rabbit_and_monitor.sh
# RUN BOTH Rabbit and monitor
CMD /run_rabbit_and_monitor.sh
