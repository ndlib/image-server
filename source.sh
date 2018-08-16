#! /bin/bash

sed -i "s/S3Source.BasicLookupStrategy.bucket.name =/S3Source.BasicLookupStrategy.bucket.name = $IMAGE_BUCKET/g" ctlp.props
sed -i "\$a AmazonS3Resolver.BasicLookupStrategy.bucket.name = $IMAGE_BUCKET" ctlp.props
exec java -Dcantaloupe.config=ctlp.props -Xmx2g -jar cantaloupe.war
