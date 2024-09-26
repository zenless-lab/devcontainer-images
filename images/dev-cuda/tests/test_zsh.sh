#!/bin/bash

source test_utils.sh

check "python_avaliable_in_zsh" zsh -c "python --version"
check-exit "pyenv_installed" "$HOME/.pyenv"
check-exit "cuda_installed" "/usr/local/cuda"

report_results
