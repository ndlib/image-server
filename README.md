# ImageServer
IIIF Image server

## Deploy
Prerequisite stack https://github.com/ndlib/mellon-blueprints/blob/master/deploy/cloudformation/infrastructure.yml must be deployed before deploying this service stack.

Deploy using the aws-cli:
`aws cloudformation deploy --template-file deploy/iiif-service-stack.yml --stack-name mellon-image-service`
