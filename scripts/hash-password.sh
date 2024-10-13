#!/usr/bin/env bash

# Utility to hash a linux user password
# No need to reveal password on the CLI

set -euo pipefail

if ! command -v openssl >/dev/null 2>&1; then
	echo "Openssl is not installed"
	exit 1
fi

echo -e "\n\033[33mHash a password using SHA512\033[0m\n"
read -sp "Enter your password: " password
echo

readonly salt=$(openssl rand -base64 16)

openssl passwd -6 -salt "${salt}" "${password}"