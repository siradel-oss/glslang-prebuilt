# SPDX-FileCopyrightText: 2026 Siradel
# SPDX-License-Identifier: MIT

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load(":release_info.bzl", "RELEASE_INFO")

def _executable_path(os):
    if os == "windows":
        return "Bin/glslang.exe"
    elif os == "linux":
        return "bin/glslang"
    else:
        fail("Unsupported OS: {}".format(os))

def _prebuilt_repo_name(os, cpu):
    return "glslang_prebuilt_{}_{}".format(os, cpu)

def _glslang_prebuilt_setup(name, url, integrity, os, prefix):
    executable_path = _executable_path(os)

    http_archive(
        name = name,
        urls = [url],
        integrity = integrity,
        strip_prefix = prefix,
        build_file_content = """
exports_files(["{executable_path}"])
""".format(executable_path = executable_path),
    )

def _glslang_toolchains_impl(ctx):
    build_file_content = """
load("@glslang_prebuilt//glslang:toolchain.bzl", "declare_toolchain")
package(default_visibility = ["//visibility:public"])
"""

    for info in RELEASE_INFO:
        repo_name = _prebuilt_repo_name(info["os"], info["cpu"])
        build_file_content += """
declare_toolchain(
    name = "{repo_name}_toolchain",
    tool = "@{repo_name}//:{executable_path}",
    os = "{os}",
    cpu = "{cpu}",
)
""".format(
            repo_name = repo_name,
            executable_path = _executable_path(info["os"]),
            os = info["os"],
            cpu = info["cpu"],
        )

    ctx.file("BUILD.bazel", build_file_content)

_glslang_toolchains = repository_rule(
    implementation = _glslang_toolchains_impl,
)

def _prebuilt_extension_impl(ctx):
    for info in RELEASE_INFO:
        repo_name = _prebuilt_repo_name(info["os"], info["cpu"])
        _glslang_prebuilt_setup(
            name = repo_name,
            url = info["url"],
            integrity = info["integrity"],
            os = info["os"],
            prefix = info["prefix"],
        )

    _glslang_toolchains(
        name = "glslang_prebuilt_toolchains",
    )

    return ctx.extension_metadata(reproducible = True)

prebuilt_extension = module_extension(
    implementation = _prebuilt_extension_impl,
)
