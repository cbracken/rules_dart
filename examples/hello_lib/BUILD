load("//dart/build_rules:core.bzl", "dart_library")
load("//dart/build_rules:vm.bzl", "dart_vm_test")

package(default_visibility = ["//visibility:public"])

# Top-level library that verifies that library-library dependencies within a
# package build successfully.
dart_library(
    name = "hello_lib",
    srcs = ["lib/hello.dart"],
    deps = [":emote_lib"],
)

dart_library(
    name = "emote_lib",
    srcs = ["lib/src/emote.dart"],
    deps = ["//examples/greet_lib"],
)

dart_vm_test(
    name = "passing_test",
    srcs = ["test/pass_test.dart"],
    script_file = "test/pass_test.dart",
    deps = [":hello_lib"],
)

dart_vm_test(
    name = "failing_test",
    srcs = ["test/fail_test.dart"],
    script_file = "test/fail_test.dart",
    deps = [":hello_lib"],
)
