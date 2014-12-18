# RabbitMQ
#
# VERSION               0.0.1

FROM      ubuntu:14.04
MAINTAINER Chen Fliesher "cfliesher@interwise.com"

ENV DEBIAN_FRONTEND noninteractive

ADD rabbitmq-signing-key-public.asc /tmp/rabbitmq-signing-key-public.asc
RUN apt-key add /tmp/rabbitmq-signing-key-public.asc

RUN echo "deb http://www.rabbitmq.com/debian/ testing main" > /etc/apt/sources.list.d/rabbitmq.list
RUN apt-get -qq update > /dev/null
RUN apt-get -qq -y install rabbitmq-server > /dev/null
# UPDATE the apt-get otherwise ruby installation fails
RUN apt-get -qq update > /dev/nul 
# Install Ruby for New Relic Rabbit MQ Plugin
RUN apt-get -qq -y install ruby-full > /dev/null
# Install WGET for download 
RUN apt-get -qq -y install wget > /dev/null
# Download the New Relic Plugin
RUN wget https://github.com/gopivotal/newrelic_pivotal_agent/archive/pivotal_agent-1.0.5.tar.gz 
# UNTAR
RUN tar -zxvf pivotal_agent-1.0.5.tar.gz
# Add bundler Gem to run the Plugin
RUN gem install bundler
# For update JSON to version 1.8.1
RUN apt-get -qq -y install make > /dev/null
# Update last JSON version
RUN gem install json -v '1.8.1' 
# Change Directory to install the plugin GEM 
RUN cd newrelic_pivotal_agent-pivotal_agent-1.0.5
# Install the plugin GEM
RUN bundle install
# Configure plugin
ADD newrelic_plugin.yml /newrelic_pivotal_agent-pivotal_agent-1.0.5/config/newrelic_plugin.yml

RUN /usr/sbin/rabbitmq-plugins enable rabbitmq_management
RUN echo "[{rabbit, [{loopback_users, []}]}]." > /etc/rabbitmq/rabbitmq.config

EXPOSE 5672 15672 4369
CMD /newrelic_pivotal_agent-pivotal_agent-1.0.5/pivotal_agent 
CMD /usr/sbin/rabbitmq-server 

#  ./newrelic_pivotal_agent-pivotal_agent-1.0.5/pivotal_agent
