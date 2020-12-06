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

  if [[ ${libVersion} == "git" ]]; then
    gitLocation="${splits[2]}"
    haxelib git ${libName} ${gitLocation} --never
  else
    echo "Installing ${libName} version ${libVersion}"
    echo "haxelib set ${libName} ${libVersion} --always"
    haxelib set ${libName} ${libVersion} --always
  fi
done <haxelib.deps