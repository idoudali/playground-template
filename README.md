# playground-template
Example of an integrate repo that is meant to be a "playground" where different projects / tools are brough and built together

# Quick Start

To work on this repo ensure that you have installed `commitizen` and `pre-commit`
in your environment:

References:

* [pre-commit](https://pre-commit.com/)
* [commitizen](https://commitizen-tools.github.io/commitizen/)

For example, to install the tools in your user environment:

```bash
pip install --user commitizen pre-commit
```

Read the [commitizen](https://commitizen-tools.github.io/commitizen/) documentation
regarding the type and quality of commits that we want to have in this repo.

After you have installed those packages you can install the pre-commit hooks

```bash
pre-commit install
```

## Commit workflow

Assuming that you have a number of modified files that you would like to commit
to this repo, you can use the following commands to commit your changes:

```bash
# Cherry pick only the changes that you want to commit
# from the modified files
# step 1
git add -up

# AVOID AT ALL COSTS ADDING ALL FILES TO THE REPO
# DO NOT ADD BY MISTAKE ANY BINARY OR LARGE FILES
# git add -a

# run the pre-commit checks
# step 2
pre-commit run

# Add any fixes that the pre-commit checks may have
# made or manual fixes you did by repeating step 1

# Commit the changes
# step 3
cz commit # To write a new commit

# Read you commit message and see if you are happy with it
tig

# or ammend it
git commit --amend
```
