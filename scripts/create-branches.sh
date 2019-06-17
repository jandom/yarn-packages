#!/usr/bin/env bash

set -e

BRANCH=$(git symbolic-ref --short HEAD)

echo "[Packages] Creating branches..."
for package in $(cat packages/packages.txt); do
  BRANCH_NAME="packages/${package}"
  BRANCH_EXISTS=$(git show-ref refs/heads/$BRANCH_NAME || true)
  if [ ! -n "$BRANCH_EXISTS" ]; then
    git checkout -b "$BRANCH_NAME"
  fi
  git checkout $BRANCH
done

echo "[Packages] Running yarn updates and commiting..."
for package in $(cat packages/packages.txt); do
  BRANCH_NAME="packages/${package}"
  git checkout "$BRANCH_NAME"
  YARN_EXIT=$(yarn add $package || true)
  git add package.json yarn.lock
  STAGED_FILES=$(git diff --cached)
  if [ -n "$STAGED_FILES" ]; then
    git commit -m "Updated ${package}"
  fi
  git checkout $BRANCH
done
