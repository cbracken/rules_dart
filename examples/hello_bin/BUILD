load("//dart/build_rules:vm.bzl", "dart_vm_binary")

package(default_visibility = ["//visibility:public"])

dart_vm_binary(
    name = "hello_bin",
    srcs = ["bin/hello.dart"],
    script_file = "bin/hello.dart",
    deps = [
        "//examples/goodbye_lib",
        "//examples/hello_lib",
    ],
)

dart_vm_binary(
    name = "hello_bin_checked",
    srcs = ["bin/hello.dart"],
    script_file = "bin/hello.dart",
    script_args = ["foo", "bar"],
    vm_flags = ["--enable-asserts"],
    deps = [
        "//examples/goodbye_lib",
        "//examples/hello_lib",
    ],
)

dart_vm_binary(
    name = "nested_bin",
    srcs = ["bin/nested.dart"],
    script_file = "bin/nested.dart",
    data = [":hello_bin"],
    deps = [
        "//examples/goodbye_lib",
    ],
)

dart_vm_binary(
    name = "hello_bin_snapshot",
    srcs = ["bin/hello.dart"],
    script_file = "bin/hello.dart",
    script_args = ["foo", "bar"],
    vm_flags = ["--enable-asserts"],
    deps = [
        "//examples/goodbye_lib",
        "//examples/hello_lib",
    ],
    snapshot = True,
)
