# venvwrapper

[![Version on Pypi](https://img.shields.io/pypi/v/venvwrapper.svg)](https://pypi.python.org/pypi/venvwrapper/)

venvwrapper is a Python package that provides commands that make it easier to
manage Python virtual environments that are based on the
[venv](https://docs.python.org/3/library/venv.html) package from the Python
standard library.

Basically, venvwrapper is to venv what
[virtualenvwrapper](https://pypi.org/project/virtualenvwrapper/) is to
[virtualenv](https://pypi.org/project/virtualenv/):
It provides more convenient commands to make the management of virtual
environments easier. However, virtualenv supports only a subset of the
functionality of virtualenvwrapper.

venvwrapper combines nicely with virtualenvwrapper:
The virtual environments created by both packages can reside in the same
directory side by side, regardless which of the two created them. That
allows you to gradually convert your existing virtualenv/virtualenvwrapper
based environments to be based on venv.

Since Python 3.5, venv is the recommended tool for Python virtual environments,
as stated in
[Creating virtual environments](https://docs.python.org/3/library/venv.html#creating-virtual-environments):
```
The use of venv is now recommended for creating virtual environments.
```

Also note [this tweet](https://x.com/gvanrossum/status/1319328122618048514) by
the BDFL on the topic:
```
I use venv (in the stdlib) and a bunch of shell aliases to quickly switch.
```

## Supported shells

At this point, venvwrapper supports bash and zsh. More shells may work, but
not with tab completion.

Contributions to add support for more shells are welcome!

## Installation

* Install the venvwrapper Python package into your default system Python 3 (i.e.
  with no virtual environment active):

  ```
  $ pip3 install --break-system-packages venvwrapper
  ```

  This installs the `venvwrapper.sh` script so that it is available in the
  PATH.

  Note that this Python package has no Python dependencies, so it does not break
  your system Python in any way.

* Verify that `venvwrapper.sh` is available in the PATH:

  ```
  $ which venvwrapper.sh
  /opt/homebrew/bin/venvwrapper.sh
  ```

* Add the following to your shell startup script (e.g. `~/.bash_profile` or
  `~/.zshrc`) in a place where no Python virtual environment is active:

  ```
  VENV_HOME=$HOME/.virtualenvs
  venv_wrapper=$(which venvwrapper.sh)
  if [[ -n $venv_wrapper ]]; then
      source $venv_wrapper
  fi
  ```

  `VENV_HOME` specifies the directory under which the directories for the
  virtual environments are created. If not set, it defaults to `~/.venv`.

  `VENV_HOME` can be set to the same directory that is used for
  virtualenvwrapper (i.e. its `WORKON_HOME` directory).

* Verify the installation by starting a new terminal session, and invoking:

  ```
  $ mkvenv --help
  ```

  This should display the help:

  ```
  mkvenv - Create and activate a new Python virtual environment

  Usage: mkvenv ENV [PYTHON]

  Where:
    ENV      Name of the new virtual environment
    PYTHON   Python command to use for creation. Default: python3
  ```

## Usage

All commands provided by venvwrapper explain their usage when called with `-h`
or `--help`:

* `venv` - activate an existing virtual environment
* `mkvenv` - create and activate a new virtual environment
* `rmvenv` - remove one or more virtual environments
* `lsvenv` - list existing virtual environments

The `venv` and `rmvenv` commands support tab completion.

The standard `deactivate` script provided by the virtual environment is used
to deactivate the current virtual environment.

An active virtual environment is indicated by an `(env)` prefix in the command
prompt. That is the normal behavior of venv.

The commands provided by venvwrapper are actually shell functions, so they
cannot be used in other scripts. If you need to activate virtual environments
in other scripts, call the `activate` script provided by the virtual
environment.

If venvwrapper is configured to use the same directory for its virtual
environments as virtualenv/virtualenvwrapper, then the commands that operate on
existing virtual environments can be used on either kind of virtual environment,
regardless of which package created it. For example, `lsvenv` will list both
kinds of virtual environments.

## Development and contributions

The venvwrapper project welcomes contributions.

For how to set up a development environment, see [DEVELOP.md](DEVELOP.md).

## References

The venvwrapper.sh script provided in this package is based on the script
by Ismail Demirbilek at
https://gist.github.com/dbtek/fb2ddccb18f0cf63a654ea2cc94c8f19.
