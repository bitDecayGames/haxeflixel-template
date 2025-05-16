#!/usr/bin/env bash

./bin/precompile.sh

lime test html5 -debug ${@#}