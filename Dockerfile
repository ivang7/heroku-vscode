FROM debian:10

RUN apt-get update \
 && apt-get install -y \
    curl \
    dumb-init \
    htop \
    locales \
    man \
    nano \
    zip \
    unzip \
    git \
    procps \
    ssh \
    sudo \
    vim

# https://wiki.debian.org/Locale#Manually
RUN sed -i "s/# en_US.UTF-8/en_US.UTF-8/" /etc/locale.gen \
  && locale-gen
ENV LANG=en_US.UTF-8

RUN chsh -s /bin/bash
ENV SHELL=/bin/bash

RUN adduser --gecos '' --disabled-password coder && \
  echo "coder ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/nopasswd

RUN curl -SsL https://github.com/boxboat/fixuid/releases/download/v0.4/fixuid-0.4-linux-amd64.tar.gz | tar -C /usr/local/bin -xzf - && \
    chown root:root /usr/local/bin/fixuid && \
    chmod 4755 /usr/local/bin/fixuid && \
    mkdir -p /etc/fixuid && \
    printf "user: coder\ngroup: coder\n" > /etc/fixuid/config.yml
    
RUN cd /tmp && \
  curl -L --silent \
  `curl --silent "https://api.github.com/repos/cdr/code-server/releases" \
    | grep '"browser_download_url":' \
    | grep "linux-x86_64" \
    | sed -E 's/.*"([^"]+)".*/\1/' \
    | head -n1 \
  `| tar -xzf - && \
  mv code-server* /usr/local/lib/code-server && \
  ln -s /usr/local/lib/code-server/code-server /usr/local/bin/code-server

# custom settings
## install open-jdk8
RUN apt-get install -y software-properties-common \
  && apt-add-repository 'deb http://security.debian.org/debian-security stretch/updates main' \
  && apt-get update \
  && apt-get install -y openjdk-8-jdk

## install android sdk
RUN cd /home/coder && \
curl https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip -O && \
unzip sdk-tools-linux-4333796.zip && \
rm sdk-tools-linux-4333796.zip && \
mkdir android-sdk && \
mv tools android-sdk/tools && \
export ANDROID_HOME=/home/coder/android-sdk && \
export PATH=$PATH:$ANDROID_HOME/tools/bin && \
export PATH=$PATH:$ANDROID_HOME/platform-tools && \
yes | sdkmanager --licenses && \
sdkmanager "platform-tools" "platforms;android-29"

#clean 
RUN rm -rf /var/lib/apt/lists/*

ENV PORT=8080
EXPOSE 8080
USER coder
WORKDIR /home/coder
CMD /usr/local/bin/code-server --host 0.0.0.0 --port $PORT .
