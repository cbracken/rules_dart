load("//dart/build_rules:proto.bzl", "dart_proto_library")
load("//dart/build_rules:vm.bzl", "dart_vm_binary")

package(default_visibility = ["//visibility:public"])

proto_library(
    name = "review_proto",
    srcs = ["review.proto"],
    deps = [
        "//examples/proto_lib:person_proto",
    ],
)

dart_proto_library(
    name = "review_proto_dart",
    deps = [":review_proto"],
)

dart_vm_binary(
    name = "proto_bin",
    srcs = ["bin/hello_proto.dart"],
    script_file = "bin/hello_proto.dart",
    deps = [":review_proto_dart"],
)
