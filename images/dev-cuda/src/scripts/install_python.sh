#!/bin/bash

set -e


# Parse arguments
while [ $# -gt 0 ]; do
    case "$1" in
        --python-version|-p)
            PYTHON_VERSION=${2:-3.10}
            shift
            ;;
        --pyenv-root|-r)
            PYENV_ROOT=${2:-/.pyenv}
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [options]"
            echo "Options:"
            echo "  --python-version, -p: The version of Python to install, defaults to 3.10"
            exit 0
            ;;
        *)
            echo "Unrecognized argument: $1"
            exit 1
            ;;
    esac
    shift
done


curl https://pyenv.run | bash

if [ -n "$(which bash)" ]; then
    echo "Detected bash, adding pyenv to bash profile"

    {
        echo "export PYENV_ROOT=\"${PYENV_ROOT:-/.pyenv}\""
        # shellcheck disable=SC2016
        echo 'command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"'
        # shellcheck disable=SC2016
        echo 'eval "$(pyenv init -)"'
    } >> "$HOME/.bash_profile"
fi

if [ -n "$(which zsh)" ]; then
    echo "Detected zsh, adding pyenv to zsh profile"

    {
        echo "export PYENV_ROOT=\"${PYENV_ROOT:-/.pyenv}\""
        # shellcheck disable=SC2016
        echo "command -v pyenv >/dev/null || export PATH=\"$PYENV_ROOT/bin:$PATH\""
        # shellcheck disable=SC2016
        echo 'eval "$(pyenv init -)"'
    } >> "$HOME/.zshrc";
fi

if [ -n "$(which fish)" ]; then
    echo "Detected fish, adding pyenv to fish profile"

    set -Ux PYENV_ROOT "$PYENV_ROOT"
    fish_add_path "$PYENV_ROOT/bin"

    echo 'pyenv init - | source' >> "$HOME/.config/fish/config.fish";
fi

pyenv install "${PYTHON_VERSION}" && pyenv global "${PYTHON_VERSION}"
