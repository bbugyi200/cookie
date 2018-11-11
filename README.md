# cookie

Usage: `cookie [-c] [-d] [-D BIN_SUBDIR] [-f] [-h] [-N | --executable={y|n}] [-x | --use-extension={y|n}] [-v] [-T TEMPLATE] TARGET`

Initializes the `TARGET` file using a predefined template. `TARGET` can be a
new script, configuration file, markup file, etc.... After the `TARGET` file
has been initialized, it is opened for editing.

This project was inspired by [cookiecutter].

## Command-line Options
```
-d | --debug
Enable debug mode.

-c | --config
Edit the configuration file.

-D DIR | --bin-subdir DIR
Initialize TARGET into DIR, which should be a subdirectory of the
default bin directory (see the configuration file).

--executable={y|n}
Make TARGET executable. Defaults to 'y'.

-f | --force
Force TARGET initialization to be relative to the current
directory.

-h | --help
View this help message.

-N
Equivalent to --executable=n.

-T TEMPLATE | --template TEMPLATE
The name of the template (e.g. mytemplate.sh).

--use-extension={y|n}
Append file extension to TARGET. Defaults to 'n'.

-x
Equivalent to --use-extension=y

-v | --verbose
Enable verbose output.
```

## Templates

Templates should be stored in the `$XDG_DATA_HOME/cookie` directory.

See my personal [templates] for examples on how you can use templates.

### Template Variables and Statements
While not as full-featured as the [jinja] template engine that [cookiecutter] uses, there are a few special variables and statements available. The syntax for these will be familiar if you have used [jinja] in the past.

##### Mark Start Point for Editing
If the following statement is found in the template, vim will start with the cursor on that line (after removing the statement) and will start in INSERT mode:
```
{% START HERE %}
```
The above statement only works when vim is set as the default system editor. 

##### Variable Substitution
cookie also recognizes template variables of the form:
```
{{ foobar }}
```
This string will be replaced by the value of the environment variable `foobar` if it exists. Otherwise, the user will be prompted to provide a value for `foobar` on the command-line.

To ensure compatibility with files in cookiecutter templates, you may also preface the variable with `cookiecutter` followed by a period. Hence, the following statement is equivalent to the one discussed above:
``` 
{{ cookiecutter.foobar }}
```


## Configuration File

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
```

## Using Shell Aliases / Functions

You can of course run `cookie` directly, but I have not found that to
be very convenient. Instead, I have created a variety of shell aliases and
functions which serve as custom initialization commands that are specific to a
single goal and filetype. Here are a few examples:

``` bash
alias ainit='cookie -T template.awk -D awk --use-extension=y'
alias binit='cookie -T minimal.sh'
alias Binit='cookie -T full.sh'
hw() { ASSIGNMENT_NUMBER="$1" cookie -T hw.tex -f -x -N "${@:2}" HW"$1"/hw"$1"; }
alias minit='cookie -T c.make -f --executable=n Makefile'
alias mtinit='cookie -T gtest.make -f --executable=n Makefile'
alias pyinit='cookie -T template.py'
alias pytinit='cookie -T pytest.py -f --executable=n --use-extension=y'
alias texinit='cookie -T template.tex -f --executable=n --use-extension=y'
```

## Examples

Let us now take a look at a few examples of how cookie might be useful. 

For reference, these are the configuration settings that I use:
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
[templates]: https://github.com/bbugyi200/dotfiles/tree/master/.local/share/cookie
[stow]: https://www.gnu.org/software/stow/manual/stow.html
