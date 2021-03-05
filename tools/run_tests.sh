#!/bin/sh

echo
echo "============================================================"
echo "Building all targets."
echo "============================================================"
if ! bazel build ...; then
  echo "============================================================"
  echo "ERROR: bazel build ... failed."
  echo "============================================================"
  exit 1
fi

echo
echo "============================================================"
echo "Running tests."
echo "============================================================"
if ! bazel test //examples/hello_lib:passing_test; then
  echo "============================================================"
  echo "ERROR: bazel test //examples/hello_lib:passing_test failed."
  echo "============================================================"
  exit 1
fi

echo
echo "============================================================"
echo "Verifying that expected failures fail."
echo "============================================================"
if bazel test //examples/hello_lib:failing_test; then
  echo "============================================================"
  echo "ERROR: bazel test //examples/hello_lib:failing_test did not fail."
  echo "============================================================"
  exit 1
fi

echo
echo "============================================================"
echo "All tests passed."
echo "============================================================"
