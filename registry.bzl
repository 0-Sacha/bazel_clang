"""MinGW registry
"""

load("@bazel_utilities//toolchains:registry.bzl", "gen_archives_registry")

LLVM_19_1_0 = {
    "toolchain": "llvm",
    "version": "19.1.0",
    "version-short": "19.1",
    "latest": True,
    "details": { "clang_version": "19.1.0" },
    "archives": {
        "linux_x86_64": {
            "url": "https://github.com/llvm/llvm-project/releases/download/llvmorg-19.1.0/LLVM-19.1.0-Linux-X64.tar.xz",
            "sha256": "cee77d641690466a193d9b88c89705de1c02bbad46bde6a3b126793c0a0f2923",
            "strip_prefix": "LLVM-19.1.0-Linux-X64",
        }
    }
}

LLVM_REGISTRY = gen_archives_registry([
    LLVM_19_1_0,
])