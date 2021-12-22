#!/bin/bash
sudo yum update -y \
&& sudo amazon-linux-extras enable nginx1 \
&& sudo yum clean metadata \
&& sudo yum -y install nginx \
&& wget https://s3.amazonaws.com/amazoncloudwatch-agent/linux/amd64/latest/AmazonCloudWatchAgent.zip \
&& unzip AmazonCloudWatchAgent.zip \
&& sudo ./install.sh \
&& cd /opt/aws/amazon-cloudwatch-agent/bin/ \
&& sudo ./amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c ssm:AmazonCloudWatch-agentconfwebsrv -s \
&& sudo echo "Done" >> /home/ec2-user/hello.txt