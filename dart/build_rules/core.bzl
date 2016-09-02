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

"""Dart rules shared across deployment platforms."""


load(":internal.bzl", "make_dart_context")


def _dart_library_impl(ctx):
  """Implements the dart_library() rule."""
  dart_ctx = make_dart_context(ctx.label,
                               srcs=ctx.files.srcs,
                               data=ctx.files.data,
                               deps=ctx.attr.deps)

  # TODO(cbracken) consider enforcing license attr on //third-party/dart.
  return struct(
      dart=dart_ctx,
  )


dart_library_attrs = {
    "srcs": attr.label_list(allow_files=True, mandatory=True),
    "data": attr.label_list(allow_files=True, cfg="data"),
    "deps": attr.label_list(providers=["dart"]),
    "license": attr.label(allow_files=True, single_file=True)
}


dart_library = rule(
    implementation=_dart_library_impl,
    attrs=dart_library_attrs,
)
