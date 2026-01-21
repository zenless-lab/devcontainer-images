ARG BASE_IMAGE=mcr.microsoft.com/devcontainers/base:ubuntu
FROM ${BASE_IMAGE}

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    export DEBIAN_FRONTEND=noninteractive \
    && apt-get update \
    && apt-get -y install --no-install-recommends \
        curl \
        ca-certificates \
        perl \
        gzip \
        xz-utils \
        tar

ARG INSTALL_SCRIPT_LOCATION="https://tug.ctan.org/systems/texlive/tlnet"
ARG INSTALL_SCRIPT_NAME="/install-tl-unx.tar.gz"
RUN --mount=type=cache,target=/tmp/texlive,sharing=locked \
    update-ca-certificates \
    && curl -LfsS --retry 3 -o /tmp/texlive/install-tl-unx.tar.gz ${INSTALL_SCRIPT_LOCATION}${INSTALL_SCRIPT_NAME} \
    && zcat < /tmp/texlive/install-tl-unx.tar.gz | tar -xvf - -C /tmp/texlive --strip-components=1

ARG SCHEME=full
ARG PAPER=a4
RUN --mount=type=cache,target=/tmp/texlive,sharing=locked \
    /tmp/texlive/install-tl \
        --location ${INSTALL_SCRIPT_LOCATION} \
        --no-interaction \
        --scheme ${SCHEME} \
        --paper ${PAPER}

RUN ln -s /usr/local/texlive/$(ls /usr/local/texlive | grep '20[0-9][0-9]')/bin/*/* /usr/local/bin/
