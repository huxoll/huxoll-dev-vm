# huxoll-dev-vm
My personal DevVM configuration and tools.

Assumes Ansible is installed, on a Linux box.

# Core workstation setup #

* Create an ssh key pair ( `ssh-keygen` ) and add the public half your GitHub account or copy one you already have into your ~/.ssh/id_rsa file (don't forget to `chmod 400` it)
* Install git (if you haven't already) `sudo apt-get install git`
* Clone the vm provisioning repo: `git clone git@github.com:huxoll/huxoll-dev-vm.git ~/provisioning`
* Run `ansible-playbook -K ~/provisioning/dev-vm.yaml`, enter your user's password when prompted so it can sudo.
* Source your ~/.bashrc to pick up new environment settings: `. ~/.bashrc`
* Configure git:

```
#!bash

git config --global user.name "Your Name"
git config --global user.email" yourname@company.com"

```
