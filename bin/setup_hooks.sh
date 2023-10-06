#!/usr/bin/env bash

set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
echo "Copying hooks into .git directory"
cp -a $SCRIPT_DIR/hooks/. $SCRIPT_DIR/../.git/hooks/
echo "Done"