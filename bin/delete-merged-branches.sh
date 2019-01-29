#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset

if [[ ! -d .git ]]; then
  echo 'must be in a git-managed directory'
  exit 1
fi

# Prevent egrep from SIGPIPE'ing hard on us.
set +o pipefail
branches=$(git branch --merged master | sed 's/^\*\{0,1\} \{1,\}//' | egrep -v '(origin/)?master' | paste -s -d' ' -)
set -o pipefail

if [[ -z "${branches}" ]]; then
  echo "everything is merged."
  exit 0
fi

echo "merged branches:"
echo
echo ${branches} | tr ' ' '\n'
echo
read -p "press return to delete the branches "

for br in ${branches}; do
  git branch --delete "${br}"
done
