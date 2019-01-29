#!/bin/bash

if [[ $# -lt 1 ]]; then
	echo "usage: $(basename $0) <docker image identifier> [arguments]"
	exit 1
fi

docker_image="$1"
shift

docker run --rm -it --entrypoint /bin/bash "$docker_image" "$@"
