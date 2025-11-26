#!/bin/bash

# Overwrite GIT_REVISION with first argument if passed
if [ -n "$1" ]; then
  export GIT_REVISION=$1
fi

docker compose build $@
