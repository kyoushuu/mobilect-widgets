#!/bin/sh

set -e # exit on errors

srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.

git submodule update --init --recursive
autoreconf -v --force --install
intltoolize -f

if [ -z "$NOCONFIGURE" ]; then
    "$srcdir"/configure ${1+"$@"}
fi
