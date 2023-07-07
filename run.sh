#!/bin/bash

ansible-playbook -i inventory --extra-vars "@extra_vars.yml" dev-vm.yaml -K
