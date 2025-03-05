#!/bin/bash

# for easier debug, uncomment the next line to echo commands as they are run
# set -x

# Colors to make output more readable
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
NC='\033[0m'

restoreDevCommands=()

# check if we should be running locally
if [[ -z "$INSTALL_GLOBAL" ]]; then
  echo "Initializing local haxelib"
  haxelib newrepo
fi

while read -r line; do
  # trim line endings off of the line
  line="${line//[$'\t\r\n']}"

  if [[ -z "${line//[[:space:]]/}" ]]; then
    # skip empty lines
    continue
  fi

  if [[ $line == \#* ]]; then
    # skip lines beginning with '#'
    continue
  fi

  # this syntax interprets the line as an array
  splits=(${line})

  # lines should be of the format:
  # <libName> <libVersionOrGitOrGit> <OPTIONAL_gitLocation> <OPTIONAL_gitBranchOrTag>
  libName="${splits[0]}"
  libVersionOrGit="${splits[1]}"
  gitLocation="${splits[2]}"
  gitBranchOrTag="${splits[3]}"

  # find the line that has our library on it as `haxelib list` may return multiples
  # if our lib's name is a substring of another lib name
  libInfo="$(haxelib list ${libName} | sed -n -e /^${libName}:/p)"

  # regex to pull out a string between []'s, example `myLib: 1.1 1.5 [2.0] 2.1` will yield `2.0`
  currentVersionRegex="s/^.*\[\(.*\)\].*$/\1/p"
  currentVersion="$(echo ${libInfo} | sed -n ${currentVersionRegex})"

  # Replace all backslashes with forward slashes for bash friendliness
  # when working with windows paths
  currentVersion="${currentVersion//\\//}"

  if [[ ${currentVersion} == *"dev"* ]]; then
    ###############################################################
    # We found a dev dependency. We want to disable this because  #
    # when dev is enabled, it seems to override any other version #
    # that is set in haxelib. However, we also want to give the   #
    # user the command to restore them as finding the correct     #
    # path again is potentially annoying.                         #
    ###############################################################

    echo -e "${YELLOW}${libName} is on a dev version${NC}"

    # Disable the dev lib
    haxelib dev ${libName}

    infSplits=(${libInfo})

    # Save the file separator so we can later restore it
    SAVE_IFS=$IFS

    # Set comma as delimiter to handle windows paths
    IFS=':'

    # Read the split words into an array
    read -a devArr <<< "${currentVersion}"

    # remove the first element which will be 'dev'
    unset 'devArr[0]'

    # Turn array into space-delimited string
    devPath="${devArr[@]}"

    # Replace spaces with ':' to make it back into a path
    devPathJoined=${devPath// /:}

    # Save the command to restore the depenency
    restoreDevCommands+=("haxelib dev ${libName} ${devPathJoined}")

    # restore the file separator
    IFS=$SAVE_IFS
  fi

  # Now we can handle actually installing the needed version
  if [[ ${libVersionOrGit} == "git" ]]; then
    if [[ -z "${gitBranchOrTag}" ]]; then
      echo -e "${GREEN}Installing ${libName} git master${NC}"
      haxelib git --always ${libName} ${gitLocation}
    else
      echo -e "${GREEN}Installing ${libName} git branch ${gitBranchOrTag}${NC}"
      # commands that can hijack standard in will cause our file read loop to break per: https://stackoverflow.com/a/35208546
      # Adding this echo prevents that and allows our loop to continue
      echo "" | haxelib git --always ${libName} ${gitLocation} ${gitBranchOrTag}
    fi
  else
    echo -e "${GREEN}Installing ${libName} version ${libVersionOrGit}${NC}"
    haxelib set ${libName} ${libVersionOrGit} --always --quiet
  fi

  if [[ ${libName} == "lime" ]] && [[ -z "$INSTALL_GLOBAL" ]]; then
    # this is a one-off just to make sure that lime is configured properly in our local repo
    echo "Running lime setup"
    haxelib --always run lime setup
  fi
done <haxelib.deps


if [ ${#restoreDevCommands[@]} -ne 0 ]; then
    # echo ""
    echo -e "${YELLOW}Some dev dependencies were disabled."
    echo "To restore them, run:"

    for value in "${restoreDevCommands[@]}"
    do
        echo "${value}"
    done
    echo -e "${NC}"
fi
