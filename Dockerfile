# syntax=docker/dockerfile:1
FROM ubuntu:22.04

LABEL maintainer="theos-community"
LABEL description="Theos build environment for iOS jailbreak tweak development"

ARG CHANGE_SOURCE=false

RUN if [ "$CHANGE_SOURCE" = "true" ]; then \
        sed -i 's@http://archive.ubuntu.com@http://mirrors.tuna.tsinghua.edu.cn@g' /etc/apt/sources.list && \
        sed -i 's@http://security.ubuntu.com@http://mirrors.tuna.tsinghua.edu.cn@g' /etc/apt/sources.list; \
    fi

ENV DEBIAN_FRONTEND=noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN=true

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        build-essential \
        fakeroot \
        rsync \
        curl \
        perl \
        zip \
        git \
        libxml2 \
        libtinfo6 \
        pkg-config \
        zlib1g-dev \
        libz3-dev \
        sudo \
        nano \
        openssh-client \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN adduser --uid 1000 --disabled-password --gecos '' me \
    && usermod -aG sudo me \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

USER me
WORKDIR /home/me

ENV THEOS=~/theos
ENV PATH="${THEOS}/bin:${HOME}/toolchain/linux/iphone/bin:${HOME}/toolchain/linux/host/bin:${PATH}"

RUN git clone --recursive https://github.com/theos/theos.git ~/theos

RUN mkdir -p ~/toolchain \
    && if [ "$(uname -m)" = "aarch64" ]; then \
        curl -#L "https://github.com/kabiroberai/swift-toolchain-linux/releases/download/v2.3.0/swift-5.8-ubuntu20.04-aarch64.tar.xz" \
        | tar xvJ -C ~/toolchain; \
    else \
        curl -#L "https://github.com/kabiroberai/swift-toolchain-linux/releases/download/v2.3.0/swift-5.8-ubuntu20.04.tar.xz" \
        | tar xvJ -C ~/toolchain; \
    fi

RUN ~/theos/bin/install-sdk latest

RUN mkdir -p ~/work

COPY --chown=me:me container_init_template entry /home/me/
RUN chmod +x /home/me/container_init_template /home/me/entry

ENTRYPOINT ["/home/me/entry"]
