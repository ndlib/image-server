
FROM mostalive/ubuntu-14.04-oracle-jdk8

ARG ctl_ver=4.0

ARG IMG_BUCKET="image_bucket"
ENV IMAGE_BUCKET=$IMG_BUCKET
ADD source.sh /
ENTRYPOINT ["/bin/bash", "/source.sh"]

VOLUME /imageroot

# Update packages and install tools
RUN apt-get update -y && apt-get install -y wget unzip

# Get and unpack Cantaloupe release archive
RUN wget https://github.com/medusa-project/cantaloupe/releases/download/v${ctl_ver}/Cantaloupe-${ctl_ver}.zip \
    && unzip Cantaloupe-${ctl_ver}.zip \
    && rm Cantaloupe-${ctl_ver}.zip

WORKDIR cantaloupe-${ctl_ver}

# Configure image path to mapped volume and enable filesystem cach
RUN sed -e 's+home\/myself\/images+imageroot+' -e 's/#cache.server/cache.server/' < cantaloupe.properties.sample > ctlp.props \
  && mv cantaloupe-${ctl_ver}.war cantaloupe.war

RUN   sed -i "s/endpoint.admin.enabled = false/endpoint.admin.enabled = true/g" ctlp.props\
  &&    sed -i "s/endpoint.api.enabled = false/endpoint.api.enabled = true/g" ctlp.props\
  &&    sed -i "s/endpoint.admin.secret =/endpoint.admin.secret = admin/g" ctlp.props\
  &&    sed -i "s/endpoint.api.username =/endpoint.api.username = admin/g" ctlp.props\
  &&    sed -i "s/endpoint.api.secret =/endpoint.api.secret = admin/g" ctlp.props\
  &&    sed -i "s/source.static = FilesystemSource/source.static = S3Source/g" ctlp.props\
  &&    sed -i "s/S3Source.endpoint =/S3Source.endpoint = s3.amazonaws.com/g" ctlp.props\
  &&    sed -i "\$a AmazonS3Resolver.endpoint = s3.amazonaws.com" ctlp.props\
  &&    sed -i "\$a AmazonS3Resolver.lookup_strategy = BasicLookupStrategy" ctlp.props\
  &&    sed -i "\$a AmazonS3Resolver.bucket.region = us-east-1" ctlp.props\
  &&    sed -i "s/processor.fallback_retrieval_strategy = DownloadStrategy/processor.fallback_retrieval_strategy = CacheStrategy/g" ctlp.props\
  &&    sed -i "s/cache.client.enabled = true/cache.client.enabled = false/g" ctlp.props\
  &&    sed -i "s/log.application.level = debug/log.application.level = all/g" ctlp.props\
  &&    sed -i "s/RollingFileAppender.enabled = false/RollingFileAppender.enabled = true/g" ctlp.props

EXPOSE 8182
CMD source.sh
