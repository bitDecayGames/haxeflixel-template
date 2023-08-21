#!/usr/bin/env bash

./bin/export_ase.sh

lime test html5 -debug ${@#}