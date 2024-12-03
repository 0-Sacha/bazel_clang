[![bazel_llvm_clang](https://github.com/0-Sacha/bazel_llvm_clang/actions/workflows/clang.yml/badge.svg)](https://github.com/0-Sacha/bazel_llvm_clang/actions/workflows/clang.yml)

# bazel_llvm_clang

A Bazel module that configure an hermetic clang toolchain for Linux

## How to Use
MODULE.bazel
```python
bazel_dep(name = "rules_cc", version = "0.0.10")
bazel_dep(name = "platforms", version = "0.0.10")

# use the latest commit avaible
git_override(module_name="bazel_utilities", remote="https://github.com/0-Sacha/bazel_utilities.git", commit="fbb17685ac9ba78fef914a322e6c37839dc16d4f")
git_override(module_name="bazel_llvm_clang", remote="https://github.com/0-Sacha/bazel_llvm_clang.git")

bazel_dep(name = "bazel_utilities", version = "0.0.1", dev_dependency = True)
bazel_dep(name = "bazel_llvm_clang", version = "0.0.1", dev_dependency = True)

llvm_clang_toolchain_extension = use_extension("@bazel_llvm_clang//:rules.bzl", "llvm_clang_toolchain_extension", dev_dependency = True)
inject_repo(llvm_clang_toolchain_extension, "platforms", "bazel_utilities")
llvm_clang_toolchain_extension.winlibs_toolchain(
    name = "llvm_clang",
    copts = [],
)
use_repo(llvm_clang_toolchain_extension, "myclang")
register_toolchains("@myclang//:toolchain")
```
It provide the toolchain `@<repo>//:toolchain`
You can use these toolchains to compile any cc_rules in your project.
