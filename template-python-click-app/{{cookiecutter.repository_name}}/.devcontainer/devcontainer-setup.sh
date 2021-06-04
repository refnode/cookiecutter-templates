#!/bin/sh

# initialize package manager
# update repository index
# install packages
# and cleanup
export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y --no-install-recommends git
apt-get clean
rm -rf /var/lib/apt/lists/*

# copy python pip requirements files
pip3 install -r /etc/devcontainer/requirements-dev.txt -r /etc/devcontainer/requirements-dev.txt

curl -Lo shellcheck.tar.xz https://github.com/koalaman/shellcheck/releases/download/v0.7.2/shellcheck-v0.7.2.linux.x86_64.tar.xz
tar xJvf shellcheck.tar.xz --strip-components=1 --directory=/bin shellcheck-v0.7.2/shellcheck
rm -f shellcheck.tar.xz
chmod 0755 /bin/shellcheck
