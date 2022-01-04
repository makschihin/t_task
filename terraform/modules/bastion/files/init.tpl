#!/bin/bash

sudo yum update -y \
&& wget https://s3.amazonaws.com/amazoncloudwatch-agent/linux/amd64/latest/AmazonCloudWatchAgent.zip \
&& unzip AmazonCloudWatchAgent.zip \
&& sudo ./install.sh \
&& cd /opt/aws/amazon-cloudwatch-agent/bin/ \
&& sudo echo '{
	"agent": {
		"run_as_user": "root"
	},
	"logs": {
		"logs_collected": {
			"files": {
				"collect_list": [
					{
						"file_path": "/var/log/messages",
						"log_group_name": "name_of_log_group",
						"log_stream_name": "{instance_id}"
					}
				]
			}
		}
	}
}' >> awscwagent \
&& sed -i "s/"name_of_log_group"/${consul_address}/g" "awscwagent" \
&& sudo ./amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c file:awscwagent -s \
&& sudo yum install socat -y \
&& sudo echo "hello" >> /home/ec2-user/hello.txt

