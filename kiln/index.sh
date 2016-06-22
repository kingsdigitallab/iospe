#!/bin/bash

# Usage:     ./index.sh -i SERVER_INSTANCE -s SERVER_URL
# Example:   ./index.sh -i stg -s iospe-stg.cch.kcl.ac.uk
# if -i and -s  not used, it defaults to local server instance and localhost

SERVER_URL="http://localhost:9999"
SERVER_PATH="admin/solr/index/tei/tei/inscriptions"

SERVER_INSTANCE="local"

SLEEP_TIME=30

while getopts ":i:s:w:" optval "$@"
do
    case $optval in
        "i")
            SERVER_INSTANCE="$OPTARG"
            ;;
        "s")
            SERVER_URL="$OPTARG"
            ;;
        "w")
            SLEEP_TIME="$OPTARG"
            ;;
        *)
            errormsg="Unknown parameter or option error with option - $OPTARG"
            echo $errormsg
            exit -1
            ;;
    esac
done

if [[ $SERVER_INSTANCE =~ dev|stg|liv ]]; then
    echo "Stopping tomcat6-"$SERVER_INSTANCE
    sudo service tomcat6-$SERVER_INSTANCE stop

    echo 
    echo "Backing up the previous index"
    tar -czf index.tar.gz webapps/solr/data/index

    echo 
    echo "Removing the previous index"
    rm -rf webapps/solr/data/index
    echo 

    echo "Starting tomcat6-"$SERVER_INSTANCE
    sudo service tomcat6-$SERVER_INSTANCE start

    echo 
    echo "Waiting for the index directory to be created"
    sleep 15
fi

counter=0

mkdir -p _tmp
rm -rf _tmp/*

for f in webapps/ROOT/content/xml/tei/inscriptions/*.xml
do
    counter=$((counter + 1))

    filename=$(basename "$f")
    filename="${filename%.*}"

    if [[ $filename =~ ^[5P]{1}.*$ ]]; then
        echo $SERVER_URL/$SERVER_PATH/$filename.html
        wget -q --directory-prefix _tmp --timeout=0 $SERVER_URL/$SERVER_PATH/$filename.html
    fi

    if [[ $((counter % 100)) = 0 ]]; then
        echo "Pausing for $SLEEP_TIME second(s)..."
        sleep $SLEEP_TIME
    fi
done

echo 
echo "Indexing finished, checking for errors..."
grep -Ri --colour=always OutOfMemoryError _tmp || echo "No errors found"
