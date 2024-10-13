# Bootstrap Ansible for Ubuntu Server

Inital setup of an Ubuntu server to use ansible.

* Install ansible if not present
* Create user ansible will be using, supplying public SSH key and password hashed with SHA512
* Setup sshd with secure settings
* Set firewall rules

### Setup

Clone this repo on a fresh install of Ubuntu. Run the bash script with root privileges and it will execute ansible playbooks locally to setup the services above.

You will need to populate the following files with your desired credentials first:

* `./files/password_hash.txt`
* `./files/public_key.txt`

To hash a password:

```bash
./scripts/hash-password.sh
```

Follow the on screen prompts

```bash
Hash a password using SHA512

Enter your password: <PASSWORD>
$6$CU1vIZD/k5CfzLQf$Odumj2JzFI4WhDiR0AdSnrN.4QMiH7y2khzQo92UUJu5AKCpk5OOZNxUsETfamzTe7ku27.Bju3UOnfnfHlIg/
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