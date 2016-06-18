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

"""Internal implemenation utility functions for Dart rules.

WARNING: NOT A PUBLIC API.

This code is public only by virtue of the fact that Bazel does not yet support
a mechanism for enforcing limitied visibility of Skylark rules. This code makes
no gurantees of API stability and is intended solely for use by the Dart rules.
"""


_third_party_prefix = "third_party/dart/"


def assert_third_party_licenses(ctx):
  """Asserts license attr on non-testonly third-party packages."""
  if (not ctx.attr.testonly
      and not ctx.attr.license_files
      and ctx.label.package.startswith(_third_party_prefix)):
    fail("%s lacks license_files attribute, " % ctx.label +
         "required for all non-testonly third-party Dart library rules")


def collect_files(dart_ctx):
  srcs = dart_ctx.srcs
  data = dart_ctx.data
  for d in dart_ctx.transitive_deps.values():
    srcs = srcs + d.dart.srcs
    data = srcs + d.dart.data
  return (srcs, data)


def _collect_transitive_deps(deps):
  """Collects transitive closure of deps.

  Args:
    deps: input deps Target collection. All targets must have a 'dart' provider.

  Returns:
    Transitive closure of deps.
  """
  transitive_deps = {}
  for dep in deps:
    transitive_deps.update(dep.dart.transitive_deps)
    transitive_deps["%s" % dep.dart.label] = dep
  return transitive_deps


def _label_to_dart_package_name(label):
  """Returns the Dart package name for the specified label.

  Packages under //third_party/dart resolve to their external Pub package names.
  All other packages resolve to a unique identifier based on their repo path.

  Examples:
    //foo/bar/baz:           foo.bar.baz
    //third_party/dart/args: args
    //third_party/guice:     third_party.guice

  Restrictions:
    Since packages outside of //third_party/dart are identified by their path
    components joined by periods, it is an error for the label package to
    contain periods.

  Args:
    label: the label whose package name is to be returned.

  Returns:
    The Dart package name associated with the label.
  """
  package_name = label.package
  if label.package.startswith(_third_party_prefix):
    third_party_path = label.package[len(_third_party_prefix):]
    if "/" not in third_party_path:
      package_name = third_party_path
  if "." in package_name:
    fail("Dart package paths may not contain '.': " + label.package)
  return package_name.replace("/", ".")


def _new_dart_context(label,
                      package,
                      lib_root,
                      srcs=None,
                      data=None,
                      deps=None,
                      transitive_deps=None):
  return struct(
      label=label,
      package=package,
      lib_root=lib_root,
      srcs=srcs or [],
      data=data or [],
      deps=deps or [],
      transitive_deps=dict(transitive_deps or {}),
  )


def make_dart_context(label,
                      package=None,
                      lib_root=None,
                      srcs=None,
                      data=None,
                      deps=None):
  if not package:
    package = _label_to_dart_package_name(label)
  if not lib_root:
    lib_root = "%s/lib/" % label.package
  srcs = srcs or []
  data = data or []
  deps = deps or []
  transitive_deps = _collect_transitive_deps(deps)
  return struct(
      label=label,
      package=package,
      lib_root=lib_root,
      srcs=srcs,
      data=data,
      deps=deps,
      transitive_deps=transitive_deps,
  )


def _merge_dart_context(dart_ctx1, dart_ctx2):
  """Merges two dart contexts whose package and lib_root must be identical."""
  if dart_ctx1.package != dart_ctx2.package:
    fail("Incompatible packages: %s and %s" % (dart_ctx1.package,
                                               dart_ctx2.package))
  if dart_ctx1.lib_root != dart_ctx2.lib_root:
    fail("Incompatible lib_roots for package %s:\n" % dart_ctx1.package +
         "  %s declares: %s\n" % (dart_ctx1.label, dart_ctx1.lib_root) +
         "  %s declares: %s\n" % (dart_ctx2.label, dart_ctx2.lib_root) +
         "Targets in the same package must declare the same lib_root")

  transitive_deps = dart_ctx1.transitive_deps
  transitive_deps.update(dart_ctx1.transitive_deps)
  return _new_dart_context(
      label=dart_ctx1.label,
      package=dart_ctx1.package,
      lib_root=dart_ctx1.lib_root,
      srcs=dart_ctx1.srcs + dart_ctx2.srcs,
      data=dart_ctx1.data + dart_ctx2.data,
      deps=dart_ctx1.deps + dart_ctx2.deps,
      transitive_deps=transitive_deps,
  )


