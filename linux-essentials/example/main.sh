#!/bin/bash

# set timer
SCRIPT_START=$SECONDS

# enable debug; print out the statements as they are being executed
set -x

# load vars
source 001_vars.sh

# load functions
source 002_functions.sh

# flags example
while getopts 'a:' flag; do
    case "${flag}" in
        a) DO_ACTION="${OPTARG}";;
    esac
done

# if example
if ${DO_ACTION}; then
    echo "${DO_ACTION}"
else
    echo "do nothing DO_ACTION, is ${DO_ACTION}"
fi

# for loop examples
## array
for host in ${HOST_ARRAY[@]}; do
    create_host_project_dir ${host}
done

## map
for item in "${!HOST_PURPOSE[@]}"; do
  assign_purpose ${item} ${HOST_PURPOSE[$item]} 
done

sleep 7

# output duration before exit
echo $(($SECONDS - $SCRIPT_START))