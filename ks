#!/usr/bin/env bash

#Exit the script if any individual command fails
set -o errexit

#Un-comment this next line if you want to see exactly what this script is doing
#set -o xtrace

function printUsage {
    echo "COMMAND: ks - Kills a screen session. Find session IDs with 'screen -ls'"
    echo "USAGE: ks <session ID>"
}

if [[ $# != 1 ]]
	then printUsage
	else
        screen -X -S "${1}" kill
fi