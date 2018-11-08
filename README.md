# Mini-CookieCutter

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

It is important to note that `{FILETYPE}` is decided by vim and will NOT always be (though it usually is) the same as the filetype's traditional extension. For example, python templates must use `python` instead of `py`.

See my personal [templates](https://github.com/bbugyi200/dotfiles/tree/master/home/.local/share/minicc) for examples on how you can use templates.

##### Why do I need the {ID} part of the template syntax?
The short answer is that you shouldn't. A longer answer might explain why the following types of vim mappings are awesome and only possible when we tag each template with a numerical id:
```
nnoremap <Leader>0t :n ~/.local/share/minycc/*1.<C-R>=&filetype<CR><CR>
nnoremap <Leader>0T :n ~/.local/share/minycc/*2.<C-R>=&filetype<CR><CR>
```

### Template Declarations and Substitutions
While no where near as full-featured as the [jinja2](https://github.com/pallets/jinja) template engine that [cookiecutter](https://github.com/audreyr/cookiecutter) uses, there are a few special statements avaiable. The syntax will be familiar if you have used [jinja2](https://github.com/pallets/jinja) in the past:

##### Mark Start Point for Editor
If the following statement is found in the template, vim will start with the cursor
on that line (after removing the statement) and will start in INSERT mode:
```
{% START HERE %}
```

##### Variable Substitution
Mini-CookieCutter also recognizes the following special statement:
```
{{ env.foobar }}
```
where `foobar` represents an environment variable. This statement will be replaced
with the value of the environment variable `foobar`. If `foobar` is not defined,
the initialization process will hault and `minicc` will exit with a non-zero
status.

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

## Useful Shell Aliases / Functions

You can of course run the `minicc` script directly, but I have not found that to
be very convenient. Instead, I have created a variety of shell aliases and
functions which serve as custom initialization commands that are specific to a
single goal and filetype. Here are a few examples:

``` bash
alias ainit='minicc -F awk -D awk --use-extension=y'
alias binit='minicc -F sh'
alias Binit='minicc -F sh -T full'
hw() { ASSIGNMENT_NUMBER="$1" minicc -F tex -T hw -f -x -N "${@:2}" HW"$1"/hw"$1"; }
alias pyinit='minicc -F python'
alias Pyinit='minicc -F python -T test -f --executable=n --use-extension=y'
alias texinit='minicc -F tex -f --executable=n --use-extension=y'
```

## Examples

Let us now take a look at a few examples of how Mini-CookieCutter might be useful. 

For reference, these are the configuration settings that I use:
``` bash
PARENT_BIN_DIR="/home/bryan/Dropbox/bin"
DEFAULT_BIN_SUBDIR="main"
EXEC_HOOK_CMD=/usr/local/bin/clinks
```
where `/home/bryan/Dropbox/bin` is a home for [this](https://github.com/bbugyi200/scripts) GitHub repository. (The [clinks](https://github.com/bbugyi200/scripts/blob/master/main/clinks) script wraps a bunch of `stow` commands which makes creating symlinks to a system `bin` folder a walk in the park while still keeping my scripts organized and structured.)

To initialize a minimal bash script named `foo` into the `main` directory (where I keep most of my scripts), I could run the following command:
```
binit foo
```
However, suppose instead that I wanted to initialize a new productivity script named `bar` into the `GTD` directory. Furthermore, suppose that I know that `bar` might get complicated (and thus needs to scale well). I could then choose to run
```
Binit -D GTD bar
```
to initialize a full featured bash script (bells and whistles included) into the `GTD` directory.

## Installation

Installation is as simple as cloning the repository with `git clone https://github.com/bbugyi200/Mini-CookieCutter`, going into the project directory (`cd Mini-CookieCutter`), and then running `make install`.
