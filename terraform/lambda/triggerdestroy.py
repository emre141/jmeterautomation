import boto3
import json

def lambda_handler(event, context):
    client = boto3.client('ec2')
    message = event['Records'][0]['Sns']['Message']
    parsed_message = json.loads(message)
    instance_id = parsed_message['instanceId']
    print(parsed_message['status'])
    print(instance_id)
    if parsed_message['status'] == "Success":
        print("SSM Run Command Complete Successfully and Test Instance is terminating:")
        response = client.terminate_instances(InstanceIds=[instance_id])
        print(response)
    else:
        print("SSM command send unsuceess result:" + parsed_message['status'])
