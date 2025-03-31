""

load("@bazel_skylib//lib:sets.bzl", "sets")
load("@bazel_utilities//toolchains:extras_filegroups.bzl", "filegroup_translate_to_starlark")
load("@bazel_utilities//toolchains:hosts.bzl", "get_host_infos_from_rctx", "split_host_name")
load("@bazel_utilities//toolchains:registry.bzl", "get_archive_from_registry")
load("@bazel_llvm_clang//:registry.bzl", "LLVM_REGISTRY")

def _llvm_clang_compiler_archive_impl(rctx):
    host_os, _, host_name = get_host_infos_from_rctx(rctx.os.name, rctx.os.arch)
    if rctx.attr.override_host_name != "" and rctx.attr.override_host_name != "local":
        host_os, _, host_name = split_host_name(rctx.attr.override_host_name)
    
    registry = json.decode(rctx.attr.registry_json)
    archive = get_archive_from_registry(registry, "llvm", rctx.attr.clang_version)

    substitutions = {
        "%{rctx_name}": rctx.name,
        "%{rctx_path}": "external/{}/".format(rctx.name),
        "%{host_name}": host_name,
        "%{clang_version}": archive["details"]["clang_version"],
    }
    rctx.template(
        "BUILD.bazel",
        Label("//templates:BUILD.compiler.bazel.tpl"),
        substitutions
    )

    host_archive = archive["archives"][host_name]
    rctx.download_and_extract(
        url = host_archive["url"],
        sha256 = host_archive["sha256"],
        stripPrefix = host_archive["strip_prefix"],
    )

llvm_clang_compiler_archive = repository_rule(
    implementation = _llvm_clang_compiler_archive_impl,
    attrs = {
        'override_host_name': attr.string(default = "local"),

        'clang_version': attr.string(default = "latest"),
        'registry_json': attr.string(mandatory = True),
    },
)


def _llvm_clang_impl(rctx):
    host_os, _, host_name = get_host_infos_from_rctx(rctx.os.name, rctx.os.arch)
    if rctx.attr.override_host_name != "" and rctx.attr.override_host_name != "local":
        host_os, _, host_name = split_host_name(rctx.attr.override_host_name)

    registry = json.decode(rctx.attr.registry_json)
    archive = get_archive_from_registry(registry, "llvm", rctx.attr.clang_version)

    toolchain_path = "external/{}/".format(rctx.name)
    compiler_package = ""
    compiler_full_package = "@@{}//".format(rctx.name)
    compiler_package_path = toolchain_path
    if rctx.attr.compiler_archive_package != None and rctx.attr.compiler_archive_package != "":
        compiler_package = "@@{}//".format(rctx.attr.compiler_archive_package.repo_name)
        compiler_full_package = compiler_package
        compiler_package_path = rctx.attr.compiler_archive_package.workspace_root + "/"

    substitutions = {
        "%{rctx_name}": rctx.name,
        "%{toolchain_path}": toolchain_path,
        "%{host_name}": host_name,
        "%{toolchain_id}": "llvm_clang_{}".format(rctx.attr.clang_version),
        "%{clang_version}": archive["details"]["clang_version"],
        "%{compiler_package}": compiler_package,
        "%{compiler_full_package}": compiler_full_package,
        "%{compiler_package_path}": compiler_package_path,
        
        "%{exec_compatible_with}": json.encode(rctx.attr.exec_compatible_with),
        "%{target_compatible_with}": json.encode(rctx.attr.target_compatible_with),

        "%{toolchain_builtin_includedirs_isystem}": json.encode(rctx.attr.toolchain_builtin_includedirs_isystem),
        "%{toolchain_builtin_includedirs}": json.encode(rctx.attr.toolchain_builtin_includedirs),
        
        "%{copts}": json.encode(rctx.attr.copts),
        "%{conlyopts}": json.encode(rctx.attr.conlyopts),
        "%{cxxopts}": json.encode(rctx.attr.cxxopts),
        "%{linkopts}": json.encode(rctx.attr.linkopts),
        "%{defines}": json.encode(rctx.attr.defines),
        "%{includedirs}": json.encode(rctx.attr.includedirs),
        "%{linkdirs}": json.encode(rctx.attr.linkdirs),
        "%{linklibs}": json.encode(rctx.attr.linklibs),
        # dbg / opt
        "%{dbg_copts}": json.encode(rctx.attr.dbg_copts),
        "%{dbg_linkopts}": json.encode(rctx.attr.dbg_linkopts),
        "%{opt_copts}": json.encode(rctx.attr.opt_copts),
        "%{opt_linkopts}": json.encode(rctx.attr.opt_linkopts),

        "%{stdlib}": rctx.attr.stdlib,
        
        "%{toolchain_extras_filegroups}": json.encode(filegroup_translate_to_starlark(rctx.attr.toolchain_extras_filegroups), ),
    }
    rctx.template(
        "BUILD.bazel",
        Label("//templates:BUILD.bazel.tpl"),
        substitutions
    )
    rctx.template(
        "vscode.bzl",
        Label("//templates:vscode.bzl.tpl"),
        substitutions
    )

    if rctx.attr.compiler_archive_package == None or rctx.attr.compiler_archive_package == "":
        host_archive = archive["archives"][host_name]
        rctx.download_and_extract(
            url = host_archive["url"],
            sha256 = host_archive["sha256"],
            stripPrefix = host_archive["strip_prefix"],
        )

