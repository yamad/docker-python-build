ARG UBUNTU_VERSION=18.04

FROM ubuntu:${UBUNTU_VERSION} as build-python

ARG PYTHON_VERSION=3.8.5
ARG BUILD_VERSION=1.0

# turn off prompts for tzdata
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

LABEL maintainer="Jason Yamada-Hanff <jyamada1@gmail.com>" \
      label="build-python" \
      version="${BUILD_VERSION}" \
      version_python="${PYTHON_VERSION}" \
      description="Build CPython"

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    ca-certificates \
    libffi-dev \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    wget \
    curl \
    llvm \
    libncurses5-dev \
    libncursesw5-dev \
    xz-utils \
    tk-dev

WORKDIR /src
RUN mkdir python && \
    wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz -O python.tar.gz && \
    tar xzf python.tar.gz --strip-components=1 -C python

WORKDIR /src/python
RUN ./configure --enable-optimizations \
                --prefix=/opt/python \
                --with-ensurepip=install && \
    make -j$(nproc) && \
    make install
