# Dart rules for Bazel

**WARNING** These rules had moved to a
[repo](https://github.com/dart-lang/rules_dart) under the dart-lang
organisation which was later deprecated and archived. They are maintained here
on an infrequent basis.

## Rules

  * dart\_library
  * dart\_vm\_binary
  * dart\_vm\_snapshot
  * dart\_vm\_test
  * dart\_web\_application
  * dart\_web\_test

## Overview

These build rules are used for building [Dart](https://dartlang.org) projects
with [Bazel](https://bazel.build).

## Setup

To use the Dart rules, add the following to your `WORKSPACE` file to add the
external repositories for the Dart toolchain:

```python
git_repository(
    name = "io_bazel_rules_dart",
    remote = "https://github.com/bazelbuild/rules_dart.git",
    tag = "2.3.1",
)
load("@io_bazel_rules_dart//dart:repositories.bzl", "dart_repositories")

dart_repositories()
```

## Roadmap

  * TODO

## Core rules

`dart_library`: Declares a collection of Dart sources and data and their
dependencies.


## VM rules

`dart_vm_binary`: Builds an executable bundle that runs a script or snapshot on
the Dart VM.

`dart_vm_snapshot`: Builds a VM snapshot of a Dart script. **WARNING** Snapshot
files are *not* guaranteed to be compatible across VM releases.

`dart_vm_test`: Builds a test that will be executed on the Dart VM.


## Web rules

`dart_web_application`: Compiles the specified script to JavaScript.

`dart_web_test`: Builds a test that will be executed in the browser.
