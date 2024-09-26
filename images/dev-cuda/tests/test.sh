#!/bin/bash

source test_utils.sh

check_common

check "python_avaliable" python --version
check-exit "pyenv_installed" "$HOME/.pyenv"
check-exit "cuda_installed" "/usr/local/cuda"

report_results
