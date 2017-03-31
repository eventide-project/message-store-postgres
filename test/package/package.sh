#!/usr/bin/env bash

set -ue

rm -f *.gem
rm -rf test/package/installed

for gemspec in *.gemspec; do
  echo "Building $gemspec"
  gem build $gemspec --norc
done

for gem in *.gem; do
  echo "Installing $gem"
  gem install $gem \
    --install-dir ./test/package/installed \
    --norc \
    --no-document \
    --no-ri
done

GEM_PATH=test/package/installed test/package/installed/bin/evt-pg-delete
GEM_PATH=test/package/installed test/package/installed/bin/evt-pg-create
GEM_PATH=test/package/installed test/package/installed/bin/evt-pg-recreate
