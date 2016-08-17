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

"""Repositories for Dart"""

DART_BUILD_FILE = """
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
  native.new_http_archive(
      name = "dart_linux_x86_64",
      url = "https://storage.googleapis.com/dart-archive/channels/stable/release/1.18.1/sdk/dartsdk-linux-x64-release.zip",
      sha256 = "6247d4528ca4ad45507823df3da6b8cfb38ff93b023ab094aed1b0cb4bdaf336",
      build_file_content = DART_BUILD_FILE,
  )

  native.new_http_archive(
      name = "dart_darwin_x86_64",
      url = "https://storage.googleapis.com/dart-archive/channels/stable/release/1.18.1/sdk/dartsdk-macos-x64-release.zip",
      sha256 = "b298c2096d5df79910716621525d5f360ea22cc967c42d48e90b60da9490a204",
      build_file_content = DART_BUILD_FILE,
  )
