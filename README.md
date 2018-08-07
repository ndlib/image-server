# ImageServer
IIIF Image server


## Deploy (with Fargate)
This is a WIP and will be rewritten once we have cloud formation templates and other deploy scripts. Also note, we initially reused existing resources for steps 1-4
1. Create a VPC, referred to as 'vpc-abc123' in this readme
1. Create a NAT gateway
1. Create a routing table that uses the NAT gateway
1. Create a subnet that uses the routing table, referred to as 'subnet-abc123'
1. Create SG allowing inbound to the IIIF port, referred to as 'sg-abc123'
```console
aws ec2 create-security-group --group-name "image-service" --description "Allows inbound traffic to the IIIF service" --vpc-id "vpc-abc123"
aws ec2 authorize-security-group-ingress --group-id "sg-abc123" --protocol tcp --port 8182 --cidr 0.0.0.0/0
```
1. Create the log group `aws logs create-log-group --log-group-name /ecs/image-service --region us-east-1`
1. Create the cluster `aws ecs create-cluster --cluster-name image-service`
1. Create the Fargate task `aws ecs register-task-definition --cli-input-json file://./deploy/fargatetask.json`
1. Create the service pointing to the task revision `aws ecs create-service --cluster image-service --service-name image-service --task-definition ImageService:1 --desired-count 1 --launch-type "FARGATE" --network-configuration "awsvpcConfiguration={subnets=[subnet-abc123],securityGroups=[sg-abc123]}"`


If you need to update the service:
`aws ecs update-service --cluster image-service --service image-service --task-definition ImageService:1 --desired-count 1 --network-configuration "awsvpcConfiguration={subnets=[subnet-abc123],securityGroups=[sg-abc123]}"`
