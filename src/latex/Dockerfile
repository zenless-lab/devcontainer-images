ARG BASE_IMAGE=mcr.microsoft.com/devcontainers/base:ubuntu
FROM busybox:stable AS downloader

FROM ${BASE_IMAGE} AS final

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
    --mount=type=cache,target=/var/lib/apt,sharing=locked \
    export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get -y install --no-install-recommends \
        curl \
        ca-certificates \
        perl \
        gzip \
        xz-utils \
        tar

ARG SCHEME=full
ARG PAPER=a4
RUN --mount=type=cache,target=/tmp/texlive,sharing=locked \
    --mount=from=ryanminato/tex-live-src:latest,source=/,target=/tmp/texlive,readonly \
    install_script=$(ls -d /tmp/texlive/*/install-tl | head -n 1) && \
    if [ -z "$install_script" ] || [ ! -x "$install_script" ]; then \
        echo "TeX Live install script not found or not executable at '$install_script'"; \
        exit 1; \
    fi && \
    for attempt in 1 2 3; do \
        echo "Attempt $attempt to install TeX Live" && \
        "${install_script}" \
            --no-interaction \
            --scheme ${SCHEME} \
            --paper ${PAPER} && \
        break || { \
            exit_code=$?; \
            echo "Installation failed with exit code $exit_code"; \
            if [ $attempt -lt 3 ]; then \
                echo "Retrying in 5 seconds..."; \
                sleep 5; \
            else \
                echo "All attempts failed. Exiting."; \
                exit $exit_code; \
            fi; \
        } \
    done

RUN ln -s /usr/local/texlive/$(ls /usr/local/texlive | grep '20[0-9][0-9]')/bin/*/* /usr/local/bin/
