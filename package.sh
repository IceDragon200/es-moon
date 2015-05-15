#!/usr/bin/env bash
# ensure that packages are copied over as static entities
basalt update --install-method=copy
zip -ry es-moon.zip \
  core data packages resources scripts \
  Basaltfile \
  README.md \
  Rakefile \
  config.yml \
  es-logo-128x.png \
  play

# restore the packages to their original state
basalt update
mv -v es-moon.zip ~/Dropbox/Public/zips
