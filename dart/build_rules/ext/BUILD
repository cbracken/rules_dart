package(default_visibility = ["//visibility:public"])

filegroup(
    name = "dart_vm",
    srcs = select({
        "//dart:darwin": ["@dart_darwin_x86_64//:dart_vm"],
        "//dart:k8": ["@dart_linux_x86_64//:dart_vm"],
    }),
)

filegroup(
    name = "dart2js",
    srcs = select({
        "//dart:darwin": ["@dart_darwin_x86_64//:dart2js"],
        "//dart:k8": ["@dart_linux_x86_64//:dart2js"],
    }),
)

filegroup(
    name = "dart2js_support",
    srcs = select({
        "//dart:darwin": ["@dart_darwin_x86_64//:dart2js_support"],
        "//dart:k8": ["@dart_linux_x86_64//:dart2js_support"],
    }),
)
