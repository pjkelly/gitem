#!/usr/bin/env bats

load test_helper
load "$BATS_TEST_DIRNAME/../lib.sh"

add_and_commit() {
  echo "$1" > $1
  git add $1
  git commit -m "Added ${1}"
}

modify_and_commit() {
  local timestamp=date;
  echo "$1 $timestamp" > $1
  git add $1
  git commit -m "Modified ${1}"
}

setup() {
  export ORIGIN_REPO_PATH="${TMP}/origin"
  export LOCAL_REPO_PATH="${TMP}/local"

  mkdir -p "${ORIGIN_REPO_PATH}"
  cd $ORIGIN_REPO_PATH
  git init
  add_and_commit 'Readme.md'

  git clone $ORIGIN_REPO_PATH $LOCAL_REPO_PATH
}

@test "Check that the rebase worked as expected" {
  cd $LOCAL_REPO_PATH
  git branch feature-branch
  git checkout feature-branch
  add_and_commit 'Changelog.md'
  modify_and_commit 'Readme.md'

  cd $ORIGIN_REPO_PATH
  add_and_commit 'Contributors.md'

  cd $LOCAL_REPO_PATH
  add_and_commit 'Help.md'

  update_feature_branch master

  run git log --format=oneline
  assert_line_contains 0 'Added Help.md'
  assert_line_contains 1 'Modified Readme.md'
  assert_line_contains 2 'Added Changelog.md'
  assert_line_contains 3 'Added Contributors.md'
  assert_line_contains 4 'Added Readme.md'
}

