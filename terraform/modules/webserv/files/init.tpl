#!/bin/bash
sudo yum update -y \
&& sudo amazon-linux-extras enable nginx1 \
&& sudo yum clean metadata \
&& sudo yum -y install nginx \
&& sudo service nginx start \
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
&& sudo ./amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -c ssm:AmazonCloudWatch-agentconfwebsrv -s \
&& DD_AGENT_MAJOR_VERSION=7 DD_API_KEY=652f84060387bd648925ca20ac8e23e2 DD_SITE="datadoghq.com" bash -c "$(curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script.sh)" \
&& sudo echo "init_config:
instances:
  - name: nginx
    search_string: ['nginx']
" >> /etc/datadog-agent/conf.d/process.yaml \
&& sudo echo 'process_config:
  enabled: "true"' >> /etc/datadog-agent/datadog.yaml \
&& sudo service datadog-agent restart \
&& sudo echo "Done" >> /home/ec2-user/hello.txt