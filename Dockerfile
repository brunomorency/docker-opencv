FROM ubuntu:14.04
MAINTAINER Bruno Morency <bruno@morency.me>

# Update list of packages
RUN apt-get update

# Install OpenCV dependencies
RUN	apt-get install -y -q wget curl unzip execstack
RUN	apt-get install -y -q build-essential
RUN	apt-get install -y -q cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev libavfilter-dev opencl-dev
RUN	apt-get install -y -q python2.7 python2.7-dev  python-numpy
RUN	apt-get install -y -q libjpeg-dev libpng-dev libtiff-dev libjasper-dev zlib1g-dev libtbb2 libtbb-dev

# Fake a fuse install (or openjdk-7-jdk will not install)
RUN apt-get install libfuse2
RUN cd /tmp ; apt-get download fuse
RUN cd /tmp ; dpkg-deb -x fuse_* .
RUN cd /tmp ; dpkg-deb -e fuse_*
RUN cd /tmp ; rm fuse_*.deb
RUN cd /tmp ; echo -en '#!/bin/bash\nexit 0\n' > DEBIAN/postinst
RUN cd /tmp ; dpkg-deb -b . /fuse.deb
RUN cd /tmp ; dpkg -i /fuse.deb

# install Java and Ant
RUN apt-get install -y openjdk-7-jdk
RUN apt-get install -y ant
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64/
ENV PATH $JAVA_HOME/bin:$PATH

# compile OpenCV from source
ADD	build_opencv.sh	/build_opencv.sh
RUN	/bin/sh /build_opencv.sh
RUN	rm -rf /build_opencv.sh
RUN execstack -c /usr/local/opencv-3.0.0-beta/share/OpenCV/java/libopencv_java300.so
ENV OPENCV_JAVA_PATH /usr/local/opencv-3.0.0-beta/share/OpenCV/java
ENV OPENCV_JAR ${OPENCV_JAVA_PATH}/opencv-300.jar
ENV LD_LIBRARY_PATH ${OPENCV_JAVA_PATH}

# Install node.js from source
# based on official node.js docker image: https://github.com/joyent/docker-node

# verify gpg and sha256: http://nodejs.org/dist/v0.10.31/SHASUMS256.txt.asc
# gpg: aka "Timothy J Fontaine (Work) <tj.fontaine@joyent.com>"
# gpg: aka "Julien Gilli <jgilli@fastmail.fm>"
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys 7937DFD2AB06298B2293C3187D33FF9D0246406D 114F43EE0176B71C7BC219DD50A3051F888C628D

ENV NODE_VERSION 0.10.36
ENV NPM_VERSION 2.5.0

RUN curl -SLO "http://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
  && curl -SLO "http://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
  && gpg --verify SHASUMS256.txt.asc \
  && grep " node-v$NODE_VERSION-linux-x64.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - \
  && tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
  && rm "node-v$NODE_VERSION-linux-x64.tar.gz" SHASUMS256.txt.asc \
  && npm install -g npm@"$NPM_VERSION" \
  && npm cache clear

# install lwip package because it's a pita to compile from source every time
# we deploy the app
RUN npm install -g lwip
ENV NODE_PATH /usr/local/lib/node_modules
