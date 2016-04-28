FROM ubuntu:14.04
MAINTAINER Rafał Kobyłko "rafakob@gmail.com"

# Java 8
RUN apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:webupd8team/java && apt-get update

RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    apt-get install -y oracle-java8-installer && apt-get install -y oracle-java8-set-default

# Dependencies
RUN dpkg --add-architecture i386 && apt-get update
RUN apt-get install -yq libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1 python curl nano git --no-install-recommends

# Android SDK
ENV ANDROID_SDK_URL http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz
RUN curl -L "${ANDROID_SDK_URL}" | tar --no-same-owner -xz -C /opt
ENV ANDROID_HOME /opt/android-sdk-linux
ENV ANDROID_SDK /opt/android-sdk-linux
ENV PATH ${ANDROID_HOME}/tools:$ANDROID_HOME/platform-tools:$PATH

# Android components
RUN echo y | android update sdk --no-ui --all --filter \
    addon-google_apis-google-23,addon-google_apis-google-22,addon-google_apis-google-21
  
RUN echo y | android update sdk --no-ui --all --filter \
    android-23,android-22,android-21,android-20,android-19,android-18,android-17,android-16,android-15

RUN echo y | android update sdk --no-ui --all --filter \
    tools,build-tools-23.0.3,build-tools-23.0.2,build-tools-23.0.1,build-tools-22.0.1,build-tools-21.1.2,build-tools-20.0.0,build-tools-19.1.0

RUN echo y | android update sdk --no-ui --all --filter \
    platform-tools,extra-android-m2repository,extra-google-m2repository,extra-android-support,extra-google-google_play_services

# Emulator
RUN echo y | android update sdk --no-ui --all --filter sys-img-x86-google_apis-23,sys-img-armeabi-v7a-google_apis-23
RUN echo no | android create avd --force -n EMU_ARM_API_23 -t android-23 --abi google_apis/armeabi-v7a
RUN echo no | android create avd --force -n EMU_x86_API_23 -t android-23 --abi google_apis/x86
RUN echo y | android update adb

# Clean up
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    apt-get autoremove -y && apt-get clean

# Setup worksapce
ENV SHELL=/bin/bash TERM=dumb
RUN mkdir /opt/worksapce
WORKDIR /opt/workspace
