FROM ubuntu:16.04
MAINTAINER Rafał Kobyłko "rafakob@gmail.com"

# DEPENDENCIES
RUN dpkg --add-architecture i386 && apt-get update
RUN apt-get install -yq libc6-i386 lib32stdc++6 lib32gcc1 lib32ncurses5 lib32z1 python curl nano git --no-install-recommends

# JAVA 8
RUN echo y | apt-get install openjdk-8-jdk

# ANDROID SDK
RUN curl -L "http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz" | tar --no-same-owner -xz -C /opt
ENV ANDROID_HOME /opt/android-sdk-linux
ENV PATH ${ANDROID_HOME}/tools:$ANDROID_HOME/platform-tools:$PATH

# ANDROID COMPONENTS
RUN echo y | android update sdk --no-ui --all --filter \
    addon-google_apis-google-23,addon-google_apis-google-22,addon-google_apis-google-21
    
RUN echo y | android update sdk --no-ui --all --filter \
    android-23,android-22,android-21,android-20,android-19,android-18,android-17,android-16,android-15

RUN echo y | android update sdk --no-ui --all --filter \
    tools,build-tools-23.0.3,build-tools-23.0.2,build-tools-23.0.1,build-tools-22.0.1,build-tools-21.1.2,build-tools-20.0.0,build-tools-19.1.0

RUN echo y | android update sdk --no-ui --all --filter \
    platform-tools,extra-android-m2repository,extra-google-m2repository,extra-android-support,extra-google-google_play_services

# EMULATOR IMAGES
RUN echo y | android update adb
RUN echo y | android update sdk --no-ui --all --filter \
    sys-img-x86-google_apis-23,sys-img-armeabi-v7a-google_apis-23

# CREATE AVDS
RUN echo no | android create avd --force -n EMU_ARM_API_23 -t android-23 --abi google_apis/armeabi-v7a
RUN echo no | android create avd --force -n EMU_x86_API_23 -t android-23 --abi google_apis/x86

# CLEAN UP
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && apt-get autoremove -y && apt-get clean

# SETUP WORKSPACE
ENV SHELL=/bin/bash TERM=dumb
RUN mkdir /opt/worksapce
WORKDIR /opt/workspace
