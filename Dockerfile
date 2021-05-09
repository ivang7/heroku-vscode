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
    vim \
#for open-jdk8
  && apt-get install -y software-properties-common \
  && apt-add-repository 'deb http://security.debian.org/debian-security stretch/updates main' \
  && apt-get update \
  &&  apt-get install -y openjdk-8-jdk \
#clean 
  && rm -rf /var/lib/apt/lists/*

# install java and android sdk-------------- not finish, need change method install java
RUN mkdir /home/coder && cd /home/coder && \
#curl -s "https://get.sdkman.io" | bash && \
#bash -c 'source "/root/.sdkman/bin/sdkman-init.sh"' && \
#bash -c 'sdk install java 9.0.7-zulu' && \
#bash -c 'sdk use java 9.0.7-zulu' && \
curl https://dl.google.com/android/repository/sdk-tools-linux-4333796.zip -O && \
unzip sdk-tools-linux-4333796.zip && \
rm sdk-tools-linux-4333796.zip && \
mkdir android-sdk && \
mv tools android-sdk/tools && \
export ANDROID_HOME=/home/coder/android-sdk && \
export PATH=$PATH:$ANDROID_HOME/tools/bin && \
export PATH=$PATH:$ANDROID_HOME/platform-tools && \
#export JAVA_OPTS='-XX:+IgnoreUnrecognizedVMOptions --add-modules java.se.ee' && \ #unset JAVA_OPTS
yes | sdkmanager --licenses && \
sdkmanager "platform-tools" "platforms;android-29"

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

ENV PORT=8080
EXPOSE 8080
USER coder
WORKDIR /home/coder
CMD /usr/local/bin/code-server --host 0.0.0.0 --port $PORT .
