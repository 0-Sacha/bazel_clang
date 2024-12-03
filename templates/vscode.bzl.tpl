""

load("@bazel_utilities//tools:vscode.bzl", _vscode_config = "vscode_config", _vscode_task = "vscode_task", _vscode_launch = "vscode_launch")

def vscode_config(name, **kwargs):
    """VS config for .vscode files

    Args:
        name: The rule name
        **kwargs: All others vscode_project attributes
    """
    _vscode_config(
        name = name,
        compiler = "@%{rctx_name}//:cxx",
        **kwargs
    )

def vscode_task(name, **kwargs):
    """Task setting config for .vscode files

    Args:
        name: The rule name
        **kwargs: All others vscode_task attributes
    """
    _vscode_task(
        name = name,
        **kwargs
    )

def vscode_launch(name, **kwargs):
    """Launch setting config for .vscode files

    Args:
        name: The rule name
        **kwargs: All others vscode_launch attributes
    """
    _vscode_launch(
        name = name,
        debugger = "@%{rctx_name}//:dbg",
        **kwargs
    )
