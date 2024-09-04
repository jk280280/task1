#!/usr/bin/env python3

import boto3
import json

# Define your AWS region
REGION_NAME = 'us-east-1'  # Replace with your AWS region


def get_asg_instances(asg_name):
    client = boto3.client('autoscaling')
    response = client.describe_auto_scaling_groups(AutoScalingGroupNames=[asg_name])
    instances = []
    for asg in response['AutoScalingGroups']:
        for instance in asg['Instances']:
            instances.append(instance['InstanceId'])
    return instances

def get_instance_ips(instance_ids):
    client = boto3.client('ec2')
    response = client.describe_instances(InstanceIds=instance_ids)
    hosts = []
    for reservation in response['Reservations']:
        for instance in reservation['Instances']:
            if 'PublicIpAddress' in instance:
                hosts.append(instance['PublicIpAddress'])
    return hosts

def main():
    asg_name = 'terraform-20240904141312458300000001'  # Replace with your ASG name 
    instance_ids = get_asg_instances(asg_name)
    hosts = get_instance_ips(instance_ids)
    
    inventory = {
        'all': {
            'hosts': hosts
        }
    }

    print(json.dumps(inventory, indent=2))

if __name__ == '__main__':
    main()
