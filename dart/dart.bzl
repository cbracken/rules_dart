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

"""Dart rules for Bazel"""

load("//dart:core.bzl", "dart_library")
load("//dart:repositories.bzl", "dart_repositories")
load("//dart:vm.bzl", "dart_vm_binary", "dart_vm_snapshot", "dart_vm_test")
load("//dart:web.bzl", "dart_web_binary")
