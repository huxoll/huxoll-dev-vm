#!/bin/bash

ARGS=""

while getopts "hqvd" arg; do
    case "${arg}" in
        h)      echo >&2 "Usage: $0 [-h]..."
                exit 1;;
        q)
            ARGS="-q $ARGS"
            ;;
        v)
            ARGS="$ARGS -vv"
            ;;
        d)
            ARGS="$ARGS --check"
            ;;
    esac
done

ansible-playbook -i inventory --extra-vars "@extra_vars.yml" dev-vm.yaml -K $ARGS
