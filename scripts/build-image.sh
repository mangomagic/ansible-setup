#!/usr/bin/env bash

# Build docker image only

set -euo pipefail

# Docker image and container name
readonly docker_name="ansible-environment"

# Set build directory
readonly build_dir="$(dirname $(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd))"

# Build docker image
docker build -t "$docker_name" "$build_dir"