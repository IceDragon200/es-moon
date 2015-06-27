#!/usr/bin/env bash
# ensure that packages are copied over as static entities
basalt update --install-method=copy
zip -ry es-moon.zip \
  core data packages resources scripts \
  Basaltfile \
  README.md \
  Rakefile \
  _load.rb \
  application.rb \
  config.yml \
  es-logo-128x.png \
  main.rb \
  package.sh \
  play

# restore the packages to their original state
basalt update
mv -v es-moon.zip ~/Dropbox/Public/zips
