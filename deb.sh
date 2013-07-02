#!/bin/sh -x

# Preparations
cd $(mktemp -d)

# Get original git tree
git clone -n https://github.com/krieger-od/whdd.git .

# Get latest version
VERSION=$(GIT_DIR=.git git describe --tags origin/master)

# Download, unpack and enter original source
curl --retry 5 --silent --show-error -L https://github.com/krieger-od/whdd/archive/${VERSION}.tar.gz > whdd_${VERSION}.orig.tar.gz
tar xaf whdd_${VERSION}.orig.tar.gz
cd whdd-${VERSION}

# Fetch debian sub-tree
curl --retry 5 --silent --show-error -L https://github.com/eugenesan/whdd/archive/${VERSION}-deb.tar.gz | tar --strip=1 -xz whdd-${VERSION}-deb/debian

# Update debian changelog (editing required)
dch -i

# Build and upload debian source package
dput ppa:user/ppa $(dpkg-buildpackage -S -sa 2>&1 | grep "dpkg-genchanges -S -sa >.." | cut -f2 -d'>')

# Build debian binary package
dpkg-buildpackage -b

cd -
