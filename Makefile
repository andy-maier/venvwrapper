# Makefile for venvwrapper project
#
# Use this to get information on the targets:
#   make  - or -  make help
#
# It is recommended to run this Makefile in a virtual Python environment,
# because Python packages will be installed automatically.
#
# Supported OS platforms:
#     Windows (native)
#     Linux (any)
#     macOS/OS-X
#
# OS-level commands used by this Makefile (to be provided manually):
#   On native Windows:
#     cmd (providing: del, copy, rmdir, set)
#     where
#   On Linux and macOS:
#     rm, find, cp, env, sort, which, uname
#
# Environment variables:
#   PYTHON_CMD: Python command to use (OS-X needs to distinguish Python 2/3)
#   PIP_CMD: Pip command to use (OS-X needs to distinguish Python 2/3)

# No built-in rules needed:
MAKEFLAGS += --no-builtin-rules
.SUFFIXES:

# Python / Pip commands
ifndef PYTHON_CMD
  PYTHON_CMD := python
endif
ifndef PIP_CMD
  PIP_CMD := pip
endif

# Package name
package_name := venvwrapper

# Package version, modified by bumpversion
package_version := 0.8.0

python_mn_version := $(shell $(PYTHON_CMD) -c "import sys; sys.stdout.write('{}.{}'.format(sys.version_info[0], sys.version_info[1]))")
pymn := $(shell $(PYTHON_CMD) -c "import sys; sys.stdout.write('py{}{}'.format(sys.version_info[0], sys.version_info[1]))")

dist_dir := dist
bdist_file := $(dist_dir)/$(package_name)-$(package_version)-py3-none-any.whl
sdist_file := $(dist_dir)/$(package_name)-$(package_version).tar.gz

# Dependencies for installation
install_dependent_files := \
    pyproject.toml \
		venvwrapper.sh \

# Dependencies of the distribution archives
dist_dependent_files := \
    $(install_dependent_files) \
    LICENSE \
    README.md \

# Directory for .done files
done_dir := done

.PHONY: help
help:
	@echo "Makefile for project $(package_name)"
	@echo "Package version: $(package_version)"
	@echo "Python version: $(python_mn_version)"
	@echo "Targets:"
	@echo "  install    - Install this Python package"
	@echo "  develop    - Install Python packages needed for development"
	@echo "  build      - Build the distribution files in $(dist_dir)"
	@echo "  clean      - Remove any temporary files"
	@echo "  clobber    - Remove any build products"
	@echo 'Environment variables:'
	@echo '  PYTHON_CMD=... - Name of python command. Default: python'
	@echo '  PIP_CMD=... - Name of pip command. Default: pip'

.PHONY: install
install: $(done_dir)/install_$(pymn).done
	@echo "Makefile: $@ done."

.PHONY: develop
develop: $(done_dir)/develop_$(pymn).done
	@echo "Makefile: $@ done."

.PHONY: build
build: $(bdist_file) $(sdist_file)
	@echo "Makefile: $@ done."

.PHONY: clean
clean:
	rm -f MANIFEST MANIFEST.in
	rm -rf build *.egg-info
	@echo "Makefile: $@ done."

.PHONY: clobber
clobber: clean
	rm -f $(done_dir)/*.done
	@echo "Makefile: $@ done."

$(done_dir)/install_$(pymn).done: $(install_dependent_files)
	@echo "Makefile: Installing package"
	rm -f $@
	$(PYTHON_CMD) -m pip install .
	@echo "Makefile: Done installing package"
	echo "done" >$@

$(done_dir)/develop_$(pymn).done: requirements-develop.txt
	@echo "Makefile: Installing prerequisites for development"
	rm -f $@
	$(PYTHON_CMD) -m pip install -r requirements-develop.txt
	@echo "Makefile: Done installing prerequisites for development"
	echo "done" >$@

$(sdist_file): $(done_dir)/develop_$(pymn).done $(dist_dependent_files)
	@echo "Makefile: Building the source distribution archive: $(sdist_file)"
	$(PYTHON_CMD) -m build --sdist --outdir $(dist_dir) .
	@echo "Makefile: Done building the source distribution archive: $(sdist_file)"

$(bdist_file): $(done_dir)/develop_$(pymn).done $(dist_dependent_files)
	@echo "Makefile: Building the wheel distribution archive: $(bdist_file)"
	$(PYTHON_CMD) -m build --wheel --outdir $(dist_dir) -C--universal .
	@echo "Makefile: Done building the wheel distribution archive: $(bdist_file)"
