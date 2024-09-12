#!/usr/bin/env python3

import boto3
import json
import sys

def get_asg_instances(asg_name):
    client = boto3.client('autoscaling', region_name='us-east-1')
    ec2_client = boto3.client('ec2', region_name='us-east-1')
    
    try:
        response = client.describe_auto_scaling_groups(AutoScalingGroupNames=[asg_name])
        asg = response['AutoScalingGroups']
        
        if not asg:
            raise ValueError(f"No Auto Scaling Group found with name: {asg_name}")
        
        asg_instances = asg[0].get('Instances', [])
        
        if not asg_instances:
            return []

        instance_ids = [i['InstanceId'] for i in asg_instances]
        
        # Fetch public IPs of instances
        reservations = ec2_client.describe_instances(InstanceIds=instance_ids)
        instances = []
        for reservation in reservations['Reservations']:
            for instance in reservation['Instances']:
                if 'PublicIpAddress' in instance:
                    instances.append(instance['PublicIpAddress'])
        
        return instances
    except Exception as e:
        print(f"Error fetching ASG instances: {e}")
        return []

def main():
    asg_name = 'terraform-20240912134216047600000001'  # Update with your ASG name
    try:
        instances = get_asg_instances(asg_name)
        inventory = {
            'all': {
                'hosts': instances
            }
        }
        print(json.dumps(inventory, indent=4))
    except Exception as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)

if __name__ == '__main__':
    main()
