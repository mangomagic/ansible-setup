# Bootstrap Ansible for Ubuntu Server

Inital setup of an Ubuntu web server to use ansible.

* Install ansible if not present
* Create user ansible will be using, supplying public SSH key and password hashed with SHA512
* Setup sshd with secure settings
* Set firewall rules

### Setup

Clone this repo on a fresh install of Ubuntu. Run the bash script with root privileges and it will execute ansible playbooks locally to setup the services above.

You will need to populate the following files with your desired credentials first:

* `./files/password_hash.txt`
* `./files/public_key.txt`

There is a utility to hash a password:

```bash
./scripts/hash-password.sh

Hash a password using SHA512

Enter your password: Hello World!

861844d6704e8573fec34d967e20bcfef3d424cf48be04e6dc08f2bd58c729743371015ead891cc3cf1c9d34b49264b510751b1ff9e537937bc46b5d6ff4ecc8  -
```

Setup ansible:

```bash
./scripts/ansible-setup.sh
```

### Test

To test the ansible code in a docker container run:

```bash
./test/run-test.sh
```