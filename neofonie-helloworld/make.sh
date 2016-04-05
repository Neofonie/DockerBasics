#!/bin/bash
set -Eeuo pipefail
IFS=''

readonly registry='neofoniegmbh'
readonly buildpath='.'
readonly dockerfile=${buildpath}/Dockerfile
readonly image='hello-world'

init () {
    trap "clean" EXIT
}

# Clean up environment
clean () {
    echo "Cleaning up ..."
    #[ -z "${cid:-}" ] || docker rm -v $cid
    echo "Cleaned!"
}

fail () {
    echo Failed:
    echo $*
    exit 1
}

all () {
    image
}

image () {
    echo Building Docker image...
    docker build -f ${buildpath}/Dockerfile -t ${image}:local ${buildpath}
}

release () {
    all
    echo Releasing...

    latest_tag=$registry/$image:latest
    echo "Latest Tag: ${latest_tag}"

    set -x
    docker tag -f $image:local $latest_tag
    docker push $latest_tag
    set +x
}

main () {
    init
    ${1:-all}
}

main "$@"
