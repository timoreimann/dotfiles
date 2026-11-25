#!/usr/bin/env bash

set -euo pipefail

usage() {
  echo "usage: $(basename "$0") [<email address>]" >&2
}

case "${1:-}" in
  -h|--help)
    usage
    exit 1
    ;;
  "")
    if ! email_address="$(git config --get user.email)" || [[ -z "${email_address}" ]]; then
      echo "error: git config user.email is not set" >&2
      exit 1
    fi
    ;;
  *)
    email_address="$1"
    ;;
esac
readonly email_address

echo "resetting author information of HEAD to ${email_address}"
AUTHOR="${email_address}" GIT_AUTHOR_EMAIL="${email_address}" GIT_COMMITTER_EMAIL="${email_address}" git ci-amend --allow-empty -C HEAD --reset-author
