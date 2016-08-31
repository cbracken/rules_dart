load("//dart:core.bzl", "dart_library")
load("//dart:web.bzl", "dart_web_binary")

package(default_visibility = ["//visibility:public"])

licenses(["notice"])  # BSD

dart_library(
    name = "web_app",
    srcs = [":gen_lib"] + glob(["lib/**"]),
)

genrule(
    name = "gen_lib",
    cmd = """echo 'String generatedFunc() => "generated";' > $@""",
    outs = ["web/generated.dart"],
)

dart_web_binary(
    name = "js_debug",
    srcs = [":gen_lib"] + glob(["web/**"]),
    script_file = "web/main.dart",
    deferred_lib_count = 1,
    checked = True,
    minify = False,
    dump_info = True,
    deps = [":web_app"],
)

dart_web_binary(
    name = "js_release",
    srcs = glob(["web/**"]),
    script_file = "web/main.dart",
    deferred_lib_count = 1,
    deps = [
        ":web_app",
        "//examples/hello_lib",
    ],
)
