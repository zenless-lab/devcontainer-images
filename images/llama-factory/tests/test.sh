#!/bin/bash

source test_utils.sh

check_common

check "python_available" python --version
check-dir-exists "llama_factory_cloned" "/workspace/llama-factory"

check "llama_factory_installed" llamafactory-cli

report_results
