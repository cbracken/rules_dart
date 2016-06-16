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
    visibility = ["//visibility:private"],
)

filegroup(
    name = "dart_vm_binary",
    srcs = select({
        ":darwin": ["dart_vm_binary.sh"],
        ":k8": ["dart_vm_binary.sh"],
    }),
)

filegroup(
    name = "dart_vm_test_template",
    srcs = select({
        "//conditions:default": [":dart_vm_test"],
        ":coverage_config": [":dart_vm_test_coverage"],
    }),
)

filegroup(
    name = "dart_vm_test",
    srcs = select({
        ":darwin": ["dart_vm_test.sh"],
        ":k8": ["dart_vm_test.sh"],
    }),
)

filegroup(
    name = "dart_vm_test_coverage",
    srcs = select({
        ":darwin": ["dart_vm_test_coverage.sh"],
        ":k8": ["dart_vm_test_coverage.sh"],
    }),
)
