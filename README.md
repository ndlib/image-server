# ImageServer
IIIF Image server

## Local Dockerfile
Current progress on using the dockerfile for a local instance.
Local machine must have aws-vault and docker installed to work properly.
An S3 instance will be used to pull images from.

Terminal commands to build and run docker instance in directory dockerfile is located
```console
docker build . -t [image-build-name]
aws-vault exec admin --assume-role-ttl 1h -- bash
docker run --name [run-instance-name] -p 8182:8182 \
     --env AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
     --env AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY --env AWS_SECURITY_TOKEN=$AWS_SECURITY_TOKEN \
     --env AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN --env IMAGE_BUCKET=[s3-image-bucket-name] CACHE_BUCKET=[s3-cache-bucket-name][image-build-name]

- You should now be able to access the Admin Console from `localhost:8182/admin`
  (Default username and password for the Admin Console are both admin)
