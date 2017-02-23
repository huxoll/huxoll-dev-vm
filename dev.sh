#!/bin/bash

usage() {
    echo "Usage: $0 [platform] [git-url]"
    echo -e "\tplatform - Dev environment type, e.g. node, python, etc."
    echo -e "\tgit-url - Git URI of project to check out"
    echo -e "\t-w work-directory - Work directory to check out code"
    exit 1;
}

run_docker_platform() {
    cd platforms/${platform}
    docker-compose up
    docker-compose run ${platform} /bin/bash
}

# Initialize our own variables:
platform=""
git_url=""
verbose=""
work_dir="code"

OPTIND=1  # Reset in case getopts was used before.
while getopts "h?vp:g:w:" opt; do
    case "$opt" in
    h|\?)
        usage
        exit 0
        ;;
    v)  verbose=1
        ;;
    p)  platform=${OPTARG}
        ;;
    g)  git_url=${OPTARG}
        ;;
    w)  work_dir=${OPTARG}
        ;;
    esac
done

shift $((OPTIND-1))
OPTIND=1
[[ -z ${platform} ]] && [[ $(( $# - $OPTIND )) -lt 0 ]] && usage
[[ -z ${platform} ]] && platform=${@:$OPTIND:1} && shift

[[ -z ${git_url} ]] && [[ $(( $# - $OPTIND )) -lt 0 ]]
[[ -z ${git_url} ]] && git_url=${@:$OPTIND:1} && shift

[ "$1" = "--" ] && shift

[[ -n ${verbose} ]] && echo "verbose=$verbose, platform='$platform', git_url='$git_url', Leftovers: $@"

[[ -z ${platform} ]] && usage
[[ -n ${verbose} ]] && echo "Using platform ${platform}."

if [[ ! -d platforms/${platform} ]]; then
    echo "Unhandled platform ${platform}"
    echo "'platforms/${platform}' does not exist."
    exit 2
else
    echo "Using platform ${platform} from platforms/${platform}"
fi

if [[ -n $git_url ]]; then
    echo "Checkout out source from ${git_url} to ${work_dir}..."
    git clone -q ${git_url} ${work_dir}
fi


# Execute docker
pushd . >> /dev/null
run_docker_platform
popd >> /dev/null
