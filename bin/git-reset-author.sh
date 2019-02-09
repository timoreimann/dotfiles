#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

readonly EMAILS_FILE="${HOME}/.secrets/emails"

usage() {
  echo "usage: $(basename "$0") work|private|<email address>" >&2
}

if [[ ! -f "${EMAILS_FILE}" ]]; then
  echo "file \"${EMAILS_FILE}\" containing email addresses does not exist" >&2
fi

source "${EMAILS_FILE}"

readonly WORK_EMAIL
readonly PRIVATE_EMAIL

if [[ -z ${WORK_EMAIL:-} ]]; then
  echo "environment variable WORK_EMAIL must be set" >&2
  usage
  exit 1
fi

if [[ -z ${PRIVATE_EMAIL:-} ]]; then
  echo "environment variable PRIVATE_EMAIL must be set" >&2
  usage
  exit 1
fi

if [[ $# -ne 1 ]]; then
  echo "unsufficient number of arguments" >&2
  usage
  exit 1
fi

readonly author_type="$1"
email_address=

case "${author_type}" in
  work)
    email_address="${WORK_EMAIL}"
    ;;
  private)
    email_address="${PRIVATE_EMAIL}"
    ;;
  *)
    if [[ ! "${author_type}" =~ ^.+@.+\.[^.]+$ ]]; then
      echo "not a valid email address: ${author_type}"
      usage
      exit 1
    fi
    email_address="${author_type}"
    ;;
esac
readonly email_address

echo "resetting author information of HEAD to ${email_address}"
AUTHOR="${email_address}" GIT_AUTHOR_EMAIL="${email_address}" GIT_COMMITTER_EMAIL="${email_address}" git ci-amend --allow-empty -C HEAD --reset-author