def collect_dart_context(dart_ctx, transitive=True, include_self=True):
  """Collects and returns dart contexts."""
  # Collect direct or transitive deps.
  dart_ctxs = [dart_ctx]
  if transitive:
    dart_ctxs += [d.dart for d in dart_ctx.transitive_deps.values()]
  else:
    dart_ctxs += [d.dart for d in dart_ctx.deps]

  # Optionally, exclude all self-packages.
  if not include_self:
    dart_ctxs = [c for c in dart_ctxs if c.package != dart_ctx.package]

  # Merge Dart context by package.
  ctx_map = {}
  for dc in dart_ctxs:
    if dc.package in ctx_map:
      dc = _merge_dart_context(ctx_map[dc.package], dc)
    ctx_map[dc.package] = dc
  return ctx_map


def package_spec_action(ctx, dart_ctx, output):
  """Creates an action that generates a Dart package spec.

  Arguments:
    ctx: The rule context.
    dart_ctx: The Dart context.
    output: The output package_spec file.
  """
  # There's a 1-to-many relationship between packages and targets, but
  # collect_transitive_packages() asserts that their lib_roots are the same.
  dart_ctxs = collect_dart_context(dart_ctx,
                                   transitive=True,
                                   include_self=True).values()

  # Generate the content.
  content = "# Generated by Bazel\n"
  for dc in dart_ctxs:
    relative_lib_root = _relative_path(dart_ctx.label.package, dc.lib_root)
    content += "%s:%s\n" % (dc.package, relative_lib_root)

  # Emit the package spec.
  ctx.actions.write(
      output=output,
      content=content,
  )


def _relative_path(from_dir, to_path):
  """Returns the relative path from a directory to a path via the repo root."""
  return "../" * (from_dir.count("/") + 1) + to_path


def layout_action(ctx, srcs, output_dir):
  """Generates a flattened directory of sources.

  For each file f in srcs, a file is emitted at output_dir/f.short_path.
  Returns a dict mapping short_path to the emitted file.

  Args:
    ctx: the build context.
    srcs: the set of input srcs to be flattened.
    output_dir: the full output directory path into which the files are emitted.

  Returns:
    A map from input file short_path to File in output_dir.
  """
  commands = []
  output_files = {}
  # TODO(cbracken) extract next two lines to func
  if not output_dir.endswith("/"):
    output_dir += "/"
  for src_file in srcs:
    dest_file = ctx.actions.declare_file(output_dir + src_file.short_path)
    dest_dir = dest_file.path[:dest_file.path.rfind("/")]
    link_target = _relative_path(dest_dir, src_file.path)
    commands += ["ln -s '%s' '%s'" % (link_target, dest_file.path)]
    output_files[src_file.short_path] = dest_file

  # Emit layout script.
  layout_cmd = ctx.actions.declare_file(ctx.label.name + "_layout.sh")
  ctx.actions.write(
      output=layout_cmd,
      content="#!/bin/bash\n" + "\n".join(commands),
      is_executable=True,
  )

  # Invoke the layout action.
  ctx.actions.run(
      inputs=list(srcs),
      outputs=output_files.values(),
      executable=layout_cmd,
      progress_message="Building flattened source layout for %s" % ctx,
      mnemonic="DartLayout",
  )
  return output_files
