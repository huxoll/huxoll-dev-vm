# huxoll-dev-vm

My personal DevVM configuration and tools.  This is a lot of tools for generic
modern development, it's not tuned for a particular language or environment.
The repo name is a bit of a minsomer; I use this natively on a local workstation
as well as on VMs.  You may find it useful as well, I have made some attempt to
externalize the opinionated/personalized bits to settings that can be easily
modified.

## Build Status

[![Build Status](https://travis-ci.com/huxoll/huxoll-dev-vm.svg?branch=master)](https://travis-ci.com/huxoll/huxoll-dev-vm)
[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Prerequisites (OSX)

I rely on Homebrew, so it should be installed. See: https://brew.sh

Homebrew will also install the XCode command line tools if not already installed.

## Prerequisites (General)

Assumes Ansible is installed, on a Linux or OSX workstation.

If ansible is not installed, try this:
(Ubuntu 14.04)

``` bash
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update
sudo apt-get install ansible
```

(Ubuntu 16+)

``` bash
sudo apt install -y python-pip git
sudo pip install ansible
```

(OSX)

```
brew install ansible
```

## Core workstation setup

* Obtain a shell on the target machine (this install is assumed to run locally)
* Install git (if you haven't already) `sudo apt-get install git` or `brew install git`
* Clone this repo: `git clone https://github.com/huxoll/huxoll-dev-vm.git`
* (Or, clone the repo via SSSH: `git clone git@github.com:huxoll/huxoll-dev-vm.git` with appropriate SSH key)
* Change to the directory: `cd huxoll-dev-vm`
* Copy the example inventory file and customize variables: `cp inventory.sample inventory && vi inventory`
* Copy the example extra variables file and customize variables if you wish: `cp extra_vars.yml.sample extra_vars.yml && vi extra_vars.yml`
* Run `ansible-playbook -i inventory --extra-vars "@extra_vars.yml" dev-vm.yaml -K`, enter your user's password when prompted so it can sudo.
* Source your ~/.bashrc to pick up new environment settings: `. ~/.bashrc`

There you have it, some basic development tools on a box or virtual machine.

## Features

* Docker support
* Git config with some useful aliases
* Specialized grep wrappers for searching in code (htmlgrep for HTML, pygrep for Python, jsgrep for JS, etc.)
* Useful inputrc options (who ever wants a case sensitive file completion? Pff.)
* tmux customizations
* command prompt tagged with Git info
* Interpreters for java, python, ruby, go (by default)

## Target Infrastructure Platforms

* MacOSX (only tested on 10.11-10.13)
* Ubuntu Linux (14.04-16.10, VM or native)

## Target Development Environments

* Generic (Atom, Sublime, Git, command prompt features)
* Node.JS
* Python
* Ruby
* Golang
