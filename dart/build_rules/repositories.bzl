# Copyright 2016 The Bazel Authors. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

"""Repositories for Dart."""

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")


_DART_SDK_BUILD_FILE = """
package(default_visibility = [ "//visibility:public" ])

filegroup(
  name = "dart_vm",
  srcs = ["dart-sdk/bin/dart"],
)

filegroup(
  name = "dart2js",
  srcs = ["dart-sdk/bin/dart2js"],
)

filegroup(
  name = "dart2js_support",
  srcs = glob([
      "dart-sdk/bin/dart",
      "dart-sdk/bin/snapshots/dart2js.dart.snapshot",
      "dart-sdk/lib/**",
  ]),
)

filegroup(
  name = "pub",
  srcs = ["dart-sdk/bin/pub"],
)

filegroup(
  name = "pub_support",
  srcs = glob([
      "dart-sdk/version",
      "dart-sdk/bin/dart",
      "dart-sdk/bin/snapshots/pub.dart.snapshot",
  ]),
)
"""


def dart_repositories():
  http_archive(
      name = "dart_linux_x86_64",
      url = "https://storage.googleapis.com/dart-archive/channels/stable/release/2.7.2/sdk/dartsdk-linux-x64-release.zip",
      sha256 = "9b1434cd60c56aa39d66575b0cc9ea0a16877abf09475f86950d571d547b7a6f",
      build_file_content = _DART_SDK_BUILD_FILE,
  )

  http_archive(
      name = "dart_darwin_x86_64",
      url = "https://storage.googleapis.com/dart-archive/channels/stable/release/2.7.2/sdk/dartsdk-macos-x64-release.zip",
      sha256 = "529281db2b4450c1aabdda0e6c53ccfa5709869dae56d248fb62365c0ea03f84",
      build_file_content = _DART_SDK_BUILD_FILE,
  )
