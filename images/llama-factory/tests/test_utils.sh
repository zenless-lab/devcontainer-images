#!/bin/bash

USERNAME=${1:-dev}

if [ -z $HOME ]; then
    HOME="/root"
fi

FAILED=()

check() {
    LABEL=$1
    shift
    echo -e "\n🧪 Testing $LABEL"
    if "$@"; then
        echo "✅  Passed!"
        return 0
    else
        echo "❌ $LABEL check failed."
        FAILED+=("$LABEL")
        return 1
    fi
}

check-exit() {
    LABEL=$1
    # check file or directory exists
    for i in "${@:2}"; do
        echo -e "\n🧪 Testing $LABEL: '$i' exists"
        if [ -e "$i" ]; then
            echo "✅  Passed!"
        else
            echo "❌ $LABEL check failed."
            FAILED+=("$LABEL")
            return 1
        fi
    done
    return 0
}

check-dir-exists() {
    LABEL=$1
    # chek directory exists
    for i in "${@:2}"; do
        echo -e "\n🧪 Testing $LABEL: '$i' exists"
        if [ -d "$i" ]; then
            echo "✅  Passed!"
        else
            echo "❌ $LABEL check failed."
            FAILED+=("$LABEL")
            return 1
        fi
    done
    return 0
}

check-file-exists() {
    LABEL=$1
    # check file exists
    for i in "${@:2}"; do
        echo -e "\n🧪 Testing $LABEL: '$i' exists"
        if [ -f "$i" ]; then
            echo "✅  Passed!"
        else
            echo "❌ $LABEL check failed."
            FAILED+=("$LABEL")
            return 1
        fi
    done
    return 0
}

check-version-ge() {
    LABEL=$1
    CURRENT_VERSION=$2
    REQUIRED_VERSION=$3
    shift
    echo -e "\n🧪 Testing $LABEL: '$CURRENT_VERSION' is >= '$REQUIRED_VERSION'"
    local GREATER_VERSION=$( (echo ${CURRENT_VERSION}; echo ${REQUIRED_VERSION}) | sort -V | tail -1)
    if [ "${CURRENT_VERSION}" == "${GREATER_VERSION}" ]; then
        echo "✅  Passed!"
        return 0
    else
        echoStderr "❌ $LABEL check failed."
        FAILED+=("$LABEL")
        return 1
    fi
}


check_multiple() {
    PASSED=0
    LABEL="$1"
    echo -e "\n🧪 Testing $LABEL."
    shift; MINIMUMPASSED=$1
    shift; EXPRESSION="$1"
    while [ "$EXPRESSION" != "" ]; do
        if $EXPRESSION; then ((PASSED++)); fi
        shift; EXPRESSION=$1
    done
    if [ $PASSED -ge $MINIMUMPASSED ]; then
        echo "✅ Passed!"
        return 0
    else
        echo "❌ $LABEL check failed."
        FAILED+=("$LABEL")
        return 1
    fi
}

check_os_packages() {
    LABEL=$1
    shift
    echo -e "\n🧪 Testing $LABEL"
    if dpkg-query --show -f='${Package}: ${Version}\n' "$@"; then
        echo "✅  Passed!"
        return 0
    else
        echo "❌ $LABEL check failed."
        FAILED+=("$LABEL")
        return 1
    fi
}


check_common()
{
    PACKAGE_LIST="apt-utils \
        git \
        openssh-client \
        less \
        iproute2 \
        procps \
        curl \
        wget \
        unzip \
        nano \
        jq \
        lsb-release \
        ca-certificates \
        apt-transport-https \
        dialog \
        gnupg2 \
        libc6 \
        libgcc1 \
        libgssapi-krb5-2 \
        liblttng-ust1 \
        libstdc++6 \
        zlib1g \
        locales \
        sudo"

    # Actual tests
    check_os_packages "common-os-packages" ${PACKAGE_LIST}
    check "non-root-user" id ${USERNAME}
    check "locale" [ $(locale -a | grep en_US.utf8) ]
    check "sudo" sudo echo "sudo works."
    check "zsh" zsh --version
    check "bash" bash --version
    check "wget" wget --version
    check "curl" curl --version
}

report_results() {
    if [ ${#FAILED[@]} -ne 0 ]; then
        echo -e "\n💥  Failed tests: ${FAILED[*]}"
        exit 1
    else
        echo -e "\n💯  All passed!"
        exit 0
    fi
}
