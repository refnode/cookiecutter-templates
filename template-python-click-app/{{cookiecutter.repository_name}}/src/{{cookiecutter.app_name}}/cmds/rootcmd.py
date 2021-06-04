# import stdlibs

# import 3rdparty libs
import click

# import local libs
from {{ cookiecutter.app_name }}.cmds.helloworldcmd import helloworld
from {{ cookiecutter.app_name }}.utils import versionutils

@click.group()
def rootcmd():
    """{{ cookiecutter.app_name }} commands"""
    pass

@rootcmd.command()
@click.pass_context
def version(ctx):
    """Print the version information"""
    click.echo(versionutils.get_version())


rootcmd.add_command(version)
rootcmd.add_command(helloworld)
