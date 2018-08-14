#! /bin/bash

sed -i "s/S3Source.BasicLookupStrategy.bucket.name =/S3Source.BasicLookupStrategy.bucket.name = $IMAGE_BUCKET/g" ctlp.props
java -Dcantaloupe.config=ctlp.props -Xmx2g -jar cantaloupe.war
