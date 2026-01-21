ARG BASE_IMAGE=mcr.microsoft.com/devcontainers/base:ubuntu
FROM busybox:stable AS downloader
ARG INSTALL_SCRIPT_URL="https://tug.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz"
ADD ${INSTALL_SCRIPT_URL} /install-tl-unx.tar.gz

FROM ${BASE_IMAGE} AS final

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

ARG SCHEME=full
ARG PAPER=a4
RUN --mount=type=cache,target=/tmp/texlive,sharing=locked \
    --mount=from=downloader,source=/install-tl-unx.tar.gz,target=/tmp/texlive/install-tl-unx.tar.gz,readonly \
    zcat < /tmp/texlive/install-tl-unx.tar.gz | tar -xvf - -C /tmp/texlive --strip-components=1 \
    && /tmp/texlive/install-tl \
        --no-interaction \
        --scheme ${SCHEME} \
        --paper ${PAPER}

RUN ln -s /usr/local/texlive/$(ls /usr/local/texlive | grep '20[0-9][0-9]')/bin/*/* /usr/local/bin/
