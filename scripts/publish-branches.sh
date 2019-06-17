#!/usr/bin/env bash

set -e

if [ -z "$1" ]; then
    echo "No Github token supplied"
fi

TOKEN="$1"
BRANCH=$(git symbolic-ref --short HEAD)

echo "[Packages] Pushing branch name to remote..."
for package in $(cat packages/packages.txt); do
  BRANCH_NAME="packages/${package}"
  git checkout "$BRANCH_NAME"
  git push origin "$BRANCH_NAME"
  git checkout $BRANCH
done

echo "[Packages] Creating PRs"
curl -H "Authorization: token $TOKEN" https://api.github.com
for package in $(cat packages/packages.txt); do
  BRANCH_NAME="packages/${package}"
  echo $package
  curl -H "Authorization: token $TOKEN" \
    -X POST https://api.github.com/repos/Labstep/web/pulls \
    -d'{
      "title": "Package update '${package}'",
      "body": "Automatically created by the packages.sh script",
      "head": "'${BRANCH_NAME}'",
      "base": "'${BRANCH}'"
    }'
done
