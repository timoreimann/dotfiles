#!/usr/bin/env bash
set -o errexit
set -o nounset
set -o pipefail

WITH_PV=
if type pv > /dev/null; then
  WITH_PV=1
fi
readonly WITH_PV

if ! type bzip2 > /dev/null; then
  echo 'bzip2 must be installed' >&2
  exit 1
fi

if [[ $# -ne 2 ]]; then
  echo "usage: $(basename "$0") <image> <ssh destination>" >&2
  exit 1
fi

readonly IMAGE="$1"
readonly SSH_DEST="$2"

if [[ "${WITH_PV}" ]]; then
  docker save "${IMAGE}" | bzip2 | pv | ssh "${SSH_DEST}" 'bunzip2 | docker load'
else
  docker save "${IMAGE}" | bzip2 | ssh "${SSH_DEST}" 'bunzip2 | docker load'
fi