llvm_clang_toolchain = repository_rule(
    implementation = _llvm_clang_impl,
    attrs = {
        'override_host_name': attr.string(default = "local"),

        'clang_version': attr.string(default = "latest"),
        'registry_json': attr.string(default = json.encode(LLVM_REGISTRY)),

        'exec_compatible_with': attr.string_list(default = []),
        'target_compatible_with': attr.string_list(default = []),

        'toolchain_builtin_includedirs_isystem': attr.string_list(default = []),
        'toolchain_builtin_includedirs': attr.string_list(default = []),

        'copts': attr.string_list(default = []),
        'conlyopts': attr.string_list(default = []),
        'cxxopts': attr.string_list(default = []),
        'linkopts': attr.string_list(default = []),
        'defines': attr.string_list(default = []),
        'includedirs': attr.string_list(default = []),
        'linkdirs': attr.string_list(default = []),
        'linklibs': attr.string_list(default = []),
        # dbg / opt
        'dbg_copts': attr.string_list(default = []),
        'dbg_linkopts': attr.string_list(default = []),
        'opt_copts': attr.string_list(default = []),
        'opt_linkopts': attr.string_list(default = []),

        'stdlib': attr.string(default = "libstdc++"),

        'toolchain_extras_filegroups': attr.label_list(default = []),

        'compiler_archive_package': attr.label(default = None),
    },
)

def _llvm_clang_toolchain_extension_impl(module_ctx):
    toolchain_versions_list = [
        (toolchain.override_host_name, toolchain.clang_version)
        for mod in module_ctx.modules 
        for toolchain in mod.tags.llvm_clang_toolchain
    ]
    if len(toolchain_versions_list) == 0:
        toolchain_versions_list.append(("local", "latest"))
    toolchain_versions_list = sets.to_list(sets.make(toolchain_versions_list))

    llvm_registry = LLVM_REGISTRY
    for toolchains_version in toolchain_versions_list:
        llvm_clang_compiler_archive(
            name = "archive_llvm_clang-{}-{}".format(toolchains_version[0], toolchains_version[1]),
            clang_version = toolchains_version[1],
            registry_json = json.encode(llvm_registry),
            override_host_name = toolchains_version[0],
        )
    
    for mod in module_ctx.modules:
        for toolchain in mod.tags.llvm_clang_toolchain:
            llvm_clang_toolchain(
                name = toolchain.name,
                clang_version = toolchain.clang_version,
                
                exec_compatible_with = toolchain.exec_compatible_with,
                target_compatible_with = toolchain.target_compatible_with,

                toolchain_builtin_includedirs_isystem = toolchain.toolchain_builtin_includedirs_isystem,
                toolchain_builtin_includedirs = toolchain.toolchain_builtin_includedirs,

                copts = toolchain.copts,
                conlyopts = toolchain.conlyopts,
                cxxopts = toolchain.cxxopts,
                linkopts = toolchain.linkopts,
                defines = toolchain.defines,
                includedirs = toolchain.includedirs,
                linkdirs = toolchain.linkdirs,
                linklibs = toolchain.linklibs,
                # dbg / opt
                dbg_copts = toolchain.dbg_copts,
                dbg_linkopts = toolchain.dbg_linkopts,
                opt_copts = toolchain.opt_copts,
                opt_linkopts = toolchain.opt_linkopts,

                stdlib = toolchain.stdlib,

                toolchain_extras_filegroups = toolchain.toolchain_extras_filegroups,

                compiler_archive_package = "@archive_llvm_clang-{}-{}".format(toolchain.override_host_name, toolchain.clang_version),

                override_host_name = toolchain.override_host_name,
            )
    
llvm_clang_toolchain_extension = module_extension(
    implementation = _llvm_clang_toolchain_extension_impl,
    tag_classes = {
        "llvm_clang_toolchain": tag_class(attrs = {
            'override_host_name': attr.string(default = "local"),

            'name': attr.string(mandatory = True),
            'clang_version': attr.string(default = "latest"),

            'compiler_archive_package': attr.label(default = None),

            'exec_compatible_with': attr.string_list(default = []),
            'target_compatible_with': attr.string_list(default = []),

            'toolchain_builtin_includedirs_isystem': attr.string_list(default = []),
            'toolchain_builtin_includedirs': attr.string_list(default = []),

            'copts': attr.string_list(default = []),
            'conlyopts': attr.string_list(default = []),
            'cxxopts': attr.string_list(default = []),
            'linkopts': attr.string_list(default = []),
            'defines': attr.string_list(default = []),
            'includedirs': attr.string_list(default = []),
            'linkdirs': attr.string_list(default = []),
            'linklibs': attr.string_list(default = []),
            # dbg / opt
            'dbg_copts': attr.string_list(default = []),
            'dbg_linkopts': attr.string_list(default = []),
            'opt_copts': attr.string_list(default = []),
            'opt_linkopts': attr.string_list(default = []),

            'stdlib': attr.string(default = "libstdc++"),

            'toolchain_extras_filegroups': attr.label_list(default = []),
        }),
    },
)
