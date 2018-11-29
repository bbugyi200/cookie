# Change Log

All notable changes to this project will be documented in this file. This project adheres to
[Semantic Versioning](https://semver.org/), though minor breaking changes can happen in minor
releases.

### Unreleased

Added:

* The `--remove` option.
* Upgraded the startline template statements so now vim will identify the column number of the statement as well as the line number. In effect, cookie is now able to start vim with the cursor positioned at the exact spot where the startline statement was.
* A ZSH completion script to the GitHub repository and into the standard `install` rule for the project's Makefile.
* The `--mode` option for setting file mode bits.

Changed:

* The syntax for startline template statements (cookie now uses `{% INSERT %}` and `{% NORMAL %}`).
* The `-T` option to `-t`.

Removed:

* The `--executable` option

### v0.1.1 (2018-11-18)

Fixed:

* When user is in root dir, default subdir should be used.
* Spaces in template variables should be optional.
* With variables with repeated occurrences in the template, cookie was
  forgetting the variables value and thus prompting the user repeatedly
  for the same variable.
* `EXEC_HOOK_CMD` was not evaluating `${TARGET}`.
* Can now use absolute path with `TARGET` argument.

### v0.1.0 (2018-11-13)

* First Release
