#!/bin/sh

set -e # exit on errors

srcdir=`dirname $0`
test -z "$srcdir" && srcdir=.

autoreconf -v --force --install

if [ -z "$NOCONFIGURE" ]; then
    "$srcdir"/configure ${1+"$@"}
fi
