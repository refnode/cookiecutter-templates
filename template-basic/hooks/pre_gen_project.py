#!/usr/bin/env python

# import stdlibs
import re
import sys

# import 3rd-party libs
# import local libs


def fail_missing_param(param, exit_code=1):
    sys.stderr.write("\n")
    sys.stderr.write(
        "\n[Cookiecutter pre-check] Missing value for => {}\n\n".format(param)
    )
    sys.exit(exit_code)


def fail_invalid_value(param, value, exit_code=1):
    sys.stderr.write(
        "\n[Cookiecutter pre-check] Invalid value for => {}\n".format(param)
    )
    sys.stderr.write(
        "[Cookiecutter pre-check] Given value       => {}\n\n".format(value)
    )
    sys.exit(exit_code)


REGEX_TRUE_FALSE = r"^[yYnN]$"
REGEX_PROD_RELEASE = r"(prod|release)"


valid_params = {
    "user_fullname": {
        "check_enabled": True,
        "value": "{{ cookiecutter.user_fullname }}",
    },
    "user_name": {
        "check_enabled": True,
        "value": "{{ cookiecutter.user_name }}",
    },
    "user_email": {
        "check_enabled": True,
        "value": "{{ cookiecutter.user_email }}",
    },
    "team_name": {
        "check_enabled": True,
        "value": "{{ cookiecutter.team_name }}",
    },
    "team_email": {
        "check_enabled": True,
        "value": "{{ cookiecutter.team_email }}",
    },
    "project_name": {
        "check_enabled": True,
        "value": "{{ cookiecutter.project_name }}",
    },
    "project_description_short": {
        "check_enabled": True,
        "value": "{{ cookiecutter.project_description_short }}",
    },
    "repository_name": {
        "check_enabled": True,
        "value": "{{ cookiecutter.repository_name }}",
    },
    "repository_namespace": {
        "check_enabled": True,
        "value": "{{ cookiecutter.repository_namespace }}",
    },
    "repository_enable_renovate": {
        "check_enabled": True,
        "pattern": REGEX_TRUE_FALSE,
        "value": "{{ cookiecutter.repository_enable_renovate }}",
    },
    "repository_enable_git_precommit": {
        "check_enabled": True,
        "pattern": REGEX_TRUE_FALSE,
        "value": "{{ cookiecutter.repository_enable_git_precommit }}",
    },
    "repository_enable_conventionalcommit": {
        "check_enabled": True,
        "pattern": REGEX_TRUE_FALSE,
        "value": "{{ cookiecutter.repository_enable_conventionalcommit }}",
    },
    "repository_enable_docs": {
        "check_enabled": True,
        "pattern": REGEX_TRUE_FALSE,
        "value": "{{ cookiecutter.repository_enable_docs }}",
    },
    "repository_feature_markdown": {
        "check_enabled": True,
        "pattern": REGEX_TRUE_FALSE,
        "value": "{{ cookiecutter.repository_feature_markdown }}",
    },
    "repository_feature_asciidoc": {
        "check_enabled": True,
        "pattern": REGEX_TRUE_FALSE,
        "value": "{{ cookiecutter.repository_feature_asciidoc }}",
    },
    "repository_feature_toml": {
        "check_enabled": True,
        "pattern": REGEX_TRUE_FALSE,
        "value": "{{ cookiecutter.repository_feature_toml }}",
    },
    "repository_feature_yaml": {
        "check_enabled": True,
        "pattern": REGEX_TRUE_FALSE,
        "value": "{{ cookiecutter.repository_feature_yaml }}",
    },
    "repository_feature_json": {
        "check_enabled": True,
        "pattern": REGEX_TRUE_FALSE,
        "value": "{{ cookiecutter.repository_feature_json }}",
    },
    "repository_feature_shell": {
        "check_enabled": True,
        "pattern": REGEX_TRUE_FALSE,
        "value": "{{ cookiecutter.repository_feature_shell }}",
    }
}

for param in valid_params.keys():
    # should the check be enabled, if not set defaults to False
    check_enabled = valid_params[param].get("check_enabled", False)
    # is the value required, if not set defaults to True
    value_required = valid_params[param].get("required", True)
    # if regex pattern provided for value, check it, defaults to None
    value_pattern = valid_params[param].get("pattern")
    # the value as prompted
    value = valid_params[param]["value"]
    if not check_enabled:
        continue
    if value_required and not value:
        fail_missing_param(param)
    if value_pattern and not re.match(value_pattern, value):
        fail_invalid_value(param, value)


print("=" * 100)
print("Cookiecutter Template Summary")
print("-" * 100)
for param in valid_params.keys():
    value = valid_params[param]["value"]
    sys.stderr.write("%-40s: %-40s\n" % (param, value))
print("=" * 100)
