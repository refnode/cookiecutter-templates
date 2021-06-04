# import stdlibs

# import 3rdparty libs
import pytest

# import local libs
from {{ cookiecutter.app_name }}.utils import versionutils


def test_version():
    assert versionutils.get_version() == "0.0.0"
