# import stdlibs

# import 3rdparty libs
import pytest

# import local libs
from {{ cookiecutter.app_name }}.utils import helloworldutils


def test_greet():
    assert helloworldutils.greet("testuser").startswith("Hello testuser")
