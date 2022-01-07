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

"""Dart rules for protocol buffers"""

load("//dart/build_rules:internal.bzl", "make_dart_context", "collect_dart_context")
load("@rules_proto//proto:defs.bzl", "ProtoInfo")

def _generate_protoc_config(dart_ctx):
  dart_ctxs = collect_dart_context(dart_ctx,
                                   transitive=True,
                                   include_self=True).values()

  entries = []
  for dc in dart_ctxs:
    entries += ["|".join([dc.package, dc.label.package, dc.lib_root])]
  return "BazelPackages=" + ";".join(entries)


def protoc_gen_action(ctx,
                      dart_ctx,
                      direct_sources,
                      transitive_sources,
                      outputs):
  cmd_inputs, _, cmd_input_manifests = ctx.resolve_command(tools=[ctx.attr._protoc_gen_dart])

  # Protoc arguments.
  inputs = cmd_inputs + transitive_sources.to_list()
  plugin = "protoc-gen-dart=" + ctx.executable._protoc_gen_dart.path
  bazel_options = _generate_protoc_config(dart_ctx)
  genfiles_path = ctx.configuration.genfiles_dir.path
  ctx.actions.run(
      inputs=inputs,
      outputs=outputs,
      executable=ctx.executable._protocol_compiler,
      arguments=[
          "--plugin=" + plugin,
          "--dart_out=" + bazel_options + ":" + genfiles_path,
      ] + [s.path for s in direct_sources],
      progress_message="Generating Dart proto files %s" % ctx,
      mnemonic="DartProtoGen",
      input_manifests=cmd_input_manifests,
  )


def _dart_proto_aspect_impl(target, ctx):
  # Compute the generated outputs.
  direct_sources = target[ProtoInfo].direct_sources
  generated_outputs = []
  for s in direct_sources:
    gen_path = "lib/" + s.basename[:-len(".proto")] + ".pb.dart"
    out_file = ctx.actions.declare_file(gen_path)
    generated_outputs += [out_file]

  # Create the package.
  dart_ctx = make_dart_context(
      label = target.label,
      srcs = generated_outputs,
      data = ctx.rule.attr.data,
      deps = ctx.rule.attr.deps + ctx.attr._proto_libs_dart,
  )

  # Generate the Dart outputs.
  protoc_gen_action(ctx,
                    dart_ctx,
                    direct_sources,
                    target[ProtoInfo].transitive_sources,
                    generated_outputs)

  return struct(
      dart=dart_ctx,
  )


_dart_proto_aspect_attrs = {
    "_protocol_compiler": attr.label(
        executable=True,
        cfg="host",
        default=Label("//third_party:protoc"),
    ),
    "_protoc_gen_dart": attr.label(
        default=Label(
            "//third_party/dart/protoc_plugin:protoc_gen_dart"),
        executable=True,
        cfg="host",
    ),
    "_proto_libs_dart": attr.label_list(default=[
        Label("//third_party/dart/fixnum:fixnum"),
        Label("//third_party/dart/protobuf:protobuf"),
    ])
}


dart_proto_aspect = aspect(
    implementation=_dart_proto_aspect_impl,
    attr_aspects=["deps"],
    attrs=_dart_proto_aspect_attrs,
)


def _dart_proto_library_impl(ctx):
  dart_ctx = make_dart_context(ctx.label, deps=ctx.attr.deps)
  return struct(
      dart=dart_ctx,
  )


_dart_proto_library_attrs = {
    "deps": attr.label_list(
        providers=[ProtoInfo],
        aspects=[dart_proto_aspect],
    ),
}


dart_proto_library = rule(
    implementation=_dart_proto_library_impl,
    attrs=_dart_proto_library_attrs,
)
