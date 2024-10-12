#!/usr/bin/env bash

set -euo pipefail

if command -v ansible-playbook >/dev/null 2>&1; then
    apt-get update
    apt-get install ansible -y
fi

ansible-playbook playbooks/config_user.yml

ansible-playbook playbooks/config_sshd.yml

ansible-playbook playbooks/config_ufw.yml

echo "ansible-setup finished"