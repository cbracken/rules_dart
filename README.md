Dart rules for Bazel
====================

![Build Status](https://github.com/cbracken/rules_dart/actions/workflows/build.yml/badge.svg)

**WARNING:** These rules are maintained on an infrequent basis. They were
authored as the foundation for what became the
[dart-lang/rules\_dart](https://github.com/dart-lang/rules_dart) repo which was
later deprecated and archived.

Overview
--------

These build rules are used for building [Dart](https://dartlang.org) projects
with [Bazel](https://bazel.build).

Setup
-----

To use the Dart rules, add the following to your `WORKSPACE` file to add the
external repositories for the Dart toolchain:

```python
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

git_repository(
    name = "io_bazel_rules_dart",
    remote = "https://github.com/cbracken/rules_dart.git",
    tag = "2.14.4",
)
load("@io_bazel_rules_dart//dart/build_rules:repositories.bzl", "dart_repositories")

dart_repositories()
```

Core rules
----------

```
load("@io_bazel_rules_dart//dart/build_rules:core.bzl", RULE_NAME)
```

`dart_library`: Declares a collection of Dart sources and data and their
dependencies.


VM rules
--------

```
load("@io_bazel_rules_dart//dart/build_rules:vm.bzl", RULE_NAME)
```

`dart_vm_binary`: Builds an executable bundle that runs a script or snapshot on
the Dart VM.

`dart_vm_snapshot`: Builds a VM snapshot of a Dart script. **WARNING** Snapshot
files are *not* guaranteed to be compatible across VM releases.

`dart_vm_test`: Builds a test that will be executed on the Dart VM.


Web rules
---------

```
load("@io_bazel_rules_dart//dart/build_rules:web.bzl", RULE_NAME)
```

`dart_web_application`: Compiles the specified script to JavaScript.

`dart_web_test`: Builds a test that will be executed in the browser.
