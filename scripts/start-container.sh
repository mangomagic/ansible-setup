#!/usr/bin/env bash

set -euo pipefail

# Pass value "test" as parameter to only test
# ssh connectivity and then stop container
readonly test_container="${1:-false}"

# Docker image and container name
readonly docker_name="ansible-environment"

# Set build directory
readonly build_dir="$(dirname $(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd))"

# Build docker image
docker build -t "$docker_name" "$build_dir"

# Run container with "--cap-add NET_ADMIN" allowing networking management
docker run -d --rm --cap-add NET_ADMIN -P --name "$docker_name" "$docker_name"

# Stop container function
stop_container() {
    local exit_code=$?
    printf "\nCleaning up container..."
    docker stop "$docker_name"
    exit $exit_code
}

# Call stop_container function on signal
trap 'stop_container' SIGHUP SIGINT SIGQUIT SIGABRT

# Conditionally remove container on exit
[[ "${test_container}" == "test" ]] && trap 'stop_container' EXIT

# Wait for ansible setup to finish
readonly phrase="ansible-setup finished"

# Output docker logs and use grep to break on phrase
while read log_line; do

    echo "$log_line"

    { set +e; echo "$log_line" | grep -qF "$phrase"; }

    [ $? -eq 0 ] && break

done < <(docker logs -f "$docker_name" 2>&1)

# Test SSH connection to container
echo -e "\nTest SSH...\n"

# SSH user
readonly ssh_user="mangomagic"

# Get local SSH port chosen by docker
readonly ssh_port=$(docker container port "$docker_name" 22 | cut -d ':' -f 2)

# Test SSH connection to container (also test sudo)
ssh -q \
    -p "$ssh_port" \
    -o UserKnownHostsFile=/dev/null \
    -o StrictHostKeyChecking=no \
    "$ssh_user"@localhost 'sudo echo -e "\033[32mSuccessfully connected via SSH\033[0m"; exit'

[ $? -ne 0 ] && echo -e "\033[31mFailed to connect via SSH\033[0m"

if [[ "$test_container" != "test" ]]; then
    if docker ps --format '{{.Names}}' | grep -q "^$docker_name$" ; then

        readonly container=$(docker ps | grep "$docker_name")

        echo -e "\nContainer: $container"

        echo -e "\nTo stop: \033[33mdocker stop $docker_name\033[0m"

        echo -e "\nTo connect: \033[33mssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no $ssh_user@localhost -p $ssh_port\033[0m"
    else
        echo -e "\nContainer is not running"
    fi
fi