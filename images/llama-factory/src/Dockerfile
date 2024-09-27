ARG BASE_IMAGE=nvidia/cuda:12.4.1-cudnn-devel-ubuntu22.04

FROM ${BASE_IMAGE}

ENV DEBIAN_FRONTEND=noninteractive

RUN --mount=type=cache,target=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt/lists \
    apt-get update -y \
    && apt-get install -y \
        make \
        build-essential \
        libssl-dev \
        zlib1g-dev \
        libbz2-dev \
        libreadline-dev \
        libsqlite3-dev \
        sudo \
        wget \
        curl \
        llvm \
        libncurses5-dev \
        libncursesw5-dev \
        xz-utils \
        tk-dev \
        libffi-dev \
        liblzma-dev \
        python3-openssl \
        git


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

# NOTE: Set CUDA_VERSION=cpu to install the CPU version of PyTorch.(A useful trick for testing)
ARG CUDA_VERSION=12.4.1
WORKDIR /workspace
RUN --mount=type=cache,target=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt/lists \
    --mount=type=cache,target=${PYENV_ROOT}/cache \
    --mount=type=cache,target=${HOME}/.cache/pip \
    pip install --upgrade --no-cache-dir \
        pip \
        setuptools \
        wheel \
    && cuda_code=$(echo ${CUDA_VERSION} | cut -d'.' -f1,2 | sed 's/\.//') \
    && pip install --no-cache-dir \
        --index-url https://download.pytorch.org/whl/cu${cuda_code} \
        torch \
    && git clone --depth 1 https://github.com/hiyouga/LLaMA-Factory.git /workspace/llama-factory \
    && cd /workspace/llama-factory \
    && pip install -e ".[torch,metrics]" \
    && pip install bitsandbytes deepspeed \
    && pip install flash-attn --no-build-isolation --force-reinstall

WORKDIR /workspace/llama-factory
