# import stdlibs

# import 3rdparty libs
import click

# import local libs
from {{ cookiecutter.app_name }}.utils import helloworldutils

@click.group()
def helloworld():
    """Hello World Commands"""
    pass


@helloworld.command()
@click.option("--name", "-n", required=True, help="The name to greet", envvar="USER")
@click.pass_context
def greet(ctx, name):
    """Greet a user"""
    click.echo(helloworldutils.greet(name))
