# Bootstrap Ansible for Ubuntu Server

Inital setup of an Ubuntu server to use ansible.

* Install ansible if not present
* Create user ansible will be using, supplying public SSH key and password hashed with SHA512
* Setup sshd with secure settings
* Set firewall rules
* Install fail2ban (if the execution environment is not Docker)

## Setup

### Clone Repo

Clone this repo ideally on a fresh install of Ubuntu.

### Set Credentials

You will need to populate the following files with your desired credentials first:

* `./files/public_key.txt # e.g. cat ~/.ssh/id_rsa.pub >./files/public_key.txt`
* `./files/password_hash.txt # See ./scripts/hash-password.sh`

To hash a password:

```bash
./scripts/hash-password.sh
```

Follow the on screen prompts, place the resulting hash in `./files/password_hash.txt`

```bash
Hash a password using SHA512

Enter your password: <PASSWORD>
$6$CU1vIZD/k5CfzLQf$Odumj2JzFI4WhDiR0AdSnrN.4QMiH7y2khzQo92UUJu5AKCpk5OOZNxUsETfamzTe7ku27.Bju3UOnfnfHlIg/
```

### Run Ansible Setup

Run the bash script with root privileges and it will execute ansible playbooks locally to setup the required services.

Setup using the setup bash script:

```bash
./scripts/ansible-setup.sh
```

Alternatively run the following ansible commands in order:

```bash
ansible-playbook playbooks/config_user.yml

ansible-playbook playbooks/config_sshd.yml

ansible-playbook playbooks/config_ufw.yml

ansible-playbook playbooks/config_fail2ban.yml
```

The ansible user should now be able to SSH into the remote server.

## Local Environment

The public key must be set correctly in `./files/public_key.txt` and the private key present for the local user.

Setup the container and keep it running in the background for development, debugging or testing.

```bash
./scripts/start-container.sh
```

## Local Test

Runs the environment as above but the container will exit after testing SSH connectivity:

```bash
./scripts/start-container.sh test
```