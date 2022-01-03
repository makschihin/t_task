#!/bin/bash
sudo yum update -y \
&& wget https://s3.amazonaws.com/amazoncloudwatch-agent/linux/amd64/latest/AmazonCloudWatchAgent.zip \
&& unzip AmazonCloudWatchAgent.zip \
&& sudo ./install.sh \
&& cd /opt/aws/amazon-cloudwatch-agent/bin/ \
&& sudo ./amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c ssm:AmazonCloudWatch-agentconf -s \
&& sudo echo "hello" >> /home/ec2-user/hello.txt