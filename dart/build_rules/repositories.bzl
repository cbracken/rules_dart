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

load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository", "new_git_repository")

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
  sdk_version = "2.17.7"
  linux_x64_sha = "ba8bc85883e38709351f78c527cbf72e22cd234b3678a1ec6a2e781f7984e624"
  macos_arm64_sha = "a4be379202cf731c7e33de20b4abc4ca1e2e726bc5973222b3a7ae5a0cabfce1"
  macos_x64_sha = "ba258fff40822cb410c4f1f7916b63f0837903a6bae8f4bd83341053b10ecbe3"

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
      name = "dart_darwin_arm64",
      url = sdk_base_url + "dartsdk-macos-arm64-release.zip",
      sha256 = macos_arm64_sha,
      build_file_content = _DART_SDK_BUILD_FILE,
  )

  http_archive(
      name = "dart_darwin_x86_64",
      url = sdk_base_url + "dartsdk-macos-x64-release.zip",
      sha256 = macos_x64_sha,
      build_file_content = _DART_SDK_BUILD_FILE,
  )


_FIXNUM_BUILD_FILE = """
load("@//dart/build_rules:core.bzl", "dart_library")
load("@//dart/build_rules:vm.bzl", "dart_vm_test")

package(default_visibility = ["//visibility:public"])

dart_library(
    name = "fixnum_lib",
    srcs = glob(["lib/**/*.dart"]),
)
"""

_PROTOBUF_BUILD_FILE = """
load("@//dart/build_rules:core.bzl", "dart_library")
load("@//dart/build_rules:vm.bzl", "dart_vm_binary")

package(default_visibility = ["//visibility:public"])

dart_library(
    name = "protobuf_lib",
    srcs = glob(["lib/**/*.dart"]),
)
"""

_PROTOC_PLUGIN_BUILD_FILE = """
load("@//dart/build_rules:core.bzl", "dart_library")
load("@//dart/build_rules:vm.bzl", "dart_vm_binary")

package(default_visibility = ["//visibility:public"])

dart_library(
    name = "protoc_plugin_lib",
    srcs = glob(["lib/**/*.dart"]),
)

dart_vm_binary(
    name = "protoc_gen_dart",
    srcs = ["bin/protoc_plugin.dart"],
    script_file = "bin/protoc_plugin.dart",
    deps = [":protoc_plugin_lib"],
)
"""

def proto_repositories():

  new_git_repository(
      name = "dart_fixnum",
      # tag = "1.0.0",
      commit = "762b74f61696d414d0090c5dfc430572f5b4be0f", 
      shallow_since = "1612551835 -0800",
      remote = "https://github.com/dart-lang/fixnum",
      build_file_content = _FIXNUM_BUILD_FILE
  )

  new_git_repository(
      name = "dart_protobuf_protobuf",
      # tag = "protobuf-v2.0.1",
      commit = "23136dc01cf3daccf66ebb7f5a7578ec7c0dc7e6", 
      shallow_since = "1638456183 +0100",
      remote = "https://github.com/google/protobuf.dart",
      build_file_content = _PROTOBUF_BUILD_FILE,
      strip_prefix = "protobuf"
  )

  new_git_repository(
      name = "dart_protobuf_protoc_plugin",
      # tag = "protobuf-v2.0.1",
      commit = "23136dc01cf3daccf66ebb7f5a7578ec7c0dc7e6", 
      shallow_since = "1638456183 +0100",
      remote = "https://github.com/google/protobuf.dart",
      build_file_content = _PROTOC_PLUGIN_BUILD_FILE,
      strip_prefix = "protoc_plugin"
  )

  git_repository(
      name = "com_google_protobuf",
      # tag = "v3.19.1",
      commit = "7c40b2df1fdf6f414c1c18c789715a9c948a0725", 
      shallow_since = "1635455273 -0700",
      remote = "https://github.com/protocolbuffers/protobuf",
  )
