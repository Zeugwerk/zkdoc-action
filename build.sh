#!/usr/bin/env bash

BRANCH=$GITHUB_HEAD_REF
if [ "$BRANCH" == "" ]; then
    BRANCH=$(echo $GITHUB_REF | sed 's/refs\/heads\///');
fi;
#BRANCH=$(echo -n $BRANCH | tr "/" "-")

curl -s --fail --show-error -N -G --data-urlencode "scm=$GITHUB_SERVER_URL/$GITHUB_REPOSITORY" --data-urlencode "sha=$GITHUB_SHA" --data-urlencode "branch=$BRANCH" --data-urlencode "username=$1" --data-urlencode "password=$2" --data-urlencode "filepath=$3" --data-urlencode "working-directory=$4" --data-urlencode "method=zkdoc" https://operations.zeugwerk.dev/api.php | tee response
status="$(tail -n1 response)"
artifact="$(tail -n2 response | head -n1 | cut -d '=' -f2)"

# Status is not SUCCESS and not UNSTABLE
if [[ "$status" != *"HTTP/1.1 201"* ]] && [[ "$status" != *"HTTP/1.1 202"* ]]; then
    exit 1
fi

# We got an artifact that we can extract
if [[ "$status" = *"HTTP/1.1 202"* ]]; then
    wget -q --user=$1 --password=$2 $artifact -o 'artifact.zip'
    if [[ $? -ne 0 ]]; then
        exit 202
    fi
    
    # return code 0 means no errors
    # return code 1 means there was an error or warning, but processing was successful anyway
    unzip -q -o 'artifact.zip'
    if [[ $? -gt 1 ]]; then
        exit 202
    fi
fi
