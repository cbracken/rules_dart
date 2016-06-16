#!/bin/bash
set -e
source "googletest.sh" || exit 1

# All sources are resolved relative to the $RUNFILES dir.
if [[ -n "$TEST_SRCDIR" ]]; then
  # use $TEST_SRCDIR if set.
  export RUNFILES="$TEST_SRCDIR"
elif [[ -z "$RUNFILES" ]]; then
  # canonicalize the entrypoint.
  pushd "$(dirname "$0")" > /dev/null
  abs_entrypoint="$(pwd -P)/$(basename "$0")"
  popd > /dev/null
  if [[ -e "${abs_entrypoint}.runfiles" ]]; then
    # runfiles dir found alongside entrypoint.
    export RUNFILES="${abs_entrypoint}.runfiles"
  elif [[ "$abs_entrypoint" == *".runfiles/"* ]]; then
    # runfiles dir found in entrypoint path.
    export RUNFILES="${abs_entrypoint%.runfiles/*}.runfiles"
  else
    # runfiles dir not found: fall back on current directory.
    export RUNFILES="$PWD"
  fi
fi

# start coverage collector
dart="$RUNFILES/%dart_vm%"
collect_coverage_snapshot="$RUNFILES/%collect_coverage_snapshot%"
if [[ $DART_COVERAGE == "1" && -n $DART_COVERAGE_FILE ]]; then
  observe_port=$(pick_random_unused_tcp_port)
  coverage_json=$(mktemp)
  "$dart" "$collect_coverage_snapshot" \
      --port="$observe_port" \
      --out="$coverage_json" \
      --wait-paused \
      --resume-isolates &
  flags="--pause-isolates-on-exit --enable-vm-service=$observe_port"
fi

"$dart" $flags %vm_flags% \
        "$RUNFILES/%script_file%" %script_args% "$@"

# format coverage output
format_coverage_snapshot="$RUNFILES/%format_coverage_snapshot%"
if [[ -e "$coverage_json" && ! -f "$DART_COVERAGE_FILE" ]]; then
  "$dart" "$format_coverage_snapshot" \
      --in="$coverage_json" \
      --out="$DART_COVERAGE_FILE" \
      --bazel \
      --bazel-workspace google3 \
      --lcov
  rm "$coverage_json"
fi
