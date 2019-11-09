#!/bin/sh

echo
echo "============================================================"
echo "Building all targets."
echo "============================================================"
bazel build ...

echo
echo "============================================================"
echo "Running tests."
echo "============================================================"
bazel test //examples/hello_lib:passing_test

echo
echo "============================================================"
echo "Verifying that expected failures fail."
echo "============================================================"
if bazel test //examples/hello_lib:failing_test; then
  echo "ERROR: Expected failure did not fail."
  exit 1
fi
