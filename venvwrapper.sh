#!/bin/bash
# Wrapper script for managing Python virtual environments using 'venv' from
# the standard library of Python 3.
# Based on https://gist.github.com/dbtek/fb2ddccb18f0cf63a654ea2cc94c8f19.
#
# Setup in .bashrc / .bash_profile / .zshrc:
#   VENV_HOME=path-to-venvs   # Can be same path as for virtualenvwrapper
#   source $(which venvwrapper.sh)
#
# Usage:
#   mkvenv env1             # creates and activates venv using python3 command
#   mkvenv env1 python3.12  # creates and activates venv using specified python command
#   venv env1               # activates virtual environment
#   deactivate              # deactivates current virtual environment
#   rmvenv env1             # removes virtual environment
#   rmvenv env1 env2        # removes multiple virtual environments
#   lsvenv                  # lists all virtual environments

if [[ -z "$VENV_HOME" ]]; then
    export VENV_HOME="$HOME/.venv"
fi
[[ -d $VENV_HOME ]] || mkdir -p $VENV_HOME

lsvenv() {
    if [ "$1" = "-h" -o "$1" = "--help" ]; then
        echo "lsvenv - List Python virtual environments"
        echo ""
        echo "Usage: lsvenv"
        return 2
    elif [ $# -gt 0 ]; then
        echo "Error: Too many parameters - invoke with -h or --help for usage."
        return 1
    else
        ls --color=never "$VENV_HOME"
    fi
}

venv() {
    if [ $# -eq 0 -o "$1" = "-h" -o "$1" = "--help" ]; then
        echo "venv - Activate a Python virtual environment"
        echo ""
        echo "Usage: venv ENV"
        echo ""
        echo "Where:"
        echo "  ENV      Name of the virtual environment. Use 'lsvenv' to list"
        return 2
    elif [ $# -gt 1 ]; then
        echo "Error: Too many parameters - invoke with -h or --help for usage."
        return 1
    elif [ -d "$VENV_HOME/$1" ]; then
        echo "Activating virtual environment '$1'."
        source "$VENV_HOME/$1/bin/activate"
    else
        echo "Error: Virtual environment '$1' does not exist in '$VENV_HOME'."
        return 1
    fi
}

mkvenv() {
    if [ $# -eq 0 -o "$1" = "-h" -o "$1" = "--help" ]; then
        echo "mkvenv - Create and activate a new Python virtual environment"
        echo ""
        echo "Usage: mkvenv ENV [PYTHON]"
        echo ""
        echo "Where:"
        echo "  ENV      Name of the new virtual environment"
        echo "  PYTHON   Python command to use for creation. Default: python3"
        return 2
    elif [ $# -gt 2 ]; then
        echo "Error: Too many parameters - invoke with -h or --help for usage."
        return 1
    elif [ -d "$VENV_HOME/$1" ]; then
        echo "Error: Virtual environment '$1' already exists in '$VENV_HOME/$1'."
        return 1
    else
        if [ $# -eq 2 ]; then
            python=$2
        else
            python=python3
        fi
        echo "Creating new virtual environment '$1' in '$VENV_HOME/$1' using '$python'."
        $python -m venv "$VENV_HOME/$1"
        venv "$1"
    fi
}

rmvenv() {
    if [ $# -eq 0 -o "$1" = "-h" -o "$1" = "--help" ]; then
        echo "rmvenv - Remove one or more Python virtual environments"
        echo ""
        echo "Usage: rmvenv ENV [ENV ...]"
        echo ""
        echo "Where:"
        echo "  ENV      Name of the virtual environment. Use 'lsvenv' to list"
        return 2
    else
        current_venv=$(basename "${VIRTUAL_ENV:-}")
        for env in "$@"; do
            if [ -d "$VENV_HOME/$env" ]; then
                if [ "$env" = "$current_venv" ]; then
                    echo "Deactivating current virtual environment '$env'."
                    deactivate
                fi
                echo "Removing virtual environment '$env' in '$VENV_HOME'."
                rm -rf "$VENV_HOME/$env"
            else
                echo "Virtual environment '$env' does not exist in '$VENV_HOME'."
            fi
        done
    fi
}

# Tab completion
if [ -n "${BASH:-}" ] ; then
    _venvwrapper_venvs_complete () {
        local cur="${COMP_WORDS[COMP_CWORD]}"
        COMPREPLY=( $(compgen -W "`lsvenv`" -- ${cur}) )
    }
    complete -o default -o nospace -F _venvwrapper_venvs_complete venv
    complete -o default -o nospace -F _venvwrapper_venvs_complete rmvenv
elif [ -n "$ZSH_VERSION" ] ; then
    _venvwrapper_venvs_complete () {
        reply=( $(lsvenv) )
    }
    compctl -K _venvwrapper_venvs_complete venv rmvenv
fi
