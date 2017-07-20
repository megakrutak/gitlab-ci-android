FROM jangrewe/gitlab-ci-android
MAINTAINER Mikhail Shishkin <megakrutak@gmail.com>

ENV PATH "$PATH:${ANDROID_HOME}/platform-tools:${ANDROID_HOME}/tools/bin"

RUN apt-get update && \
    echo y | apt-get install apt-transport-https

RUN echo "deb https://packages.cloud.google.com/apt cloud-sdk-xenial main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

RUN apt-get update && \
    echo y | apt-get install google-cloud-sdk



