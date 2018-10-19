# ImageServer
IIIF Image server

## System Requirements
* Docker
* An AWS S3 bucket for source images
* An AWS S3 bucket for caching derivatives
* A valid AWS role that can read from the source images bucket and read/write to the derivatives bucket
* [aws-vault](https://github.com/99designs/aws-vault), or similar, for assuming the role

## Building the image
Run the following from the root of the project:
```console
docker build . -t image-service
```

## Running the image
Before you run, you must assume the role necessary to access the buckets. Here's an example using aws-vault:
```console
aws-vault exec vault-profile-name --assume-role-ttl 1h -- bash
```
Start the container using the built image, replacing [s3-image-bucket-name] and [s3-cache-bucket-name] with valid bucket names:
```console
docker run --name image-service -p 8182:8182 \
  --env AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID \
  --env AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY \
  --env AWS_SECURITY_TOKEN=$AWS_SECURITY_TOKEN \
  --env AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN \
  --env IMAGE_BUCKET=[s3-image-bucket-name] \
  --env CACHE_BUCKET=[s3-cache-bucket-name] \
  image-service
```
You should now be able to access the service at `localhost:8182`. For example, if you have a mypicture.tif within the image source bucket, here's how to retrieve the full image: http://localhost:8182/iiif/2/mypicture.tif/full/full/0/default.jpg

## Testing with [Newman CLI](https://github.com/postmanlabs/newman)

1. [Install](https://github.com/postmanlabs/newman#getting-started) newman and nodejs
2. Create JSON files for the [environment](https://www.getpostman.com/docs/v6/postman/environments_and_globals/intro_to_environments_and_globals). See `spec/local_env.json` for an example of the key value pairs needed to test a local instance.
3. Run the tests, ex:
```console
newman run spec/image-server.postman_collection.json -e spec/local_env.json
```
