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

"""Dart rules targeting the Dart VM."""


load(":internal.bzl", "layout_action", "make_dart_context", "package_spec_action")


def _dart_vm_binary_impl(ctx):
  """Implements the dart_vm_binary() rule."""
  dart_ctx = make_dart_context(ctx.label,
                               srcs=ctx.files.srcs,
                               data=ctx.files.data,
                               deps=ctx.attr.deps)

  if ctx.attr.snapshot:
    # Build snapshot
    out_snapshot = ctx.new_file(ctx.label.name + ".snapshot")
    vm_snapshot_action(
        ctx=ctx,
        dart_ctx=dart_ctx,
        output=out_snapshot,
        vm_flags=ctx.attr.vm_flags,
        script_file=ctx.file.script_file,
        script_args=ctx.attr.script_args,
    )
    script_file = out_snapshot
  else:
    script_file = ctx.file.script_file

  # Emit package spec.
  package_spec = ctx.new_file(ctx.label.name + ".packages")
  package_spec_action(
      ctx=ctx,
      dart_ctx=dart_ctx,
      output=package_spec,
  )
  vm_flags = ctx.attr.vm_flags

  # Emit entrypoint script.
  ctx.template_action(
      output=ctx.outputs.executable,
      template=ctx.file._entrypoint_template,
      executable=True,
      substitutions={
          "%workspace%": ctx.workspace_name,
          "%dart_vm%": ctx.executable._dart_vm.short_path,
          "%package_spec%": package_spec.short_path,
          "%vm_flags%": " ".join(ctx.attr.vm_flags),
          "%script_file%": script_file.short_path,
          "%script_args%": " ".join(ctx.attr.script_args),
      },
  )

  # Compute runfiles.
  runfiles_files=dart_ctx.transitive_data + [
      ctx.executable._dart_vm,
      ctx.outputs.executable,
      package_spec,
  ]
  if ctx.attr.snapshot:
    runfiles_files += [out_snapshot]
  else:
    runfiles_files += dart_ctx.transitive_srcs
  runfiles = ctx.runfiles(
      files=list(runfiles_files),
      collect_data=True,
  )

  return struct(
      runfiles=runfiles,
  )


_dart_vm_binary_attrs = {
    "script_file": attr.label(
        allow_files=True, single_file=True, mandatory=True),
    "script_args": attr.string_list(),
    "vm_flags": attr.string_list(),
    "srcs": attr.label_list(allow_files=True, mandatory=True),
    "data": attr.label_list(allow_files=True, cfg=DATA_CFG),
    "deps": attr.label_list(providers=["dart"]),
    "snapshot": attr.bool(default=True),
    "_dart_vm": attr.label(
        allow_files=True, single_file=True, executable=True,
        default=Label("//dart/sdk:dart_vm")),
    "_entrypoint_template": attr.label(
        single_file=True,
        default=Label("//dart/build_rules/templates:dart_vm_binary")),
}


dart_vm_binary = rule(
    implementation=_dart_vm_binary_impl,
    attrs=_dart_vm_binary_attrs,
    executable=True,
)


def vm_snapshot_action(ctx, dart_ctx, output, vm_flags, script_file, script_args):
  """Emits a Dart VM snapshot."""
  build_dir = ctx.label.name + ".build/"
  root_relative_build_dir = ctx.label.package + "/" + build_dir

  # Emit package spec.
  package_spec_path = ctx.label.package + "/" + ctx.label.name + ".packages"
  package_spec = ctx.new_file(build_dir + package_spec_path)
  package_spec_action(
      ctx=ctx,
      output=package_spec,
      dart_ctx=dart_ctx,
  )

  # Build a flattened directory of dart2js inputs, including inputs from the
  # src tree, genfiles, and bin.
  build_dir_files = layout_action(ctx, dart_ctx.transitive_srcs, build_dir)
  out_script = build_dir_files[script_file.short_path]

  # TODO(cbracken) assert --snapshot not in flags
  # TODO(cbracken) assert --packages not in flags
  arguments = [
      "--packages=%s" % package_spec.path,
      "--snapshot=%s" % output.path,
  ]
  arguments += vm_flags
  arguments += [out_script.path]
  arguments += script_args
  ctx.action(
      inputs=build_dir_files.values() + [package_spec],
      outputs=[output],
      executable=ctx.executable._dart_vm,
      arguments=arguments,
      progress_message="Building Dart VM snapshot",
      mnemonic="DartVMSnapshot",
  )


def _dart_vm_snapshot_impl(ctx):
  """Implements the dart_vm_snapshot build rule."""
  dart_ctx = make_dart_context(ctx.label,
                               srcs=ctx.files.srcs,
                               data=ctx.files.data,
                               deps=ctx.attr.deps)
  vm_snapshot_action(
      ctx=ctx,
      dart_ctx=dart_ctx,
      output=ctx.outputs.snapshot,
      vm_flags=ctx.attr.vm_flags,
      script_file=ctx.file.script_file,
      script_args=ctx.attr.script_args,
  )
  return struct()


dart_vm_snapshot = rule(
    implementation=_dart_vm_snapshot_impl,
    attrs=_dart_vm_binary_attrs,
    outputs={"snapshot": "%{name}.snapshot"},
)


def _dart_vm_test_impl(ctx):
  """Implements the dart_vm_test() rule."""
  dart_ctx = make_dart_context(ctx.label,
                               srcs=ctx.files.srcs,
                               data=ctx.files.data,
                               deps=ctx.attr.deps)

  # Emit package spec.
  package_spec = ctx.new_file(ctx.label.name + ".packages")
  package_spec_action(
      ctx=ctx,
      dart_ctx=dart_ctx,
      output=package_spec,
  )
  vm_flags = ctx.attr.vm_flags
  script_file = ctx.file.script_file

  # Emit entrypoint script.
  ctx.template_action(
      output=ctx.outputs.executable,
      template=ctx.file._entrypoint_template,
      executable=True,
      substitutions={
          "%workspace%": ctx.workspace_name,
          "%dart_vm%": ctx.executable._dart_vm.short_path,
          "%package_spec%": package_spec.short_path,
          "%vm_flags%": " ".join(vm_flags),
          "%script_file%": script_file.short_path,
          "%script_args%": " ".join(ctx.attr.script_args),
      },
  )

  # Compute runfiles.
  runfiles_files = dart_ctx.transitive_data + [
      ctx.executable._dart_vm,
      ctx.outputs.executable,
  ]
  runfiles_files += dart_ctx.transitive_srcs
  runfiles_files += [package_spec]
  runfiles = ctx.runfiles(
      files=list(runfiles_files),
  )

  return struct(
      runfiles=runfiles,
      instrumented_files=struct(
          source_attributes=["srcs"],
          dependency_attributes=["deps"],
      ),
  )

_dart_vm_test_attrs = {
    "script_file": attr.label(
        allow_files=True, single_file=True, mandatory=True),
    "script_args": attr.string_list(),
    "vm_flags": attr.string_list(),
    "srcs": attr.label_list(allow_files=True, mandatory=True),
    "data": attr.label_list(allow_files=True, cfg=DATA_CFG),
    "deps": attr.label_list(providers=["dart"]),
    "_dart_vm": attr.label(
        allow_files=True, single_file=True, executable=True,
        default=Label("//dart/sdk:dart_vm")),
    "_entrypoint_template": attr.label(
        single_file=True,
        default=Label("//dart/build_rules/templates:dart_vm_test_template")),
}


dart_vm_test = rule(
    implementation=_dart_vm_test_impl,
    attrs=_dart_vm_test_attrs,
    executable=True,
    test=True,
)
