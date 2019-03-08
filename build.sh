#!/usr/bin/env sh
# make the script fail for any failed command
set -e
# make the script display the commands it runs to help debugging failures
set -x

# build site
JEKYLL_ENV=production bundle exec jekyll build
touch _site/.nojekyll
