#!/bin/bash

export PYENV_VERSION="v1.2.22"
export PYENV_VIRTUALENV_VERSION="v1.1.5"
export PYENV_ROOT="${HOME}/.pyenv"
export PYTHON_VERSION="3.8.5"

echo "Update APT Configuration to use proxy"
if ! test -d /etc/apt/apt.conf.d
then
  sudo mkdir -p /etc/apt/apt.conf.d
fi
#sudo cp -av resources/proxy.conf /etc/apt/apt.conf.d/proxy.conf

echo "Update package index"
sudo apt-get -y update
echo "Install direnv and development packages"
sudo apt-get -y install direnv git curl build-essential zlib1g-dev libssl-dev libbz2-dev libreadline-dev libsqlite3-dev libffi-dev zsh

echo "Add custom direnv shell functions to direnv config: ${HOME}/.config/direnv/direnvrc"
mkdir -p "${HOME}/.config/direnv"
cp -av resources/direnvrc "${HOME}/.config/direnv/direnvrc"

echo "Clone github pyenv repo to ${HOME}/.pyenv"
git clone https://github.com/pyenv/pyenv.git "${HOME}/.pyenv"

echo "Pin pyenv to version ${PYENV_VERSION}"
cd "${HOME}/.pyenv"
git checkout "${PYENV_VERSION}"
cd -

# extend the path to find new installed pyenv
export PATH="${PYENV_ROOT}/bin:${PATH}"
# initialize pyenv for next installation tasks
eval "$(pyenv init -)"

echo "Clone github pyenv-virtualenv repo to ${PYENV_ROOT}"
git clone https://github.com/pyenv/pyenv-virtualenv.git "${PYENV_ROOT}/plugins/pyenv-virtualenv"

echo "Pin pyenv-virtualenv to version ${PYENV_VIRTUALENV_VERSION}"
cd "${PYENV_ROOT}/plugins/pyenv-virtualenv"
git checkout "${PYENV_VIRTUALENV_VERSION}"
cd -

eval "$(pyenv virtualenv-init -)"

echo "Install python vanilla release ${PYTHON_VERSION}"
pyenv install "${PYTHON_VERSION}"

echo "Install cookiecutter inside dedicated virtualenv as python packages"
echo "These packages are not provided some Debian/Ubuntu releases"
# create a python virtualenv for python 3.8.5 with name pydevtools-3.8.5
pyenv virtualenv --force --quiet "${PYTHON_VERSION}" "pydevtools-${PYTHON_VERSION}"
# full path to pip inside python virtualenv pydevtools-3.8.5
PYDEVTOOLS_PIP="${PYENV_ROOT}/versions/pydevtools-${PYTHON_VERSION}/bin/pip"
# install the python packages from cookiecutter template repo dep list
"${PYDEVTOOLS_PIP}" install -r requirements.txt

# Now finally write all necessary configurations to users ~/.bashrc
echo "Write the bash config updates to: ${HOME}/.bashrc"
echo 'export DIRENV_LOG_FORMAT='  >> "${HOME}/.bashrc"
echo 'source <(direnv hook bash)' >> "${HOME}/.bashrc"
echo 'export PYENV_ROOT="${HOME}/.pyenv"'      >> "${HOME}/.bashrc"
echo "export PATH=\"\${PYENV_ROOT}/bin:\${PYENV_ROOT}/versions/pydevtools-${PYTHON_VERSION}/bin:\${PATH}\"" >> "${HOME}/.bashrc"
echo 'if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi' >> "${HOME}/.bashrc"
echo 'if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi' >> "${HOME}/.bashrc"

echo "======================================================================"
echo "Bootstrapping done..."
echo ""
echo "To prevent WSL from updating your /etc/resolv.conf you should"
echo "consider to add the following config to your /etc/wsl.conf"
echo ""
echo "[network]"
echo "generateResolvConf = false"
echo ""
echo "Now finally reload your shell: source ~/.bashrc"
echo "======================================================================"
