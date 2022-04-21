#!/bin/bash

usage() {
    echo "Usage: $0 [-is] [-f FILE]" 1>&2; 
    exit 1;
}

while getopts ":f:is" options; do
    case "${options}" in       
        f) FILE=${OPTARG} ;;
        i) NO_INTERACTIVE=1 ;;
        s) SKIP_BUILD=1 ;;
        :)
            echo "Error: -$OPTARG requires an argument"
            usage
            ;;
        *)
            usage
            ;;
    esac
done


if [[ -z "${FILE-}" ]]; then
    FILES=( *.sql )
    FILE=${FILES[0]}
fi

if [[ ! -e $FILE ]]; then
    echo "Error: $FILE does not exist"
    exit 2
fi

docker version > /dev/null 2>&1 || {
    echo "Error: Docker engine is not running"
    exit 3
}

echo "==> Using sql file $FILE"

if [[ $SKIP_BUILD -ne 1 ]]; then
    echo "==> Building image..."
    docker build -t fsad . || {
        echo "Error: Docker build failed"
        exit 4
    }
fi

if [[ $NO_INTERACTIVE -ne 1 ]]; then
    echo "==> Starting container..."
    docker run -it -v "$(pwd)"/"${FILE}":/app/file.sql --name=fsad fsad
else
    echo "==> Starting container in non-interactive mode..."
    docker run -e NO_INTERACTIVE=1 -v "$(pwd)"/"${FILE}":/app/file.sql --name=fsad fsad
fi

echo "==> Removing container..."
docker rm "$(docker ps -aqf "name=^fsad$")" > /dev/null 2>&1
