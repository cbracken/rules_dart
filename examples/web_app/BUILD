load("//dart/build_rules:core.bzl", "dart_library")
load("//dart/build_rules:web.bzl", "dart_web_application")

package(default_visibility = ["//visibility:public"])

licenses(["notice"])  # BSD

dart_library(
    name = "web_app",
    srcs = [":gen_lib"] + glob(["lib/**"]),
)

genrule(
    name = "gen_lib",
    outs = ["web/generated.dart"],
    cmd = """echo 'String generatedFunc() => "generated";' > $@""",
)

dart_web_application(
    name = "js_debug",
    srcs = [":gen_lib"] + glob(["web/**"]),
    deferred_lib_count = 1,
    dump_info = True,
    enable_asserts = True,
    minify = False,
    script_file = "web/main.dart",
    deps = [":web_app"],
)

dart_web_application(
    name = "js_release",
    srcs = glob(["web/**"]),
    deferred_lib_count = 1,
    script_file = "web/main.dart",
    deps = [
        ":web_app",
        "//examples/hello_lib",
    ],
)
