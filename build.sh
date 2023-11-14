#!/usr/bin/env bash

BRANCH=$GITHUB_HEAD_REF
if [ "$BRANCH" == "" ]; then
    BRANCH=$(echo $GITHUB_REF | sed 's/refs\/heads\///');
fi;

curl -s --show-error -N \
    -F "scm=$GITHUB_SERVER_URL/$GITHUB_REPOSITORY" \
    -F "sha=$GITHUB_SHA" \
    -F "branch=$BRANCH" \
    -F "username=$1" \
    -F "password=$2" \
    -F "filepath=$3" \
    -F "doc-folder=$4" \
    -F "working-directory=$5" \
    -F "method=zkdoc" \
    https://zeugwerk.dev/api.php | tee response

status="$(tail -n1 response)"
artifact="$(tail -n2 response | head -n1 | cut -d '=' -f2)"

# Status is not SUCCESS and not UNSTABLE
if [[ "$status" != *"HTTP/1.1 201"* ]] && [[ "$status" != *"HTTP/1.1 202"* ]]; then
    exit 1
fi

# We got an artifact that we can extract
if [[ "$status" = *"HTTP/1.1 202"* ]]; then
    wget -q --user=$1 --password=$2 -O 'artifact.zip' $artifact
    if [[ $? -ne 0 ]]; then
        exit 202
    fi
    
    # return code 0 means no errors
    # return code 1 means there was an error or warning, but processing was successful anyway
    unzip -q -o 'artifact.zip'
    echo "HTML Documentation extracted to archive/$4/html"
    if [[ $? -gt 1 ]]; then
        exit 202
    fi
fi
