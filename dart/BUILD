package(default_visibility = ["//visibility:public"])

config_setting(
    name = "darwin",
    values = {"host_cpu": "darwin"},
)

config_setting(
    name = "k8",
    values = {"host_cpu": "k8"},
)

config_setting(
    name = "coverage_config",
    values = {
        "collect_code_coverage": "true",
    },
)

filegroup(
    name = "dart_vm",
    srcs = select({
        ":darwin": ["@dart_darwin_x86_64//:dart_vm"],
        ":k8": ["@dart_linux_x86_64//:dart_vm"],
    }),
)

filegroup(
    name = "dart2js",
    srcs = select({
        ":darwin": ["@dart_darwin_x86_64//:dart2js"],
        ":k8": ["@dart_linux_x86_64//:dart2js"],
    }),
)

filegroup(
    name = "dart2js_support",
    srcs = select({
        ":darwin": ["@dart_darwin_x86_64//:dart2js_support"],
        ":k8": ["@dart_linux_x86_64//:dart2js_support"],
    }),
)
