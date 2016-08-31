load("//dart:core.bzl", "dart_library")
load("//dart:vm.bzl", "dart_vm_test")

package(default_visibility = ["//visibility:public"])

dart_library(
    name = "hello_lib",
    srcs = ["lib/hello.dart"],
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
