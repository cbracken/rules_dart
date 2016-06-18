package(default_visibility = ["//visibility:public"])

config_setting(
    name = "darwin",
    values = {"host_cpu": "darwin"},
)

config_setting(
    name = "k8",
    values = {"host_cpu": "k8"},
)

filegroup(
    name = "dart2js_helper",
    srcs = select({
        ":darwin": ["dart2js_helper.sh"],
        ":k8": ["dart2js_helper.sh"],
    }),
)
