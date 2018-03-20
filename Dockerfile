FROM ubuntu:16.04
LABEL maintainer="github.com/sofianinho"

ENV DEBIAN_FRONTEND=noninteractive\
  REALM=example.com\
  SIGNUP_CODE=secret\
  PROXY=localhost\
  ELLIS=localhost


# Install Ruby, bundler, and dependencies for the bundle install
RUN apt-get update \
  && apt-get install -y \
      ruby-full \
      zlib1g-dev \
      libzmq3-dev \
      bundler \
      git \
      ruby-bundler\
  && mkdir -p /home/live-test/clearwater-live-test

COPY ./ /home/live-test/clearwater-live-test/

WORKDIR "/home/live-test/clearwater-live-test"
RUN git submodule init \
  && git submodule update\
  && bundle install
  && rm /usr/share/rubygems-integration/all/specifications/rake-10.5.0.gemspec
  && bundle install

CMD rake test[${REALM}] SIGNUP_CODE=${SIGNUP_CODE} PROXY=${PROXY} ELLIS=${ELLIS} -f ./Rakefile
