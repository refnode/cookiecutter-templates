#!/usr/bin/env python

# import stdlibs
# import 3rdparty libs
# import local libs
from {{ cookiecutter.app_name}}.cmds.rootcmd import rootcmd


def main():
    rootcmd()


if __name__ == "__main__":
    main()
