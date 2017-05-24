#!/usr/bin/env bash

set -e

echo
echo 'Installing local gems'
echo '= = ='

source ./set_local_gem_path.sh

echo
echo 'Removing gem files'
echo '- - -'
! rm -v *.gem

echo
echo 'Building gems'
echo '- - -'
for gemspec in *.gemspec; do
  echo "- $gemspec"
  gem build $gemspec
done

if [ -z ${POSTURE+x} ]; then
  echo "(POSTURE is not set. Using \"operational\" by default.)"
  posture="operational"
else
  posture=$POSTURE
fi

echo
echo "Installing gems locally (posture: $posture)"
echo '- - -'
for gem in *.gem; do
  echo "($gem)"
  cmd="gem install $gem --install-dir ./gems"

  if [ operational != "$posture" ]; then
    cmd="$cmd --development"
  fi

  echo $cmd
  ($cmd) || exit 1
done

echo '= = ='
echo '(done)'
echo
