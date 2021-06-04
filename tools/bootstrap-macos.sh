#!/bin/bash

export PYENV_VERSION="v1.2.22"
export PYENV_VIRTUALENV_VERSION="v1.1.5"
export PYENV_ROOT="${HOME}/.pyenv"
export PYTHON_VERSION="3.8.5"

# env vars used to compile python on macos with openssl from homebrew
export PYTHON_CONFIGURE_OPTS="--enable-shared --with-openssl=$(brew --prefix openssl)"
export LDFLAGS="-L/usr/local/opt/openssl@1.1/lib"
export CPPFLAGS="-I/usr/local/opt/openssl@1.1/include"
export PKG_CONFIG_PATH="/usr/local/opt/openssl@1.1/lib/pkgconfig"

if ! which brew
then
  echo "This bootstrap script depends on homebrew."
  echo "https://brew.sh/"
  exit 1
fi

if ! test -x /Library/Developer/CommandLineTools/usr/bin/git
then
  echo "Please ensure you have Xcode or the Xcode cmdline tools present"
  echo "To install on shell: xcode-select --install"
  exit 1
fi

echo "Install direnv pre-commit cookiecutter and development packages"
brew install direnv pre-commit cookiecutter

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

# Now finally write all necessary configurations to users ~/.bashrc
echo "Write the bash config updates to: ${HOME}/.bashrc"
echo "# env vars used to compile python on macos with openssl from homebrew" >> "${HOME}/.bashrc"
echo "export PYTHON_CONFIGURE_OPTS=\"--enable-shared --with-openssl=\$(brew --prefix openssl)\"" >> "${HOME}/.bashrc"
echo "export LDFLAGS=\"-L/usr/local/opt/openssl@1.1/lib\"" >> "${HOME}/.bashrc"
echo "export CPPFLAGS=\"-I/usr/local/opt/openssl@1.1/include\"" >> "${HOME}/.bashrc"
echo "export PKG_CONFIG_PATH=\"/usr/local/opt/openssl@1.1/lib/pkgconfig\"" >> "${HOME}/.bashrc"
echo "export DIRENV_LOG_FORMAT="  >> "${HOME}/.bashrc"
echo "source <(direnv hook bash)" >> "${HOME}/.bashrc"
echo "export PYENV_ROOT=\"\${HOME}/.pyenv\"" >> "${HOME}/.bashrc"
echo "export PATH=\"\${PYENV_ROOT}/bin:\${PATH}\"" >> "${HOME}/.bashrc"
echo "if which pyenv > /dev/null; then eval \"\$(pyenv init -)\"; fi" >> "${HOME}/.bashrc"
echo "if which pyenv-virtualenv-init > /dev/null; then eval \"\$(pyenv virtualenv-init -)\"; fi" >> "${HOME}/.bashrc"

if test -f "${HOME}/.zshrc"
then
  echo "Found a zsh configuration file: ${HOME}/.zshrc"
  echo "Appending configuration"
  echo "# env vars used to compile python on macos with openssl from homebrew" >> "${HOME}/.zshrc"
  echo "export PYTHON_CONFIGURE_OPTS=\"--enable-shared --with-openssl=\$(brew --prefix openssl)\"" >> "${HOME}/.zshrc"
  echo "export LDFLAGS=\"-L/usr/local/opt/openssl@1.1/lib\"" >> "${HOME}/.zshrc"
  echo "export CPPFLAGS=\"-I/usr/local/opt/openssl@1.1/include\"" >> "${HOME}/.zshrc"
  echo "export PKG_CONFIG_PATH=\"/usr/local/opt/openssl@1.1/lib/pkgconfig\"" >> "${HOME}/.zshrc"
  echo "export DIRENV_LOG_FORMAT="  >> "${HOME}/.zshrc"
  echo "source <(direnv hook zsh)" >> "${HOME}/.zshrc"
  echo "export PYENV_ROOT=\"\${HOME}/.pyenv\""      >> "${HOME}/.zshrc"
  echo "export PATH=\"\${PYENV_ROOT}/bin:\${PATH}\"" >> "${HOME}/.zshrc"
  echo "if which pyenv > /dev/null; then eval \"\$(pyenv init -)\"; fi" >> "${HOME}/.zshrc"
  echo "if which pyenv-virtualenv-init > /dev/null; then eval \"\$(pyenv virtualenv-init -)\"; fi" >> "${HOME}/.zshrc"
fi

echo "======================================================================"
echo "Bootstrapping done..."
echo "Now finally reload your shell, depending on the shell you use:"
echo "    source ~/.bashrc"
echo "    source ~/.zshrc"
echo "======================================================================"
