restoreDevCommands=()

while read line; do
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

  echo ""
  echo "Processing '${line}'"
  # this syntax interprets the line as an array
  splits=(${line})

  # lines should be of the format:
  # <libName> <libVersionOrGitOrGit> <OPTIONAL_gitLocation> <OPTIONAL_gitBranchOrTag>
  libName="${splits[0]}"
  libVersionOrGit="${splits[1]}"
  gitLocation="${splits[2]}"
  gitBranchOrTag="${splits[3]}"

  libInfo="$(haxelib list ${libName})"

  # Replace all backslashes with forward slashes for bash friendliness
  # when working with windows paths
  libInfo="${libInfo//\\//}"

  if [[ ${libInfo} == *"dev"* ]]; then
    ###############################################################
    # We found a dev dependency. We want to disable this because  #
    # when dev is enabled, it seems to override any other version #
    # that is set in haxelib. However, we also want to give the   #
    # user the command to restore them as finding the correct     #
    # path again is potentially annoying.                         #
    ###############################################################

    # Disable the dev lib
    haxelib dev ${libName}

    infSplits=(${libInfo})

    # Save the file separator so we can later restore it
    SAVE_IFS=$IFS
    for i in "${infSplits[@]}"
    do
      if [[ ${i} == *"dev"* ]]; then
        # remove first and last characters which are [ and ]
        devVersionSegment="${i:1:${#i}-2}"

        # Set comma as delimiter to handle windows paths
        IFS=':'

        # Read the split words into an array
        read -a devArr <<< "${devVersionSegment}"

        # remove the first element which will be 'dev'
        unset 'devArr[0]'

        # Turn array into space-delimited string
        devPath="${devArr[@]}"

        # Replace spaces with ':' to make it back into a path
        devPathJoined=${devPath// /:}

        # Save the command to restore the depenency
        restoreDevCommands+=("haxelib dev ${libName} ${devPathJoined}")
      fi
    done
    # restore the file separator
    IFS=$SAVE_IFS
  fi

  # Now we can handle actually installing the needed version
  if [[ ${libVersionOrGit} == "git" ]]; then
    if [[ -z "${gitBranchOrTag}" ]]; then
      echo "Installing ${libName} git master"
      haxelib git --never --quiet ${libName} ${gitLocation}
    else
      echo "Installing ${libName} git branch ${gitBranchOrTag}"
      haxelib git --always --quiet ${libName} ${gitLocation} ${gitBranchOrTag}
    fi
  else
    echo "Installing ${libName} version ${libVersionOrGit}"
    haxelib set ${libName} ${libVersionOrGit} --always --quiet
  fi
done <haxelib.deps

if [ ${#restoreDevCommands[@]} -ne 0 ]; then
    echo ""
    echo "Some dev dependencies were disabled."
    echo "To restore them, run:"

    for value in "${restoreDevCommands[@]}"
    do
        echo "${value}"
    done
fi
