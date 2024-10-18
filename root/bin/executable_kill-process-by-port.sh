#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset

if [[ $# -ne 1 ]]; then
  echo "usage: $(basename "$0") <port>" >&2
  exit 1
fi

declare -ir port="$1"

pids="$(lsof -i tcp:${port} | tail -n +2 | awk '{print $2}' | paste -s -d' ' -)" || {
  echo "no process(es) running on port ${port}"
  exit 0
}
readonly pids

kill -9 ${pids}
echo "killed."
