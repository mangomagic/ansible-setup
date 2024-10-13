#!/usr/bin/env bash

set -euo pipefail

# Get the directory of the script
readonly script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo $script_dir

docker build -t ansible-setup-test -f "${script_dir}/Dockerfile" $(dirname "${script_dir}")

docker run -d --rm --cap-add NET_ADMIN -P --name ansible-setup-test ansible-setup-test

# Stop container function
stop_container() {
    local exit_code=$?
    printf "Cleaning up container..."
    docker stop ansible-setup-test
    exit $exit_code
}

# Call stop_container function on exit
trap 'stop_container' SIGHUP SIGINT SIGQUIT SIGABRT

# Wait for ansible setup to finish
readonly phrase="ansible-setup finished"

# Use docker logs and grep to wait for the phrase
while read log_line; do

    echo "$log_line"

    { set +e; echo "$log_line" | grep -qF "$phrase"; }

    [ $? -eq 0 ] && break

done < <(docker logs -f ansible-setup-test 2>&1)

echo -e "\nTest SSH...\n"

readonly ssh_user="mangomagic"

# Get local SSH port chosen by docker
readonly port=$(docker container port ansible-setup-test 22 | cut -d ':' -f 2)

# Test SSH connected successfully (also test sudo)

ssh -p "$port" -q -o StrictHostKeyChecking=no "$ssh_user"@localhost 'sudo echo -e "\033[32mSuccessfully connected via SSH\033[0m"; exit'

[ $? -ne 0 ] && echo -e "\033[31mFailed to connect via SSH\033[0m"

echo

stop_container