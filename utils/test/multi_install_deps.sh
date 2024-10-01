set -e

PREINSTALL_PKGS=$@


if [ "$(id -u)" -eq 0 ]; then
    if [ -f /etc/os-release ] && grep -q '^ID=alpine' /etc/os-release; then apk add --no-cache ${PREINSTALL_PKGS}; fi
    if [ -f /etc/os-release ] && grep -q '^ID=debian' /etc/os-release; then apt-get update && apt-get install -y ${PREINSTALL_PKGS}; fi
    if [ -f /etc/os-release ] && grep -q '^ID=ubuntu' /etc/os-release; then apt-get update && apt-get install -y ${PREINSTALL_PKGS}; fi
    if [ -f /etc/os-release ] && grep -q '^ID=fedora' /etc/os-release; then dnf install -y ${PREINSTALL_PKGS}; fi
    if [ -f /etc/os-release ] && grep -q '^ID=centos' /etc/os-release; then yum install -y ${PREINSTALL_PKGS}; fi
    if [ -f /etc/os-release ] && grep -q '^ID=opensuse' /etc/os-release; then zypper install -y ${PREINSTALL_PKGS}; fi
else
    if [ -f /etc/os-release ] && grep -q '^ID=alpine' /etc/os-release; then sudo apk add --no-cache ${PREINSTALL_PKGS}; fi
    if [ -f /etc/os-release ] && grep -q '^ID=debian' /etc/os-release; then sudo apt-get update && sudo apt-get install -y ${PREINSTALL_PKGS}; fi
    if [ -f /etc/os-release ] && grep -q '^ID=ubuntu' /etc/os-release; then sudo apt-get update && sudo apt-get install -y ${PREINSTALL_PKGS}; fi
    if [ -f /etc/os-release ] && grep -q '^ID=fedora' /etc/os-release; then sudo dnf install -y ${PREINSTALL_PKGS}; fi
    if [ -f /etc/os-release ] && grep -q '^ID=centos' /etc/os-release; then sudo yum install -y ${PREINSTALL_PKGS}; fi
    if [ -f /etc/os-release ] && grep -q '^ID=opensuse' /etc/os-release; then sudo zypper install -y ${PREINSTALL_PKGS}; fi
fi
