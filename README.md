# Mini CookieCutter

Initializes TARGET file using a predefined template. TARGET can be a new script,
configuration file, markup file, etc.... After TARGET has been initialized, it
is opened in vim.

This project was inspired by [cookiecutter](https://github.com/audreyr/cookiecutter).

## Configuration File

The `minicc` script looks for a configuration file at `$XDG_DATA_HOME/minicc/config`. The following settings are available:

``` bash
# The target file will be initialized in a location relative to this directory
# unless you specify the `-f` option. In which case the target file will be
# initialized relative to the current directory.
#
# Defaults to "./" (the current directory).
PARENT_BIN_DIR=

# The target file is initialized in $PARENT_BIN_DIR/$DEFAULT_BIN_SUBDIR
# unless the `-D {DIR}` option is used. In which case the target file will
# be initialized to $PARENT_BIN_DIR/{DIR}
DEFAULT_BIN_SUBDIR=

# If specified, this command is evaluated after (and if) the target file
# has its executable bit set. This can be used to create symlinks to
# the target file (using `stow`, for example).
#
# The $TARGET--which contains the full path of the target file--variable
# will be injected into the environment of this command.
EXEC_HOOK_CMD=
```
