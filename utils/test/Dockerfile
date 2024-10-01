ARG IMAGE=ubuntu:jammy

FROM ${IMAGE} AS base

FROM base AS install_shellspec

ARG PREINSTALL_PKGS="curl git"

RUN --mount=type=bind,source=./multi_install_deps.sh,target=/tmp/multi_install_deps.sh \
    echo "Installing pre-requisites" \
    && . /tmp/multi_install_deps.sh ${PREINSTALL_PKGS}


RUN echo "Installing ShellSpec" \
    && curl -fsSL https://git.io/shellspec | sh -s -- --yes \
    && mv ~/.local/lib/shellspec /tmp/shellspec

FROM base AS test

COPY --from=install_shellspec --chmod=755 /tmp/shellspec /usr/lib/shellspec
ENV PATH=/usr/lib/shellspec/bin:$PATH
COPY --from=test_root --chmod=755 . .

ARG VERBOSE=0
RUN echo "Running ShellSpec" \
    && shellspec $(if [ ${VERBOSE} -eq 1 ]; then echo "--format documentation"; fi)
