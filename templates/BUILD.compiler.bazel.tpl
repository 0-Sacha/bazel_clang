""

package(default_visibility = ["//visibility:public"])

filegroup(
    name = "toolchain_internal_every_files",
    srcs = glob(["**"]),
)


filegroup(
    name = "cpp",
    srcs = ["bin/clang-cpp"],
)
filegroup(
    name = "cc",
    srcs = ["bin/clang"],
)
filegroup(
    name = "cxx",
    srcs = ["bin/clang++"],
)
filegroup(
    name = "as",
    srcs = ["bin/llvm-as"],
)
filegroup(
    name = "ar",
    srcs = ["bin/llvm-ar"],
)
filegroup(
    name = "ld",
    srcs = ["bin/lld"],
)

filegroup(
    name = "objcopy",
    srcs = ["bin/llvm-objcopy"],
)
filegroup(
    name = "strip",
    srcs = ["bin/llvm-strip"],
)

filegroup(
    name = "cov",
    srcs = ["bin/llvm-cov"],
)

filegroup(
    name = "size",
    srcs = ["bin/llvm-size"],
)
filegroup(
    name = "nm",
    srcs = ["bin/llvm-nm"],
)
filegroup(
    name = "objdump",
    srcs = ["bin/llvm-objdump"],
)
filegroup(
    name = "dwp",
    srcs = ["bin/llvm-dwp"],
)

filegroup(
    name = "dbg",
    srcs = ["bin/lldb"],
)


filegroup(
    name = "toolchain_includes",
    srcs = glob([
        "include/c++/v1/**"
        # "include/**"
    ], allow_empty = True),
)

filegroup(
    name = "toolchain_libs",
    srcs = glob([
        "lib/x86_64-unknown-linux-gnu/**"
        # "lib/**",
    ], allow_empty = True),
)

filegroup(
    name = "toolchain_bins",
    srcs = glob([
        "bin/*",
    ], allow_empty = True),
)
