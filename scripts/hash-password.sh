#!/usr/bin/env bash

set -euo pipefail

echo -e "\n\033[33mHash a password using SHA512\033[0m\n"
read -sp "Enter your password: " password
echo

readonly os_name=$(uname)
echo

if [[ "$os_name" == "Darwin" ]]; then
	echo -n "${password}" | shasum -a 512
else
	echo -n "${password}" | sha512sum
fi