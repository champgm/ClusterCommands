#!/usr/bin/env bash

#Exit the script if any individual command fails
set -o errexit

#Exit the script if it tries to use any undeclared variables
set -o nounset

#Un-comment this next line if you want to see exactly what this script is doing
set -o xtrace

function printUsage {
    echo "COMMAND: rechup - Runs a jar with hadoop and a bunch of extra options. Output is directed to file."
    echo "USAGE: rechup <jar name> \"<command and parameters in quotes>\" <output file name>"
}

if [[ $# != 3 ]]
	then printUsage
		exit 1
	else

        currentDirectory=$(pwd)
        export HADOOP_CLIENT_OPTS='-XX:MaxPermSize=512m  -Xmx4g -Dgenerate.dag=true -Dhttps.protocols=TLSv1'
        export HADOOP_CLASSPATH="$currentDirectory"'/'"${3}"
        childOpts="-Xmx${1}g -Xms${1}g -XX:MaxPermSize=512m"
        #The first argument in childOpts needs to be ~2gb less than mapred.job.map.memory.mb and mapred.job.reduce.memory.mb
        nohup hadoop jar "${3}" -D mapred.child.java.opts="${childOpts}" -D mapred.map.java.opts="${childOpts}" -D mapred.reduce.java.opts="${childOpts}" -D mapred.job.map.memory.mb="${2}000" -D mapred.job.reduce.memory.mb="${2}000" "${4}" 2> "${5}" 1> "${5}" &
fi
