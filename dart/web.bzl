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

"""Dart rules targeting web clients"""


load("//dart:common.bzl", "layout_action", "make_dart_context", "package_spec_action")


def dart2js_action(ctx, dart_ctx, script_file,
                   checked, csp, dump_info, minify, preserve_uris,
                   js_output, other_outputs):
  """dart2js compile action"""
  # Create a build directory.
  build_dir = ctx.label.name + ".build/"
  root_relative_build_dir = ctx.label.package + "/" + build_dir

  # Emit package spec.
  package_spec_path = ctx.label.package + "/" + ctx.label.name + ".packages"
  package_spec = ctx.new_file(build_dir + package_spec_path)
  package_spec_action(
      ctx=ctx,
      dart_ctx=dart_ctx,
      output=package_spec,
  )

  # Build a flattened directory of dart2js inputs, including inputs from the
  # src tree, genfiles, and bin.
  build_dir_files = layout_action(ctx, dart_ctx.transitive_srcs, build_dir)
  out_script = build_dir_files[script_file.short_path]

  # Compute action inputs.
  inputs = ctx.files._dart2js_support
  inputs += build_dir_files.values()
  inputs += [package_spec]

  # Compute dart2js args.
  dart2js_args = [
      "--packages=%s" % package_spec.path,
      "--out=%s" % js_output.path,
  ]
  if checked:
    dart2js_args += ["--checked"]
  if csp:
    dart2js_args += ["--csp"]
  if dump_info:
    dart2js_args += ["--dump-info"]
  if minify:
    dart2js_args += ["--minify"]
  if preserve_uris:
    dart2js_args += ["--preserve-uris"]
  dart2js_args += [out_script.path]
  ctx.action(
      inputs=inputs,
      executable=ctx.executable._dart2js,
      arguments=dart2js_args,
      outputs=[js_output] + other_outputs,
      progress_message="Compiling with dart2js %s" % ctx,
      mnemonic="Dart2jsCompile",
  )


def _dart_web_binary_impl(ctx):
  dart_ctx = make_dart_context(ctx.label,
                               srcs=ctx.files.srcs,
                               data=ctx.files.data,
                               deps=ctx.attr.deps)

  # Compute outputs.
  js_output = ctx.outputs.js
  other_outputs = [
      ctx.outputs.deps_file,
      ctx.outputs.sourcemap,
  ]
  if ctx.attr.dump_info:
    other_outputs += [ctx.outputs.info_json]

  # Invoke dart2js.
  dart2js_action(
      ctx=ctx,
      dart_ctx=dart_ctx,
      script_file=ctx.file.script_file,
      checked=ctx.attr.checked,
      csp=ctx.attr.csp,
      dump_info=ctx.attr.dump_info,
      minify=ctx.attr.minify,
      preserve_uris=ctx.attr.preserve_uris,
      js_output=js_output,
      other_outputs=other_outputs,
  )

  # TODO(cbracken) aggregate, inject licenses
  return struct()


_dart_web_binary_attrs = {
    "script_file": attr.label(
        allow_files=True, single_file=True, mandatory=True),
    "srcs": attr.label_list(allow_files=True, mandatory=True),
    "data": attr.label_list(allow_files=True, cfg=DATA_CFG),
    "deps": attr.label_list(providers=["dart"]),
    # compiler flags
    "checked": attr.bool(default=False),
    "csp": attr.bool(default=False),
    "dump_info": attr.bool(default=False),
    "minify": attr.bool(default=True),
    "preserve_uris": attr.bool(default=False),
    # tools
    "_dart2js": attr.label(
        allow_files=True, single_file=True, executable=True,
        default=Label("//dart:dart2js")),
    "_dart2js_support": attr.label(
        allow_files=True,
        default=Label("//dart:dart2js_support")),
}


def _dart_web_binary_outputs(attrs):
  outputs = {
      "js": "%{name}.js",
      "deps_file": "%{name}.js.deps",
      "sourcemap": "%{name}.js.map",
  }
  if attrs.dump_info:
    outputs["info_json"] = "%{name}.js.info.json"
  return outputs


dart_web_binary = rule(
    implementation=_dart_web_binary_impl,
    attrs=_dart_web_binary_attrs,
    outputs=_dart_web_binary_outputs,
)
