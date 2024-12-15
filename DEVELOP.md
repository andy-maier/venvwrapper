# Development of venvwrapper

## Setting up a development environment

* Set up a virtual Python environment

  Check `pyproject.toml` for supported Python versions.

  You can use venvwrapper itself for creating the virtual environment:

  ```
  pip3 install --break-system-packages venvwrapper
  mkvenv venv313 python3.13
  ```

* Clone this repository

  ```
  git clone https://github.com/andy-maier/venvwrapper.git
  cd venvwrapper
  ```

* Install the Python packages for development:

  ```
  make develop
  ```

## Releasing a version

To release a version of this package to Pypi, follow these steps:

1.  Create a topic branch for releasing

    ```
    branch=release_$(date +"%Y-%m-%d")
    git checkout master
    git pull
    git checkout -b $branch
    ```

2.  Set the version to be released

    Decide which part of the version to bump:

    ```
    bumpversion patch  # for fixes
    bumpversion minor  # for added functionality
    bumpversion major  # for incompatible changes
    ```

    This increases the version in the relevant files and creates a commit with
    the changes.

3.  Push the topic branch

    ```
    git push --set-upstream origin $branch
    ```

4.  Create a PR from that topic branch on Github

5.  Merge the PR on Github

6.  Trigger the release by pushing a tag, and clean up the topic branch

    ```
    git checkout master
    git pull
    git branch -D $branch
    git branch -D -r origin/$branch
    version=$(grep current_version .bumpversion.cfg | cut -d '=' -f 2 | sed -e 's/ //g')
    git tag $version
    git push --tags
    ```

    This causes the "publish" Github Actions workflow to run, which:

    * publishes the new version on Pypi
    * creates a release on the Github repository

7.  Wait for the "publish" workflow to complete and check for success

8.  Verify that the new version is on Pypi

    https://pypi.org/project/venvwrapper/
