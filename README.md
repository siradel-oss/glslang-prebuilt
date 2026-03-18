# glslang-prebuilt

This repository provides Bazel rules for fetching a prebuilt version of glslang from LunarG's Vulkan SDK, and providing it as a Bazel toolchain.
It is meant to be used as a dependency in other Bazel project that implement Bazel rules that use glslang.

## Usage

Add `glslang_prebuilt` as a dependency in your `MODULE.bazel` file:

```python
bazel_dep(name = "glslang_prebuilt", version = "...")
```

> [!NOTE]
> This module is not currently published to the Bazel Central Registry, hence you might need to use an [`archive_override`](https://bazel.build/rules/lib/globals/module#archive_override) or a [`git_override`](https://bazel.build/rules/lib/globals/module#git_override) to reference it.

The toolchain type label is `@glslang_prebuilt//glslang:toolchain_type`. Please refer to the [Bazel documentation](https://bazel.build/extending/toolchains) for more information on how to consume toolchains in your project.

## Creating a release

To create a release, trigger an action workflow with the Vulkan SDK version and glslang version as input.
The workflow will create a new release on GitHub and upload the prebuilt glslang binary as an asset.

Go to the "Actions" tab, select the "Download and release prebuilt glslang" workflow, and click on "Run workflow".
Enter the Vulkan SDK version and glslang version (e.g., `1.2.182.0` and `15.0.7`) and click on "Run workflow" to start the release process.
To check what glslang version corresponds to a Vulkan SDK version, you can check the [Vulkan SDK release notes](https://vulkan.lunarg.com/doc/sdk), follow the link to the Github repository for glslang section, how check what release tag the `vulkan-sdk-x.y.z` tag corresponds to.

If the workflow fails during the release process, fix the issue and re-run it. If the release was created successfully, you can delete it from the "Releases" tab, as well as the associated tag, to clean up the repository. This can happen if files paths or URLs change.

If the test workflow fails but the release was successful, you can fix the failure on main and just create a new tag, for example `15.0.7-1`. The metadata associated with release `15.0.7` will be reused.

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
