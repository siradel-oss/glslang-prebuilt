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

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
