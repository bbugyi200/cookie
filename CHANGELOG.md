# Change Log

All notable changes to this project will be documented in this file. This project adheres to
[Semantic Versioning](https://semver.org/), though minor breaking changes can happen in minor
releases.

### Unreleased

Fixed:

* When user is in root dir, default subdir should be used
* Spaces in template variables should be optional
* With variables with repeated occurrences in the template, cookie was
  forgetting the variables value and thus prompting the user repeatedly
  for the same variable.

### v0.1.0 (2018-11-13)

* First Release
