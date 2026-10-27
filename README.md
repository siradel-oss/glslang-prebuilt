# glslang-prebuilt

This repository provides Bazel rules for fetching the official prebuilt glslang
binaries from the [glslang GitHub releases](https://github.com/KhronosGroup/glslang/releases)
(available since glslang 16.5.0), and providing them as a Bazel toolchain. It is
meant to be used as a dependency in other Bazel project that implement Bazel
rules that use glslang.

## Usage

Add `glslang_prebuilt` as a dependency in your `MODULE.bazel` file:

```python
bazel_dep(name = "glslang_prebuilt", version = "...")
```

> [!NOTE]
> This module is not currently published to the Bazel Central Registry, hence
> you might need to use an [`archive_override`](https://bazel.build/rules/lib/globals/module#archive_override)
> or a [`git_override`](https://bazel.build/rules/lib/globals/module#git_override)
> to reference it.

The glslang license matching the released version is available as
`@glslang_prebuilt//glslang:LICENSE.txt`.

The toolchain type label is `@glslang_prebuilt//glslang:toolchain_type`. Please
refer to the [Bazel documentation](https://bazel.build/extending/toolchains) for
more information on how to consume toolchains in your project.

## Creating a release

To create a release, trigger an action workflow with the glslang version as
input. The workflow will compute the integrity hashes of the upstream glslang
release assets, fetch the glslang license, commit them to `main`, and create a
new tag and release on GitHub.

Go to the "Actions" tab, select the "Release prebuilt glslang" workflow, and
click on "Run workflow". Enter the glslang version (e.g., `16.6.0`, which must
match a [glslang release](https://github.com/KhronosGroup/glslang/releases) tag)
and click on "Run workflow" to start the release process.

If the workflow fails during the release process, fix the issue and re-run it.
If the release was created successfully, you can delete it from the "Releases"
tab, as well as the associated tag, to clean up the repository. This can happen
if files paths or URLs change.

If the test workflow fails but the release was successful, you can fix the
failure on main and just create a new tag, for example `16.6.0-1`. The metadata
associated with release `16.6.0` will be reused.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file
for details.
