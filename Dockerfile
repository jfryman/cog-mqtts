FROM ruby:2.3.1-alpine

RUN apk -U add ca-certificates build-base git

# Setup bundle user and directory
RUN adduser -h /home/bundle -D bundle && \
    mkdir -p /home/bundle && \
    chown -R bundle /home/bundle

# Copy the bundle source to the image
WORKDIR /home/bundle
COPY . /home/bundle

# Install the bundle, and remove git and the build tooling to recover
# some space
RUN su bundle -c 'bundle install --path .bundle' && \
    apk del build-base && \
    apk del git && \
    rm -f /var/cache/apk/*

# Drop privileges
USER bundle