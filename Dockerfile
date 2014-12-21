# RabbitMQ
#
# VERSION               0.0.1


FROM      ubuntu:14.04
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

# Install Ruby for New Relic Rabbit MQ Plugin
# Download the New Relic Plugin
# Update last JSON version
RUN apt-get -qq update > /dev/null && \
    apt-get -qq -y install ruby-full > /dev/null && \
    apt-get -qq -y install wget > /dev/null && \
    wget https://github.com/gopivotal/newrelic_pivotal_agent/archive/pivotal_agent-1.0.5.tar.gz && \
    tar -zxvf pivotal_agent-1.0.5.tar.gz && \
    gem install bundler && \
    apt-get -qq -y install make > /dev/null && \
    gem install json -v '1.8.1' && \
    cd newrelic_pivotal_agent-pivotal_agent-1.0.5 && \
    bundle install
# Configure plugin
ADD newrelic_plugin.yml /newrelic_pivotal_agent-pivotal_agent-1.0.5/config/newrelic_plugin.yml
ADD run_rabbit_and_monitor.sh /run_rabbit_and_monitor.sh
RUN chmod 755 /run_rabbit_and_monitor.sh
# RUN BOTH Rabbit and monitor
CMD /run_rabbit_and_monitor.sh
#CMD /usr/sbin/rabbitmq-server && /newrelic_pivotal_agent-pivotal_agent-1.0.5/pivotal_agent 
#CMD /usr/sbin/rabbitmq-server 

#  ./newrelic_pivotal_agent-pivotal_agent-1.0.5/pivotal_agent
