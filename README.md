# huxoll-dev-vm
My personal DevVM configuration and tools.

Assumes Ansible is installed, on a Linux or OSX workstation.

If ansible is not installed, try this:
(Ubuntu 14.04)
```
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update
sudo apt-get install ansible
```
(OSX)
```
brew install ansible
```

# Core workstation setup #

* Install git (if you haven't already) `sudo apt-get install git`
* Clone this repo: `git clone https://github.com/huxoll/huxoll-dev-vm.git`
* (Or, clone the repo via SSSH: `git clone git@github.com:huxoll/huxoll-dev-vm.git` with appropriate SSH key)
* Change to the directory: `cd huxoll-dev-vm`
* Copy the example inventory file and customize variables: `cp inventory.sample inventory && vi inventory`
* Run `ansible-playbook -i inventory -K dev-vm.yaml`, enter your user's password when prompted so it can sudo.
* Source your ~/.bashrc to pick up new environment settings: `. ~/.bashrc`

There you have it, some basic development tools on a box or virtual machine.

# Features #

* Docker support
* Git config with some useful aliases
* Specialized grep wrappers for searching in code (htmlgrep for HTML, pygrep for Python, jsgrep for JS, etc.)
* Useful inputrc options (who ever wants a case sensitive file completion? Pff.)
* tmux customizations

