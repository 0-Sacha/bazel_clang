""

load("@bazel_utilities//toolchains:cc_toolchain_config.bzl", "cc_toolchain_config")

package(default_visibility = ["//visibility:public"])


filegroup(
    name = "toolchain_every_files",
    srcs = [
        "%{compiler_package}:toolchain_internal_every_files",
    ] + %{toolchain_extras_filegroups}
)

filegroup(
    name = "toolchain_internal_every_files",
    srcs = glob(["**"]),
)

cc_toolchain_config(
    name = "cc_toolchain_config_%{toolchain_id}",
    toolchain_identifier = "%{toolchain_id}",

    compiler_type = "clang",

    toolchain_bins = {
        "%{compiler_package}:cpp": "cpp",
        "%{compiler_package}:cc": "cc",
        "%{compiler_package}:cxx": "cxx",
        "%{compiler_package}:as": "as",
        "%{compiler_package}:ar": "ar",
        "%{compiler_package}:ld": "ld",

        "%{compiler_package}:objcopy": "objcopy",
        "%{compiler_package}:strip": "strip",

        "%{compiler_package}:cov": "cov",

        "%{compiler_package}:size": "size",
        "%{compiler_package}:nm": "nm",
        "%{compiler_package}:objdump": "objdump",
        "%{compiler_package}:dwp": "dwp",
        "%{compiler_package}:dbg": "dbg",
    },
    
    toolchain_builtin_includedirs = [
        "%{compiler_package_path}include/c++/v1",
        "%{compiler_package_path}include/x86_64-unknown-linux-gnu/c++/v1",

        # for use of the features.h file
        "/usr/include",
    ],

    copts = %{copts}, # [ "--no-standard-includes" ]
    conlyopts = %{conlyopts},
    cxxopts = %{cxxopts},
    linkopts = [ "-stdlib=%{stdlib}" ] + %{linkopts},
    defines = %{defines},
    includedirs = %{includedirs},
    linkdirs = [
        "/usr/lib",
        "%{compiler_package_path}lib/x86_64-unknown-linux-gnu",
    ] + %{linkdirs},

    linklibs = %{linklibs},
)

cc_toolchain(
    name = "cc_toolchain_%{toolchain_id}",
    toolchain_identifier = "%{toolchain_id}",
    toolchain_config = ":cc_toolchain_config_%{toolchain_id}",
    
    # TODO: Current fix for Sandboxed build # "%{compiler_package}:all_files",
    all_files = ":toolchain_every_files",
    compiler_files = ":toolchain_every_files",
    linker_files = ":toolchain_every_files",
    ar_files = ":toolchain_every_files",
    as_files = ":toolchain_every_files",
    objcopy_files = ":toolchain_every_files",
    strip_files = ":toolchain_every_files",
    dwp_files = ":toolchain_every_files",
    coverage_files = ":toolchain_every_files",

    # dynamic_runtime_lib
    # static_runtime_lib
    # supports_param_files
)

toolchain(
    name = "toolchain",
    toolchain = ":cc_toolchain_%{toolchain_id}",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",

    exec_compatible_with = %{exec_compatible_with},
    target_compatible_with = %{target_compatible_with},
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
        "include/c++/v1/**",
        "include/x86_64-unknown-linux-gnu/c++/v1/**",
        # "include/**"
    ]),
)

filegroup(
    name = "toolchain_libs",
    srcs = glob([
        "lib/x86_64-unknown-linux-gnu/**",
        # "lib/**",
    ]),
)

filegroup(
    name = "toolchain_bins",
    srcs = glob([
        "bin/*",
    ]),
)


filegroup(
    name = "all_files",
    srcs = [
        "%{compiler_package}:toolchain_includes",
        "%{compiler_package}:toolchain_libs",
        "%{compiler_package}:toolchain_bins",
    ],
)

filegroup(
    name = "compiler_files",
    srcs = [
        "%{compiler_package}:toolchain_includes",
        "%{compiler_package}:cpp",
        "%{compiler_package}:cc",
        "%{compiler_package}:cxx",
    ],
)

filegroup(
    name = "linker_files",
    srcs = [
        "%{compiler_package}:toolchain_libs",
        "%{compiler_package}:cc",
        "%{compiler_package}:cxx",
        "%{compiler_package}:ld",
        "%{compiler_package}:ar",
    ],
)

filegroup(
    name = "coverage_files",
    srcs = [
        "%{compiler_package}:toolchain_includes",
        "%{compiler_package}:toolchain_libs",
        "%{compiler_package}:cc",
        "%{compiler_package}:cxx",
        "%{compiler_package}:ld",
        "%{compiler_package}:cov",
    ],
)

filegroup(
    name = "compiler_components",
    srcs = [
        "%{compiler_package}:cpp",
        "%{compiler_package}:cc",
        "%{compiler_package}:cxx",
        "%{compiler_package}:ar",
        "%{compiler_package}:ld",

        "%{compiler_package}:objcopy",
        "%{compiler_package}:strip",

        "%{compiler_package}:cov",

        "%{compiler_package}:nm",
        "%{compiler_package}:objdump",
        "%{compiler_package}:as",
        "%{compiler_package}:size",
        "%{compiler_package}:dwp",
        
        "%{compiler_package}:dbg",
    ],
)
