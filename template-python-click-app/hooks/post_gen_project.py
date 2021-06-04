#!/usr/bin/env python
import os

PROJECT_DIRECTORY = os.path.realpath(os.path.curdir)


def remove_file(filepath):
    os.remove(os.path.join(PROJECT_DIRECTORY, filepath))


def post_cleanup():
    if "{{ cookiecutter.repository_enable_renovate }}" != "y":
        remove_file("renovate.json")
    if "{{ cookiecutter.repository_enable_git_precommit }}" != "y":
        remove_file(".pre-commit-config.yaml")
    if "{{ cookiecutter.repository_enable_conventionalcommit }}" != "y":
        remove_file(".gitlint")


if __name__ == "__main__":
    post_cleanup()
