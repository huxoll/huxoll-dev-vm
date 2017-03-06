#!/bin/bash

usage() {
    echo "Usage: $0 [platform] [git-url]"
    echo -e "\tplatform - Dev environment type, e.g. node, python, etc."
    echo -e "\tgit-url - Git URI of project to check out"
    echo -e "\t-w work-directory - Work directory to check out code"
    exit 1;
}

run_docker_platform() {
  # Suck in platform config and expose those as variables like "config_yamlvar"
  eval $(parse_yaml platforms/$platform.yml "config_")
  [[ -n ${verbose} ]] && echo "config_from: $config_from"
  tmp_dir=`mktemp -d`
  fill_template < platforms/docker-compose-template.yml > ${tmp_dir}/docker-compose.yml
  fill_template < platforms/Dockerfile-template > ${work_dir}/Dockerfile.dev

  [[ -n ${verbose} ]] && echo "docker compose file: ${tmp_dir}/docker-compose.yml"

  #cd $work_dir
  docker-compose -f ${tmp_dir}/docker-compose.yml build
  compose_out=$(docker-compose -f ${tmp_dir}/docker-compose.yml up -d 2>&1)
  if [[ $? -ne 0 ]]; then
    echo "Docker compose failed!"
    echo "${compose_out}"
    exit 1
  fi
  [[ -n ${verbose} ]] && echo "COMPOSE_OUT: ${compose_out} ##"
  built=0
  container=''
  while read -r line
  do
    if [[ "${built}" == "0" ]]; then
      built=$(echo $line | grep -ce "Creating .*$platform")
    fi
    if [[ "${built}" > '0' ]]; then
      echo "Built docker images."
    fi
    regex="Creating (.*$platform.*)"
    if [[ "${line}" =~ ${regex} ]]; then
      container="${BASH_REMATCH[1]}"
      echo "Got container: ${container}"
    fi
  done <<< "${compose_out}"
  docker exec -ti ${container} /bin/bash
  echo "All done: ${container}"
  docker-compose -f ${tmp_dir}/docker-compose.yml down
}

parse_yaml() {
   local prefix=$2
   local s='[[:space:]]*' w='[a-zA-Z0-9_]*' fs=$(echo @|tr @ '\034')
   sed -ne "s|^\($s\):|\1|" \
        -e "s|^\($s\)\($w\)$s:$s[\"']\(.*\)[\"']$s\$|\1$fs\2$fs\3|p" \
        -e "s|^\($s\)\($w\)$s:$s\(.*\)$s\$|\1$fs\2$fs\3|p"  $1 |
   awk -F$fs '{
      indent = length($1)/2;
      vname[indent] = $2;
      for (i in vname) {if (i > indent) {delete vname[i]}}
      if (length($3) > 0) {
         vn=""; for (i=0; i<indent; i++) {vn=(vn)(vname[i])("_")}
         printf("%s%s%s=\"%s\"\n", "'$prefix'",vn, $2, $3);
      }
   }'
}

fill_template() {
  IFS=''
  while read -r line ; do
      while [[ "$line" =~ (\$\{[a-zA-Z_][a-zA-Z_0-9]*\}) ]] ; do
          LHS=${BASH_REMATCH[1]}
          RHS="$(eval echo "\"$LHS\"")"
          line=${line//$LHS/$RHS}
      done
      echo "$line"
  done
  unset IFS
}

dir_resolve()
{
  cd "$1" 2>/dev/null || return $?
  echo "`pwd -P`"
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

if [[ ! -f platforms/${platform}.yml ]]; then
    echo "Unhandled platform ${platform}"
    echo "'platforms/${platform}.yml' does not exist."
    exit 2
else
    echo "Using platform ${platform} from platforms/${platform}"
fi

if [[ -n $git_url ]]; then
    echo "Checkout out source from ${git_url} to ${work_dir}..."
    git clone -q ${git_url} ${work_dir} || exit 1
fi

[[ -n ${verbose} ]] && echo "Using work directory '$work_dir'."
[[ ! -d ${work_dir} ]] && echo "No such directory '$work_dir'." && exit 1
work_dir=`( dir_resolve $work_dir )`
[[ -n ${verbose} ]] && echo "Using work directory '$work_dir'."

# Execute docker
pushd . >> /dev/null
run_docker_platform
popd >> /dev/null
