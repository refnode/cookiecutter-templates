#!/usr/bin/env python

"""The setup script."""

from setuptools import setup, find_packages

with open("README.adoc") as fh_readme:
    readme = fh_readme.read()

install_reqs = []

setup(
    author="{{ cookiecutter.user_fullname.replace('\"', '\\\"') }}",
    author_email='{{ cookiecutter.user_email }}',
    python_requires='>=3.8',
    classifiers=[
        'Development Status :: 2 - Pre-Alpha',
        'Intended Audience :: Developers',
        'Natural Language :: English',
        'Programming Language :: Python :: 3',
        'Programming Language :: Python :: 3.8',
    ],
    description="{{ cookiecutter.project_description_short }}",
    install_requires=install_reqs,
    long_description=readme,
    include_package_data=True,
    keywords='{{ cookiecutter.repository_name }}',
    name='{{ cookiecutter.repository_name }}',
    packages=find_packages(where="src"),
    url='https://github.com/{{ cookiecutter.repository_namespace }}/{{ cookiecutter.repository_name }}',
    version='{{ cookiecutter.app_version }}',
    zip_safe=False,
)
