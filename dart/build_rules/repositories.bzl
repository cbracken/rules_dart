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
  sdk_channel = "stable"
  sdk_version = "2.12.1"
  linux_x64_sha = "66dd4e090b34ed8389e5e32975724bb9c4e0a4ceba812c2a2f8dd9565361a97a"
  macos_x64_sha = "f2fd4b50fe017bbad3ae4e3fa1f9b170c9ca25e87b16f80c0c8e667caa0b3568"

  sdk_base_url = ("https://storage.googleapis.com/dart-archive/channels/" +
      sdk_channel + "/release/" +
      sdk_version + "/sdk/")

  http_archive(
      name = "dart_linux_x86_64",
      url = sdk_base_url + "dartsdk-linux-x64-release.zip",
      sha256 = linux_x64_sha,
      build_file_content = _DART_SDK_BUILD_FILE,
  )

  http_archive(
      name = "dart_darwin_x86_64",
      url = sdk_base_url + "dartsdk-macos-x64-release.zip",
      sha256 = macos_x64_sha,
      build_file_content = _DART_SDK_BUILD_FILE,
  )
