#!/usr/bin/env python3
from os import getcwd, environ
from os.path import join
from datetime import datetime


def cli():
    @command
    def up():
        """Start development environment"""
        compose("development")("up", "--detach", "--build")

    @command
    def sh():
        """Open a shell into the server container"""
        compose("development")("exec", "weather-station-server", "bash")

    @command
    def logs():
        """Display the server container logs"""
        compose("development")("logs", "-f", "weather-station-server")

    @command
    def publish():
        """Publish a relase build of the service"""
        version = datetime.utcnow().strftime("%Y%m%d_%H%M%S")
        env = dict(environ, TAG=version)
        compose("build")("build", env=env)
        compose("build")("push", "weather-station-server", env=env)


def compose(target):
    def _(*args, **kwargs):
        compose_files = ["docker-compose.yml", f"docker-compose.{target}.yml"]
        compose_files_args = sum(
            (["--file", join(getcwd(), "src", "docker", f)] for f in compose_files), []
        )
        cmd(
            "docker",
            "compose",
            *compose_files_args,
            "--project-directory",
            getcwd(),
            *args,
            **kwargs,
        )

    return _


# fmt: off
# https://gist.github.com/sirikon/d4327b6cc3de5cc244dbe5529d8f53ae
import inspect, sys, os, subprocess, re;commands = [];args = sys.argv[1:]
def _c(c): return f'\x1b[{c}m' # Change to `return ''` to disable colors
def cmd(*args, check=True, **k): return subprocess.run(args, check=check, **k)
def command(func): commands.append(func); return func
def _default(i, spec): d=spec.defaults;m=len(spec.args)-len(d or []);return\
    (True,f'={d[i-m]}'if d[i-m]is not None else'') if i >= m else (False,'')
def _ri(s, n): s=re.sub('^[ ]*\n', '', s);s=re.sub('\n[ ]*$', '', s);\
    ls=s.split('\n');i=len(re.match('(^[ ]*)', ls[0]).group(0));\
    return '\n'.join((n * ' ') + re.sub(f'^[ ]{{{i}}}', '', l) for l in ls)
os.chdir(os.path.dirname(__file__));cli()
if len(args) == 0: print(f"{_c(1)}commands:{_c(0)}"); [print(' '.join([
    f'  {_c(96)}{f.__name__}{_c(0)}',
    *[f'{_c(36)}({a}{d[1]}){_c(0)}' if d[0] else f'{_c(36)}[{a}]{_c(0)}' \
        for a,d in ((a,_default(i, spec)) for i, a in enumerate(spec.args))],
    *([f'[...{spec.varargs}]'] if spec.varargs is not None else []),
    *([f'\n{_c(2)}{_ri(f.__doc__, 4)}{_c(0)}'] if f.__doc__ else [])
]))for spec, f in((inspect.getfullargspec(f), f) for f in commands)];exit(0)
matching_commands = [f for f in commands if f.__name__ == args[0]]
if len(matching_commands)==0:print(f'Unknown command "{args[0]}"');sys.exit(1)
try: matching_commands[0](*args[1:])
except KeyboardInterrupt: pass
except subprocess.CalledProcessError as err: sys.exit(err.returncode)
