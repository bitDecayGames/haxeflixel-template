while read line; do
  echo ""

  # trim line endings off of the line
  line="${line//[$'\t\r\n']}"

  if [[ -z "${line//[[:space:]]/}" ]]; then
    # skip empty lines
    continue
  fi

  echo "Processing '${line}'"
  # this syntax interprets the line as an array
  splits=(${line})

  libName="${splits[0]}"
  libVersion="${splits[1]}"
  
  haxelib dev ${libName}

  if [[ ${libVersion} == "git" ]]; then
    gitLocation="${splits[2]}"
    gitBranchOrTag="${splits[3]}"
    if [[ -z "${gitBranchOrTag}" ]]; then
      echo "Installing ${libName} git master"
      haxelib git --never ${libName} ${gitLocation}
    else
      echo "Installing ${libName} git branch ${gitBranchOrTag}"
      haxelib git --always ${libName} ${gitLocation} ${gitBranchOrTag}
    fi
  else
    echo "Installing ${libName} version ${libVersion}"
    haxelib set ${libName} ${libVersion} --always
  fi
done <haxelib.deps
