export TMP="$BATS_TEST_DIRNAME/tmp"

teardown() {
  rm -fr "$TMP"/*
}

assert() {
  if ! "$@"; then
    flunk "failed: $@"
  fi
}

flunk() {
  { if [ "$#" -eq 0 ]; then cat -
    else echo "$@"
    fi
  } | sed "s:${TMP}:\${TMP}:g" >&2
  return 1
}

assert_output_contains() {
  local expected="$1"
  echo "$output" | $(type -p ggrep grep | head -1) -F "$expected" >/dev/null || {
    { echo "expected output to contain $expected"
      echo "actual: $output"
    } | flunk
  }
}

assert_line_contains() {
  local line_number=$1;
  local expected="$2";
  local line="${lines[$line_number]}";

  echo "$line" | $(type -p ggrep grep | head -1) -F "$expected" >/dev/null || {
    { echo "expected output to contain $expected"
      echo "actual: $line"
    } | flunk
  }
}