#!/bin/bash
if [ -z $MOON_PATH ]; then
  echo "Please set MOON_PATH"
  exit
fi

ln -s "${MOON_PATH}/bin/host/resources/shaders" "./shaders"