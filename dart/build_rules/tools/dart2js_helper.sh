#!/bin/bash
set -e

target="$1"
expected_count="$2"
out_dir="$(dirname "$3")"
out_js="$(basename "$3")"
shift 3

"$@"

actual_count=$(find "$out_dir" -name "$out_js_*.part.js" -maxdepth 1 | wc -l | sed -e 's/^[ \t]*//')
if [[ "$actual_count" != "$expected_count" ]]; then
  echo "ERROR: Expected $expected_count deferred library outputs, but found $actual_count."
  echo "Set deferred_lib_count=$actual_count on $target."
  exit 1
fi
