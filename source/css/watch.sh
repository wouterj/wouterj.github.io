#!/bin/sh

# Change all instances of ‘your-project’ to whatever you have named your
# project’s stylesheet, `cd` to the directory in which this file lives and
# simply run `sh watch.sh`.

# No minification
#sass --watch wouterj.scss:wouterj.css --style expanded

sass --watch wouterj.scss:wouterj.min.css --style compressed

exit 0
