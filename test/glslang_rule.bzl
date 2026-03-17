# SPDX-FileCopyrightText: 2026 Siradel
# SPDX-License-Identifier: MIT

def _glslang_rule_impl(ctx):
    glslang_toolchain = ctx.toolchains["@glslang_prebuilt//glslang:toolchain_type"]
    output_file = ctx.actions.declare_file(ctx.label.name + ".spv")
    ctx.actions.run(
        inputs = [ctx.file.src],
        outputs = [output_file],
        executable = glslang_toolchain.tool,
        arguments = [
            "-V100",
            ctx.file.src.path,
            "-o",
            output_file.path,
        ],
    )
    return [DefaultInfo(files = depset([output_file]))]

glslang_rule = rule(
    implementation = _glslang_rule_impl,
    attrs = {
        "src": attr.label(allow_single_file = True, mandatory = True),
    },
    toolchains = ["@glslang_prebuilt//glslang:toolchain_type"],
)
