# cookie

**Stop repeating yourself! Cookie templates make writing scripts, LaTeX documents, Makefiles, and other one-off files easier than ever!**

## Usage
```
Usage: cookie [-c] [-d] [-D BIN_SUBDIR] [-e TEMPLATE] [-f] [-h] [-x | --executable={y|n}] [-v] [-T TEMPLATE] TARGET

Initializes a new file (`TARGET`) using a predefined template (`TEMPLATE`).
The target file can be a new script, configuration file, markup file, etc....
After the target file has been initialized, it is opened for editing using the
system's default editor.

Command-line Options:
    -d | --debug
        Enable debug mode.

    -c | --config
        Edit the configuration file.

    -D DIR | --bin-subdir DIR
        Initialize TARGET into DIR, which should be a subdirectory of the
        default bin directory (see the configuration file).

    -e TEMPLATE | --edit TEMPLATE
        Add / edit cookie template.

    --executable={y|n}
        Make TARGET executable. Defaults to 'n'.

    -f | --force
        Force TARGET initialization to be relative to the current
        directory.

    -h | --help
        View this help message.

    -l | --list
        List available templates.

    -T TEMPLATE | --template TEMPLATE
        The name of the template (e.g. mytemplate.sh).

    -x
        Equivalent to --executable=y

    -v | --verbose
        Enable verbose output.
```

## Templates

Templates are stored in the directory specified by `$COOKIE_DIR` which, if not specified in the configuration file (see the [Configuration](#config) section), defaults to `~/.cookiecutters` (the same directory used by `cookiecutter` to store templates).

See my personal [templates] for examples on how you can use templates.

### Template Variables and Statements
While not as full-featured as the [jinja] template engine that [cookiecutter] uses, there are a few special variables and statements available. The syntax for these will be familiar if you have used [jinja] in the past.

#### Variable Substitution
cookie also recognizes template variables of the form:
```
{{ foobar }}
```
This string will be replaced by the value of the environment variable `foobar` if it exists. Otherwise, the user will be prompted to provide a value for `foobar` on the command-line.

To ensure compatibility with files in cookiecutter templates, you may also preface the variable with `cookiecutter` followed by a period. Hence, the following statement is equivalent to the one discussed above:
``` 
{{ cookiecutter.foobar }}
```

#### Mark Start Point for Editing (only works when vim is set as the default system editor)
If the following statement is found in the template, vim will start with the cursor on that line (after removing the statement) and will start in INSERT mode:
```
{% START INSERT HERE %}
```

The following statement does the same thing but will start vim in NORMAL mode (vim's default behavior):
```
{% START NORMAL HERE %}
```

## <a name="config">Configuration</a>

The configuration file can be found at `$XDG_CONFIG_HOME/cookie/config`. The following options are available:

``` ini
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

# The directory used to store cookie templates.
# 
# Defaults to "~/.cookiecutters".
COOKIE_DIR=
```

## Using Shell Aliases / Functions

You can of course run `cookie` directly, but I have not found that to
be very convenient. Instead, I have created a variety of shell aliases and
functions which serve as custom initialization commands that are specific to a
single goal and filetype. Here are a few examples:

``` bash
alias ainit='cookie -T template.awk -D awk -x'
alias binit='cookie -T minimal.sh -x'
alias Binit='cookie -T full.sh -x'
hw() { ASSIGNMENT_NUMBER="$1" cookie -T hw.tex -f "${@:2}" HW"$1"/hw"$1".tex; }
alias minit='cookie -T c.make -f Makefile'
alias mtinit='cookie -T gtest.make -f Makefile'
alias pyinit='cookie -T template.py -x'
pytinit() { cookie -T pytest.py -f test_"$1".py; }
alias texinit='cookie -T template.tex -f'
```

## Examples

Let us now take a look at a few examples of how cookie might be useful. 

For reference, my personal cookie templates can be found [here][templates] and these are the configuration settings that I use:
``` bash
PARENT_BIN_DIR="/home/bryan/Dropbox/bin"
DEFAULT_BIN_SUBDIR="main"
EXEC_HOOK_CMD=/usr/local/bin/clinks
```
where `/home/bryan/Dropbox/bin` is a home for [this][scripts] GitHub repository. (The [clinks] script wraps a bunch of [stow] commands which makes creating symlinks to a system `bin` folder a walk in the park while still keeping my scripts organized the way I like in my filesystem.)

To initialize a minimal bash script named `foo` into the `/home/bryan/Dropbox/main` directory (where I keep most of my scripts), I could run the following command:
```
binit foo
```
Suppose instead that I wanted to initialize a new productivity script named `bar` into the `/home/bryan/Dropbox/GTD` directory. Furthermore, suppose that I know that `bar` might get complicated (and thus needs to scale well). I could then choose to run
```
Binit -D GTD bar
```
to initialize a full featured bash script (bells and whistles included) into the `/home/bryan/Dropbox/GTD` directory.

## Installation

Installation is as simple as cloning the repository with `git clone --recursive https://github.com/bbugyi200/cookie`, traveling into the project directory (`cd cookie`), and then running `make install`.

[jinja]: https://github.com/pallets/jinja
[cookiecutter]: https://github.com/audreyr/cookiecutter
[scripts]: https://github.com/bbugyi200/scripts
[clinks]: https://github.com/bbugyi200/scripts/blob/master/main/clinks
[templates]: https://github.com/bbugyi200/dotfiles/tree/master/.cookiecutters
[stow]: https://www.gnu.org/software/stow/manual/stow.html
