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

"""Debugging utilities for Dart rules"""


def dump_dart_context(dart_ctx):
  """Dumps the specified Dart context (for debugging)"""
  print("============================================================")
  print("Package: %s" % dart_ctx.package)
  print("Target:  %s" % dart_ctx.label)
  print("============================================================")
  print("-- srcs -----------------------------------")
  for s in dart_ctx.srcs:
    print("  %s" % s)
  print("-- data -----------------------------------")
  for s in dart_ctx.data:
    print("  %s" % s)
  print("-- deps -----------------------------------")
  for s in dart_ctx.deps:
    print("  %s" % s)
