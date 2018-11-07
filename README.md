# Mini CookieCutter

Usage: `minicc [-d] [-D BIN_SUBDIR] [-f] [-h] [-N | --executable={y|n}] [-x | --use-extension={y|n}] [-T TEMPLATE_ID] [-v] -F FILETYPE TARGET`

Initializes TARGET file using a predefined template. TARGET can be a new script,
configuration file, markup file, etc.... After TARGET has been initialized, it
is opened in vim.

This project was inspired by [cookiecutter](https://github.com/audreyr/cookiecutter).

## Command-line Options
```
    -d | --debug
        Enable debug mode.

    -D DIR | --bin-subdir DIR
        Initialize TARGET into DIR, which should be a subdirectory of the
        default bin directory (see the configuration file).

    --executable={y|n}
        Make TARGET executable. Defaults to 'y'.

    -f | --force
        Force TARGET initialization to be relative to the current
        directory.

    -F FILETYPE | --filetype FILETYPE
        The filetype of the template. The TARGET (once initialized) will
        share this filetype.

    -h | --help
        View this help message.

    -N
        Equivalent to --executable=n.

    -T ID | --template-id ID
        Specify the desired template's identifier. May be either the template's
        numerical identifier or its more friendly (and optional) specifier.
        e.g. The template 'foo.2.python' can be specified by using either '2'
        or 'foo' as the template id.

    --use-extension={y|n}
        Append file extension to TARGET. Defaults to 'n'.

    -x
        Equivalent to --use-extension=y

    -v | --verbose
        Enable verbose output.
```

## Templates

Templates should be stored in the `$XDG_DATA_HOME/minicc` directory and must have
the following format: `[{NAME}.]{ID}.{FILETYPE}` where `{NAME}` is optional and
can be used as a custom specifier for the template, `{ID}` is an integer, and `{FILETYPE}` is the filetype of the template.

See my personal [templates](https://github.com/bbugyi200/dotfiles/tree/master/home/.local/share/minicc) for examples on how you can use templates.

##### NOTE
`{FILETYPE}` is decided by vim and will NOT always be (though it usually is) the same as the filetype's traditional extension. For example, python templates must use `python` instead of `py`.

## Configuration File

The `minicc` script looks for a configuration file at `$XDG_CONFIG_HOME/minicc/config`. The following settings are available:

``` bash
# The target file will be initialized in a location relative to this directory
# unless you specify the `-f` option. In which case the target file will be
# initialized relative to the current directory.
#
# Defaults to "./" (the current directory).
PARENT_BIN_DIR=

# The target file is initialized in $PARENT_BIN_DIR/$DEFAULT_BIN_SUBDIR
# unless the `-D {DIR}` option is used. In which case the target file will
# be initialized to $PARENT_BIN_DIR/{DIR}.
DEFAULT_BIN_SUBDIR=

# If specified, this command is evaluated after (and if) the target file
# has its executable bit set. This can be used to create symlinks to
# the target file (using `stow`, for example).
#
# The $TARGET variable, which contains the full path of the target file,
# will be injected into the environment of this command.
EXEC_HOOK_CMD=
```

## Installation

Installation is as simple as cloning the repository with `git clone https://github.com/bbugyi200/minicc` and then running `make install`.
