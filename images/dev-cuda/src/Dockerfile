ARG BASE_IMAGE=nvidia/cuda:12.4.1-cudnn-runtime-ubuntu22.04

FROM ${BASE_IMAGE}


ENV DEBIAN_FRONTEND=noninteractive

RUN --mount=type=cache,target=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt/lists \
    --mount=type=bind,source=./scripts/install_common_utils.sh,target=/tmp/scripts/install_common_utils.sh \
    bash /tmp/scripts/install_common_utils.sh --upgrade-packages --install-zsh


RUN --mount=type=cache,target=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt/lists \
    --mount=type=bind,source=./scripts/install_preinstall_deps.sh,target=/tmp/scripts/install_preinstall_deps.sh \
    bash /tmp/scripts/install_preinstall_deps.sh


ARG USER_NAME=dev
ARG USER_UID=1000
ARG USER_GID=1000

RUN --mount=type=cache,target=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt/lists \
    --mount=type=bind,source=./scripts/add_nonroot_user.sh,target=/tmp/scripts/add_nonroot_user.sh \
    bash /tmp/scripts/add_nonroot_user.sh -u ${USER_NAME} -i ${USER_UID} -g ${USER_GID} -f

USER ${USER_NAME}
ENV HOME=/home/${USER_NAME}
WORKDIR ${HOME}/workspace

ARG PYTHON_VERSION=3.10

ENV PYENV_ROOT=${HOME}/.pyenv
ENV PATH=${PYENV_ROOT}/shims:${PYENV_ROOT}/bin:$PATH

RUN --mount=type=cache,target=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt/lists \
    --mount=type=bind,source=./scripts/install_python.sh,target=/tmp/scripts/install_python.sh \
    bash /tmp/scripts/install_python.sh -p ${PYTHON_VERSION}
