ARG BASE_IMAGE=mcr.microsoft.com/devcontainers/base:ubuntu
FROM ${BASE_IMAGE} AS build

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get -y install --no-install-recommends \
        build-essential \
        libreadline-dev \
        libncurses5-dev \
        ncurses-dev \
        curl \
        libcurl4 \
        libcurl4-gnutls-dev \
        xorg-dev \
        make \
        gcc \
        g++\
        gfortran \
        perl-modules\
        libdevel-checklib-perl \
        libfile-which-perl \
        python3-dev \
        python3-pip \
        python3-setuptools \
        python3-astropy \
        python3-numpy \
        python3-scipy \
        python3-matplotlib

ENV CC=/usr/bin/gcc
ENV CXX=/usr/bin/g++
ENV FC=/usr/bin/gfortran
ENV PERL=/usr/bin/perl
ENV PYTHON=/usr/bin/python3

WORKDIR /heasoft-src
COPY --from=ryanminato/heasoft-src:latest / .
RUN cd ./heasoft-*/BUILD_DIR && \
    ./configure --prefix=/opt/heasoft && \
    make && \
    make install

FROM ${BASE_IMAGE} AS final

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive \
    apt-get -y install --no-install-recommends \
        libcurl4 \
        perl-modules\
        libcurl4-gnutls-dev \
        libfile-which-perl \
        python3-astropy \
        python3-numpy \
        python3-scipy \
        python3-matplotlib

COPY --from=build /opt/heasoft /opt/heasoft
RUN echo "# HEASoft environment setup" > /etc/profile.d/heasoft.sh && \
    echo "export HEADAS=$(dirname $(ls -d /opt/heasoft/*/headas-init.sh | head -n 1))" >> /etc/profile.d/heasoft.sh && \
    echo '. $HEADAS/headas-init.sh' >> /etc/profile.d/heasoft.sh && \
    chmod +x /etc/profile.d/heasoft.sh && \
    echo "# HEASoft environment setup" > /etc/profile.d/heasoft.csh && \
    echo "setenv HEADAS $(dirname $(ls -d /opt/heasoft/*/headas-init.csh | head -n 1))" >> /etc/profile.d/heasoft.csh && \
    echo 'source $HEADAS/headas-init.csh' >> /etc/profile.d/heasoft.csh && \
    chmod +x /etc/profile.d/heasoft.csh
