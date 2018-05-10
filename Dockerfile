FROM williamyeh/ansible:ubuntu16.04
VOLUME /code
ADD . /code
WORKDIR /code

# These arguments assume the local inventory and extra_vars is already created.
CMD ["-i", "inventory", "--extra-vars", "@extra_vars.yml", "dev-vm.yaml"]
ENTRYPOINT ["ansible-playbook"]
